import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_ressponse_transfer.dart';
import 'package:usdt/featue/bootom_navigator.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/notifation/data/model.dart';
import 'package:usdt/featue/transfer_execution/stat_paid_mor.dart';
import 'package:usdt/featue/transfer_execution/state_sacssuse.dart';
import 'package:usdt/featue/transfer_execution/state_view.dart';
import 'package:usdt/firbeas/notifaction.dart';

class ConfermScreen extends StatefulWidget {
  const ConfermScreen({super.key, required this.transfer});
  final TransferResponseModel transfer;

  @override
  State<ConfermScreen> createState() => _ConfermScreenState();
}

class _ConfermScreenState extends State<ConfermScreen>
    with SingleTickerProviderStateMixin {
  BlockchainWalletModel? selectedWallet;
  StreamSubscription<RemoteMessage>? _messagingSubscription;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    if (widget.transfer.blockchainWallets != null &&
        widget.transfer.blockchainWallets!.isNotEmpty) {
      selectedWallet = widget.transfer.blockchainWallets!.first;
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
  }

  void _startListeningForStatus() {
    _messagingSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      final data = message.data;
      if (data.isEmpty) return;

      final String notifId = data['transferId']?.toString() ?? "";
      final String currentId = widget.transfer.id.toString();
      final String status = data['status']?.toString() ?? "";

      if (notifId.trim() == currentId.trim()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (status == 'over-paid') {
            _navigateToPaidMore(data);
          } else if (status == 'full-paid') {
            _navigateToSuccess(data);
          } else if (status == 'under-paid') {
            _navigateToExtraPaid(data);
          }
        });
      }
    });
  }

  void _navigateToExtraPaid(Map<String, dynamic> data) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => paidmore(
          symbol: data['symbol'] ?? '',
          paidless:
              data['paid']?.toString() ?? data['amount']?.toString() ?? "0",
        ),
      ),
    );
  }

  void _navigateToPaidMore(Map<String, dynamic> data) {
    if (!mounted) return;
    final double extra =
        (double.tryParse(data['paid']?.toString() ?? "0") ?? 0) -
        (double.tryParse(data['amount']?.toString() ?? "0") ?? 0);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => statepademor(
          symbol: data['symbol'] ?? '',
          exstaamount: extra > 0 ? extra.toStringAsFixed(2) : "0.00",
        ),
      ),
    );
  }

  void _navigateToSuccess(Map<String, dynamic> data) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => paidsacssus(
          country: data['area'] ?? '',
          symbol: data['symbol'] ?? '',
          paid: data['paid']?.toString() ?? "0",
          city: data['city'] ?? '',
          name: data['fullName'] ?? '',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messagingSubscription?.cancel();
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

  void _shareAddress() {
    if (selectedWallet == null) return;
    SharePlus.instance.share(
      ShareParams(text: selectedWallet!.address, subject: 'Wallet Address'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        return false;
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
                    SizedBox(height: 20.h),

                    // ── Wallet address card ───────────────────────
                    if (selectedWallet != null) ...[
                      _WalletCard(
                        branding: branding,
                        wallet: selectedWallet!,
                        allWallets: widget.transfer.blockchainWallets,
                        onWalletChanged: (w) =>
                            setState(() => selectedWallet = w),
                        symbol: widget.transfer.symbol,
                        pulseAnim: _pulseAnim,
                        onCopy: _copyAddress,
                        onShare: _shareAddress,
                        context: context,
                      ),
                    ] else
                      _SelectNetworkHint(branding: branding, context: context),

                    SizedBox(height: 100.h),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isArabic,
    AppBrandingConfig branding,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: branding.buildHeaderGradient(),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
          child: Column(
            children: [
              // ── back button ──────────────────────────────────
              Align(
                alignment: isArabic
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isArabic
                          ? Icons.arrow_forward_ios_rounded
                          : Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ── Pulsing waiting icon ─────────────────────────
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, child) =>
                    Transform.scale(scale: _pulseAnim.value, child: child),
                child: Container(
                  width: 72.w,
                  height: 72.w,
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
                    size: 34.sp,
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              Text(
                AppTranslations.getText(
                  context,
                  "Please pay to complete your order!",
                ),
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 12.h),

              // ── Transfer number badge ────────────────────────
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      AppTranslations.getText(context, 'Transfer number'),
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${widget.transfer.transferNumber}',
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 14.h),

              // ── Currency chip ────────────────────────────────
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      widget.transfer.symbol == "USDC"
                          ? AppImages.usdt
                          : AppImages.usdc,
                      height: 22.h,
                      width: 22.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      widget.transfer.currencyName,
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: branding.accent,
                      ),
                    ),
                  ],
                ),
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
  final Animation<double> pulseAnim;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final BuildContext context;

  const _WalletCard({
    required this.branding,
    required this.wallet,
    required this.allWallets,
    required this.onWalletChanged,
    required this.symbol,
    required this.pulseAnim,
    required this.onCopy,
    required this.onShare,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
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
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
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
                          "To the following wallet address",
                        ),
                        style: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          color: branding.secondaryText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6.h),
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
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Column(
              children: [
                // ── 1. QR code في المنتصف ──────────────────────
                Text(
                  AppTranslations.getText(context, "Scan QR to copy address"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: branding.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: branding.accent.withValues(alpha: 0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: wallet.address,
                      version: QrVersions.auto,
                      size: 190.0.h,
                      gapless: false,
                      embeddedImage: AssetImage(
                        symbol == "USDC" ? AppImages.usdt : AppImages.usdc,
                      ),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(30.w, 30.h),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
                Divider(
                  color: branding.divider.withValues(alpha: 0.4),
                  height: 1,
                ),
                SizedBox(height: 16.h),

                // ── 2. عنوان المحفظة ──────────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
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

                SizedBox(height: 12.h),

                // ── 3. أزرار النسخ والمشاركة ──────────────────
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onCopy,
                        child: Container(
                          height: 46.h,
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
                          height: 46.h,
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
                                  fontSize: 13.sp,
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

                SizedBox(height: 16.h),

                // ── 4. مربع تنفيذ الطلب ───────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        branding.accent.withValues(alpha: 0.08),
                        branding.accent.withValues(alpha: 0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: branding.accent.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          gradient: branding.buildHeaderGradient(),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.payments_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.getText(
                                context,
                                "wallet_amount_notice",
                              ),
                              style: GoogleFonts.cairo(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: branding.accent,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              AppTranslations.getText(
                                context,
                                "This wallet is for this transfer only, and can be used once.",
                              ),
                              style: GoogleFonts.cairo(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: branding.secondaryText,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
