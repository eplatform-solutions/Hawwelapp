import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/transfer_status_theme.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_ressponse_transfer.dart';
import 'package:hawwel/featue/bootom_navigator.dart';
import 'package:hawwel/featue/notifation/notification_navigation.dart';
import 'package:hawwel/firbeas/notifaction.dart';

class ConfermScreen extends StatefulWidget {
  const ConfermScreen({super.key, required this.transfer});
  final TransferResponseModel transfer;

  @override
  State<ConfermScreen> createState() => _ConfermScreenState();
}

class _ConfermScreenState extends State<ConfermScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  BlockchainWalletModel? selectedWallet;
  StreamSubscription<RemoteMessage>? _messagingSubscription;
  StreamSubscription<Map<String, dynamic>>? _notificationStreamSubscription;
  Timer? _statusPollTimer;
  bool _paymentHandled = false;
  bool _isPolling = false;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _apiService = ApiService(dio: Dio());

    if (widget.transfer.blockchainWallets.isNotEmpty) {
      selectedWallet = widget.transfer.blockchainWallets.first;
    }

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _startListeningForStatus();
    _statusPollTimer = Timer.periodic(
      const Duration(seconds: 12),
      (_) => _pollTransferStatusFromApi(),
    );
    Future<void>.delayed(
      const Duration(seconds: 4),
      _pollTransferStatusFromApi,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _pollTransferStatusFromApi();
    }
  }

  Map<String, dynamic> _normalizePaymentPayload(Map<String, dynamic> raw) {
    if (raw.containsKey('data')) {
      final inner = raw['data'];
      if (inner is String && inner.isNotEmpty) {
        try {
          final decoded = jsonDecode(inner);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
        } catch (_) {}
      } else if (inner is Map) {
        return Map<String, dynamic>.from(inner);
      }
    }
    return raw;
  }

  bool _matchesCurrentTransfer(Map<String, dynamic> data) {
    final transferId = widget.transfer.id.trim();
    final transferNumber = widget.transfer.transferNumber.toString().trim();
    final candidates = <String>{
      data['transferId']?.toString() ?? '',
      data['_id']?.toString() ?? '',
      data['id']?.toString() ?? '',
    }..removeWhere((value) => value.trim().isEmpty);

    for (final candidate in candidates) {
      final normalized = candidate.trim();
      if (normalized == transferId || normalized == transferNumber) {
        return true;
      }
    }
    return false;
  }

  String _normalizeStatus(String? raw) =>
      (raw ?? '').trim().toLowerCase().replaceAll('_', '-');

  void _handlePaymentStatusPayload(Map<String, dynamic> raw) {
    if (_paymentHandled || !mounted) return;

    final data = _normalizePaymentPayload(raw);
    if (!_matchesCurrentTransfer(data)) return;

    final status = _normalizeStatus(data['status']?.toString());
    if (status.isEmpty || status == 'pending') return;

    if (isAwaitingPaymentStatus(status)) return;
    _paymentHandled = true;
    debugPrint(
      '💳 [PAYMENT] status update | transfer=${widget.transfer.id} | status=$status | payload=$data',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      NotificationNavigation.openFromNotificationData(
        context,
        data,
        allowAwaitingPaymentRoute: false,
      ).then((opened) {
        if (!opened) {
          _paymentHandled = false;
        }
      });
    });
  }

  void _startListeningForStatus() {
    _messagingSubscription = FirebaseMessaging.onMessage.listen((message) {
      if (message.data.isNotEmpty) {
        _handlePaymentStatusPayload(Map<String, dynamic>.from(message.data));
      }
    });

    _notificationStreamSubscription = Notifications.onMessageStream.listen(
      _handlePaymentStatusPayload,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data.isNotEmpty) {
        _handlePaymentStatusPayload(Map<String, dynamic>.from(message.data));
      }
    });
  }

  Future<void> _pollTransferStatusFromApi() async {
    if (_paymentHandled || _isPolling || !mounted) return;
    _isPolling = true;
    try {
      final response = await _apiService.get(
        endpoint:
            '/transfers/all-transfers-inside-the-page?pageNumber=1&pageSize=30',
      );
      final body = response.data;
      if (body is! Map) return;

      final groups = body['data']?['transfers'];
      if (groups is! List) return;

      for (final group in groups) {
        if (group is! Map) continue;
        final transfers = group['transfers'];
        if (transfers is! List) continue;

        for (final item in transfers) {
          if (item is! Map) continue;
          final map = Map<String, dynamic>.from(item);
          if (map['_id']?.toString() != widget.transfer.id) continue;

          final status = _normalizeStatus(map['status']?.toString());
          if (status.isEmpty || status == 'pending') return;

          debugPrint(
            '💳 [PAYMENT] poll detected | id=${map['_id']} | status=$status | paid=${map['paid']}',
          );

          if (!mounted) return;
          final bool isArabic =
              Localizations.localeOf(context).languageCode == 'ar';
          final city = map['city'];
          final area = map['area'];
          final receiver = map['receiver'];

          _handlePaymentStatusPayload({
            'transferId': map['_id']?.toString() ?? widget.transfer.id,
            'status': status,
            'amount': map['amount']?.toString() ?? widget.transfer.amount,
            'paid': map['paid']?.toString() ?? map['amount']?.toString(),
            'symbol': map['symbol']?.toString() ?? widget.transfer.symbol,
            'fullName': receiver is Map
                ? receiver['fullName']?.toString()
                : widget.transfer.receiver.fullName,
            'city': city is Map
                ? (isArabic ? city['ar'] : city['en'])?.toString()
                : '',
            'area': area is Map
                ? (isArabic ? area['ar'] : area['en'])?.toString()
                : '',
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('⚠️ [PAYMENT] poll failed: $e');
    } finally {
      _isPolling = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messagingSubscription?.cancel();
    _notificationStreamSubscription?.cancel();
    _statusPollTimer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _copyAddress() {
    if (selectedWallet == null) return;
    Clipboard.setData(ClipboardData(text: selectedWallet!.address));
    HapticFeedback.mediumImpact();
    final branding = appBrandingNotifier.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content: CustomSnackBar(
          backgroundColor: branding.success,
          message: AppTranslations.getTextStatic(
            context,
            "The title has been copied",
          ),
          imagePath: AppImages.doneimage,
        ),
      ),
    );
  }

  void _copyAmount() {
    Clipboard.setData(
      ClipboardData(text: _formatTransferAmount(widget.transfer.amount)),
    );
    HapticFeedback.mediumImpact();
    final branding = appBrandingNotifier.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content: CustomSnackBar(
          backgroundColor: branding.success,
          message: AppTranslations.getTextStatic(
            context,
            "The title has been copied",
          ),
          imagePath: AppImages.doneimage,
        ),
      ),
    );
  }

  void _shareAddress() {
    if (selectedWallet == null) return;
    SharePlus.instance.share(
      ShareParams(text: selectedWallet!.address, subject: 'External payment address'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      },
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: branding.screenBg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Gradient header ──────────────────────────────────
              SliverToBoxAdapter(
                child: _buildHeader(context, isArabic, branding),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 8.h),

                    // ── Wallet address card ───────────────────────
                    if (selectedWallet != null) ...[
                      _WalletCard(
                        branding: branding,
                        wallet: selectedWallet!,
                        allWallets: widget.transfer.blockchainWallets,
                        onWalletChanged: (w) =>
                            setState(() => selectedWallet = w),
                        symbol: widget.transfer.symbol,
                        amountText: _formatTransferAmount(
                          widget.transfer.amount,
                        ),
                        feeAmountText: _formatTransferAmount(
                          widget.transfer.amount * widget.transfer.fee / 100,
                        ),
                        pulseAnim: _pulseAnim,
                        onCopy: _copyAddress,
                        onShare: _shareAddress,
                        onCopyAmount: _copyAmount,
                        context: context,
                      ),
                    ] else
                      _SelectNetworkHint(branding: branding, context: context),

                    SizedBox(height: 12.h),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTransferAmount(num amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
  }

  Widget _buildHourglassIcon() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) =>
          Transform.scale(scale: _pulseAnim.value, child: child),
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.15),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.hourglass_top_rounded,
          color: Colors.white,
          size: 28.sp,
        ),
      ),
    );
  }

  Widget _headerPill({
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: child,
    );
  }

  TextStyle _headerPillLabelStyle({Color? color}) {
    return GoogleFonts.cairo(
      fontSize: 11.sp,
      color: color ?? Colors.white.withValues(alpha: 0.9),
      fontWeight: FontWeight.w500,
      height: 1.2,
    );
  }

  TextStyle _headerPillValueStyle({Color? color}) {
    return GoogleFonts.cairo(
      fontSize: 13.sp,
      color: color ?? Colors.white,
      fontWeight: FontWeight.w800,
      height: 1.2,
    );
  }

  Widget _buildHeaderInfoColumn(
    BuildContext context,
    AppBrandingConfig branding,
  ) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final amountText = _formatTransferAmount(widget.transfer.amount);
    const pillSpacing = 6.0;

    final referenceBadge = _headerPill(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_rounded,
            color: Colors.white.withValues(alpha: 0.9),
            size: 15.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            AppTranslations.getText(context, 'Transfer number'),
            style: _headerPillLabelStyle(),
          ),
          SizedBox(width: 6.w),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '${widget.transfer.transferNumber}',
              style: _headerPillValueStyle(),
            ),
          ),
        ],
      ),
    );

    final amountChip = _headerPill(
      backgroundColor: Colors.white,
      borderColor: Colors.white.withValues(alpha: 0.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SendCurrencyHelper.buildCoinIcon(
            symbol: widget.transfer.symbol,
            height: 18.h,
            width: 18.w,
            iconColor: Colors.white,
          ),
          SizedBox(width: 6.w),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '$amountText ${SendCurrencyHelper.displayLabelForSymbol(widget.transfer.symbol, isArabic: isArabic)}',
              style: _headerPillValueStyle(color: branding.accent),
            ),
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          isArabic
              ? 'اتبع تعليمات الدفع الخارجي لإكمال طلبك'
              : 'Follow the external payment instructions to complete your request',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.25,
          ),
        ),
        SizedBox(height: pillSpacing.h),
        referenceBadge,
        SizedBox(height: pillSpacing.h),
        amountChip,
      ],
    );
  }

  Widget _buildBackButton(BuildContext context, bool isArabic) {
    return AppBackButton(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isArabic,
    AppBrandingConfig branding,
  ) {
    final hourglass = _buildHourglassIcon();
    final info = _buildHeaderInfoColumn(context, branding);

    return Container(
      decoration: BoxDecoration(
        gradient: branding.buildHeaderGradient(),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 44.w),
                child: Center(child: info),
              ),
              Positioned(
                top: 0,
                left: isArabic ? 0 : null,
                right: isArabic ? null : 0,
                child: hourglass,
              ),
              Positioned(
                top: 0,
                right: isArabic ? 0 : null,
                left: isArabic ? null : 0,
                child: _buildBackButton(context, isArabic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Wallet address card ───────────────────────────────────────────────────────
class _WalletCard extends StatelessWidget {
  final AppBrandingConfig branding;
  final BlockchainWalletModel wallet;
  final List<BlockchainWalletModel> allWallets;
  final ValueChanged<BlockchainWalletModel?> onWalletChanged;
  final String symbol;
  final String amountText;
  final String feeAmountText;
  final Animation<double> pulseAnim;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onCopyAmount;
  final BuildContext context;

  const _WalletCard({
    required this.branding,
    required this.wallet,
    required this.allWallets,
    required this.onWalletChanged,
    required this.symbol,
    required this.amountText,
    required this.feeAmountText,
    required this.pulseAnim,
    required this.onCopy,
    required this.onShare,
    required this.onCopyAmount,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    final embeddedCoinImage = SendCurrencyHelper.qrEmbeddedCoinImage(symbol);
    return Container(
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Card header ───────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  branding.accent.withValues(alpha: 0.1),
                  branding.accent.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    gradient: branding.buildHeaderGradient(),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslations.getText(
                          context,
                          "external_payment_address",
                        ),
                        style: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          color: branding.secondaryText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: allWallets.map((w) {
                          final bool isSelected = wallet.network == w.network;
                          final String label = w.network == "BSC"
                              ? "BSC (BEP-20)"
                              : "${w.network} (Polygon)";
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              onWalletChanged(w);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? branding.accent
                                    : branding.accent.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: isSelected
                                      ? branding.accent
                                      : branding.accent.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                label,
                                style: GoogleFonts.cairo(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : branding.accent,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Column(
              children: [
                Text(
                  AppTranslations.getText(context, "Scan QR to copy address"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: branding.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: onCopyAmount,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: branding.buildHeaderGradient(),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppTranslations.getText(
                                context,
                                "amount_to_send",
                              ),
                              style: GoogleFonts.cairo(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '$amountText $symbol',
                              style: GoogleFonts.cairo(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.copy_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: branding.accent.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: wallet.address,
                      version: QrVersions.auto,
                      size: 155.h,
                      gapless: false,
                      embeddedImage: embeddedCoinImage,
                      embeddedImageStyle: embeddedCoinImage != null
                          ? QrEmbeddedImageStyle(
                              size: Size(26.w, 26.h),
                            )
                          : null,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: branding.screenBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: branding.divider.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      wallet.address,
                      style: GoogleFonts.robotoMono(
                        fontSize: 11.sp,
                        color: branding.primaryText,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onCopy,
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            gradient: branding.buildHeaderGradient(),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.copy_rounded,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                AppTranslations.getText(context, "copy"),
                                style: GoogleFonts.cairo(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: onShare,
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: branding.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: branding.accent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share_rounded,
                                color: branding.accent,
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                AppTranslations.getText(context, "sharing"),
                                style: GoogleFonts.cairo(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: branding.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                _PaymentWarningBox(
                  branding: branding,
                  context: context,
                  feeAmountText: feeAmountText,
                  symbol: symbol,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Payment warning box ───────────────────────────────────────────────────────
class _PaymentWarningBox extends StatelessWidget {
  static const Color _warningRed = Color(0xFFD32F2F);

  final AppBrandingConfig branding;
  final BuildContext context;
  final String feeAmountText;
  final String symbol;

  const _PaymentWarningBox({
    required this.branding,
    required this.context,
    required this.feeAmountText,
    required this.symbol,
  });

  @override
  Widget build(BuildContext ctx) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final crossAlign = isArabic
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final textAlign = isArabic ? TextAlign.right : TextAlign.left;

    final warningIcon = Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        gradient: branding.buildHeaderGradient(),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.payments_rounded, color: Colors.white, size: 16.sp),
    );

    final warningText = Expanded(
      child: Column(
        crossAxisAlignment: crossAlign,
        children: [
          Text(
            AppTranslations.getText(context, 'external_payment_disclaimer'),
            textAlign: textAlign,
            style: GoogleFonts.cairo(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
              color: _warningRed,
              height: 1.35,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppTranslations.getText(context, "external_payment_amount_notice"),
            textAlign: textAlign,
            style: GoogleFonts.cairo(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
              color: _warningRed,
              height: 1.35,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppTranslations.getText(
              context,
              "external_address_one_time",
            ),
            textAlign: textAlign,
            style: GoogleFonts.cairo(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: _warningRed,
              height: 1.35,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppTranslations.getText(
              context,
              "external_payment_fee_notice",
              replacements: {'feeAmount': feeAmountText, 'symbol': symbol},
            ),
            textAlign: textAlign,
            style: GoogleFonts.cairo(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: _warningRed,
              height: 1.35,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _warningRed.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: _warningRed.withValues(alpha: 0.35)),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isArabic
            ? [warningIcon, SizedBox(width: 8.w), warningText]
            : [warningText, SizedBox(width: 8.w), warningIcon],
      ),
    );
  }
}

// ── Select network hint ───────────────────────────────────────────────────────
class _SelectNetworkHint extends StatelessWidget {
  final AppBrandingConfig branding;
  final BuildContext context;
  const _SelectNetworkHint({required this.branding, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: branding.divider.withValues(alpha: 0.4),
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.touch_app_rounded,
              color: branding.hintText,
              size: 28.sp,
            ),
            SizedBox(height: 6.h),
            Text(
              AppTranslations.getText(context, "Choose the network"),
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                color: branding.hintText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
