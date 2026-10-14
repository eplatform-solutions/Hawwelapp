// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/localization/langhelper.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/featue/auth/login/login_screen_view.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_airea/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_conversion_methods/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_country_payment_methods/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_transfers/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_transfers/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubite_rate/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubite_rate/cubit_state.dart';
import 'package:hawwel/featue/auth/welcomyou/data/resolved_payment_selection.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/cubit/cubit.dart';
import 'package:hawwel/featue/sender_information/data/repo/cubit/cubit.dart';
import 'package:hawwel/featue/idintity_veryfation/idinty_verv.dart';
import 'package:hawwel/featue/transfer_execution/page_view.dart';

class Transferdetails extends StatefulWidget {
  const Transferdetails({
    super.key,
    required this.full_name,
    required this.number,
  });

  final String full_name;
  final String number;

  @override
  State<Transferdetails> createState() => _TransferdetailsState();
}

class _TransferdetailsState extends State<Transferdetails>
    with TickerProviderStateMixin {
  late final AnimationController _headerCtrl;
  late final AnimationController _cardsCtrl;
  late final AnimationController _btnCtrl;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _cardsFade;
  late final Animation<Offset> _cardsSlide;
  late final Animation<double> _btnScale;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _cardsCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(
            CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));

    _cardsFade = CurvedAnimation(parent: _cardsCtrl, curve: Curves.easeOut);
    _cardsSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
            CurvedAnimation(parent: _cardsCtrl, curve: Curves.easeOutCubic));

    _btnScale = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _btnCtrl, curve: Curves.easeOut));

    _headerCtrl.forward();
    Future.delayed(const Duration(milliseconds: 200),
        () => _cardsCtrl.forward());
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _cardsCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocListener<TransferCubit, TransferState>(
      listener: (context, state) async {
        if (state is TransferSuccess) {
          await _autoSaveReceiverAfterTransfer();
          if (!context.mounted) return;
          context.read<CountriesCubit>().reset();
          context.read<CitiesCubit>().reset();
          context.read<AreasCubit>().reset();
          context.read<PaymentMethodsCubit>().reset();
          context.read<CountryPaymentMethodsCubit>().reset();
          context.read<CurrencyCubit>().reset();
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (_, a1, __) =>
                  ConfermScreen(transfer: state.transfer),
              transitionsBuilder: (_, a1, __, child) => FadeTransition(
                opacity: CurvedAnimation(parent: a1, curve: Curves.easeOut),
                child: child,
              ),
            ),
          );
        }
        if (state is TransferFailure) {
          if (state.statusCode == 401) {
            await Functions().deleteToken();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              content: CustomSnackBar(
                backgroundColor: branding.error,
                message: AppTranslations.getTextStatic(
                  context,
                  'session_expired_login_again',
                ),
                imagePath: AppImages.eerorrimage,
              ),
            ));
            await Future<void>.delayed(const Duration(milliseconds: 350));
            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Loginview()),
              (_) => false,
            );
            return;
          }
          if (state.statusCode == 403 &&
              (state.errorCode == 'KYC_REQUIRED' || state.error.contains('KYC'))) {
            if (!context.mounted) return;
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';
            showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                backgroundColor: branding.cardBg,
                title: Text(
                  AppTranslations.getTextStatic(context, 'kyc_required_title'),
                  style: GoogleFonts.cairo(
                    color: branding.primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Text(
                  state.error,
                  style: GoogleFonts.cairo(color: branding.secondaryText),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(
                      AppTranslations.getTextStatic(context, 'Ok'),
                      style: GoogleFonts.cairo(color: branding.secondaryText),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => idintyview()),
                      );
                    },
                    child: Text(
                      isArabic ? 'إكمال KYC' : 'Complete KYC',
                      style: GoogleFonts.cairo(
                        color: branding.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
            return;
          }
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            content: CustomSnackBar(
              backgroundColor: branding.iconPrimary,
              message: state.error,
              imagePath: AppImages.eerorrimage,
            ),
          ));
        }
      },
      child: BlocBuilder<TransferCubit, TransferState>(
        builder: (context, transferState) {
          return Directionality(
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: branding.screenBg,
              body: Stack(
                children: [
                  _buildPage(context, isArabic, branding),
                  if (transferState is TransferLoading)
                    _LoadingOverlay(branding: branding),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _autoSaveReceiverAfterTransfer() async {
    try {
      final receiversCubit = context.read<ReceiversCubit>();
      receiversCubit.fullNameController.text = widget.full_name.trim();
      receiversCubit.mobilePhoneController.text = widget.number.trim();
      await receiversCubit.addReceiver();
      if (!mounted) return;
      await context.read<ReceiversDisplayCubit>().getAllReceiversDisplay();
    } catch (_) {
      // Never block transfer success navigation because of auto-save failures.
    }
  }

  Widget _buildPage(
      BuildContext context, bool isArabic, AppBrandingConfig branding) {
    final cityState = context.read<CitiesCubit>().state;
    final areaState = context.read<AreasCubit>().state;
    final paymentState = context.read<PaymentMethodsCubit>().state;
    final countryPaymentState = context.read<CountryPaymentMethodsCubit>().state;
    final currencyState = context.watch<CurrencyCubit>().state;

    final resolvedSelection = resolvePaymentSelection(
      cityState: cityState,
      areaState: areaState,
      paymentState: paymentState,
      countryPaymentState: countryPaymentState,
    );

    if (resolvedSelection == null) {
      return const SizedBox.shrink();
    }

    final area = resolvedSelection.area;
    final city = resolvedSelection.city;
    final method = resolvedSelection.method;
    final currencyName =
        SendCurrencyHelper.apiSymbolFor(currencyState.currency);
    final displayCurrencyName = SendCurrencyHelper.displayLabelForType(
      currencyState.currency,
      isArabic: isArabic,
    );
    final double sendAmount =
        double.tryParse(currencyState.amount) ?? 0.0;
    final double feeAmount = sendAmount * (method.fee.toInt() / 100);
    final double netAmount = sendAmount - feeAmount;

    // ── حساب سعر الصرف مرة واحدة للصفحة كلها ─────────────────
    return BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
      buildWhen: (prev, curr) =>
          curr is ExchangeRatesSuccess || curr is ExchangeRatesInitial,
      builder: (context, rateState) {
        double rateValue = 1.0;

        // نفس منطق _resolveRate في الصفحة الرئيسية بالضبط
        final sym = method.symbol.trim().toUpperCase();
        if (sym != "USDT" && sym != "USDC" &&
            rateState is ExchangeRatesSuccess) {
          // الحالة 1: rates[sym] هو Map يحتوي على {"USDT": ..., "USDC": ...}
          final entry = rateState.data.rates[sym];
          if (entry is Map) {
            final parsed =
                double.tryParse(entry[currencyName]?.toString() ?? "");
            if (parsed != null && parsed > 0) {
              rateValue = parsed;
            }
          }
          // الحالة 2: SYP — rates["USDT"] هو مباشرة قيمة SYP/USDT
          if (rateValue == 1.0 && sym == "SYP") {
            final parsed = double.tryParse(
                rateState.data.rates[currencyName]?.toString() ?? "");
            if (parsed != null && parsed > 0) rateValue = parsed;
          }

        }

        final double localAmount = netAmount * rateValue;
        final bool hasConversion = sym != "USDT" && sym != "USDC";

    return Column(
      children: [
        // ── Gradient header ────────────────────────────────────
        FadeTransition(
          opacity: _headerFade,
          child: SlideTransition(
            position: _headerSlide,
            child: _Header(
              isArabic: isArabic,
              branding: branding,
              sendAmount: sendAmount,
              netAmount: netAmount,
              feeAmount: feeAmount,
              currencyName: currencyName,
              localAmount: localAmount,
              localSymbol: method.symbol,
              hasConversion: hasConversion,
              context: context,
              onEditAmount: () =>
                  _showEditAmountDialog(branding, currencyState.amount),
            ),
          ),
        ),

        // ── Scrollable content ─────────────────────────────────
        Expanded(
          child: FadeTransition(
            opacity: _cardsFade,
            child: SlideTransition(
              position: _cardsSlide,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // ── Receiver info ──────────────────────────
                    _ReceiverCard(
                      branding: branding,
                      name: widget.full_name,
                      phone: widget.number,
                      city: city == null
                          ? null
                          : (LangHelper.isArabic(context)
                              ? city.nameAr
                              : city.nameEn),
                      area: area == null
                          ? null
                          : (LangHelper.isArabic(context)
                              ? area.nameAr
                              : area.nameEn),
                      pickupPoint: LangHelper.isArabic(context)
                          ? method.nameAr
                          : method.nameEn,
                      receivedAmount: localAmount.round().toDouble(),
                      symbol: method.symbol,
                      context: context,
                    ),

                    SizedBox(height: 16.h),

                    // ── Notice ─────────────────────────────────
                    _NoticeCard(
                        branding: branding,
                        currencyName: displayCurrencyName,
                        context: context),

                    SizedBox(height: 24.h),

                    // ── Submit button ──────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ScaleTransition(
                        scale: _btnScale,
                        child: GestureDetector(
                          onTapDown: (_) => _btnCtrl.forward(),
                          onTapUp: (_) {
                            _btnCtrl.reverse();
                            HapticFeedback.mediumImpact();
                            context.read<TransferCubit>().submitTransfer(
                                  context: context,
                                  fullName: widget.full_name,
                                  receiverPhone: widget.number,
                                );
                          },
                          onTapCancel: () => _btnCtrl.reverse(),
                          child: Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              gradient: branding.buildHeaderGradient(),
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [
                                BoxShadow(
                                  color: branding.accent
                                      .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send_rounded,
                                    color: Colors.white, size: 20.sp),
                                SizedBox(width: 10.w),
                                Text(
                                  AppTranslations.getText(
                                      context, "transfer confirmation"),
                                  style: GoogleFonts.cairo(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
      }, // end BlocBuilder builder
    ); // end BlocBuilder
  }

  Future<void> _showEditAmountDialog(
      AppBrandingConfig branding, String currentAmount) async {
    final controller = TextEditingController(text: currentAmount);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final updated = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            AppTranslations.getText(context, 'transfer_amount'),
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: AppTranslations.getText(context, 'enter_amount_to_send'),
              border: const OutlineInputBorder(),
            ),
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppTranslations.getText(context, 'cancel')),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: branding.accent,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, controller.text.trim());
              },
              child: Text(AppTranslations.getText(context, 'save')),
            ),
          ],
        );
      },
    );

    if (updated == null) return;
    if (!mounted) return;
    final parsed = double.tryParse(updated);
    if (parsed == null || parsed <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? 'يرجى إدخال كمية صحيحة' : 'Please enter a valid amount',
          ),
        ),
      );
      return;
    }

    context.read<CurrencyCubit>().changeAmount(parsed.toString());
  }
}

// ── Header with amount summary ────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final bool isArabic;
  final AppBrandingConfig branding;
  final double sendAmount;
  final double netAmount;
  final double feeAmount;
  final String currencyName;
  final double localAmount;
  final String localSymbol;
  final bool hasConversion;
  final BuildContext context;
  final VoidCallback onEditAmount;

  const _Header({
    required this.isArabic,
    required this.branding,
    required this.sendAmount,
    required this.netAmount,
    required this.feeAmount,
    required this.currencyName,
    required this.localAmount,
    required this.localSymbol,
    required this.hasConversion,
    required this.context,
    required this.onEditAmount,
  });

  @override
  Widget build(BuildContext ctx) {
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
          padding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 16.h),
          child: Column(
            children: [
              // ── Nav row ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBackButton(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(ctx);
                    },
                  ),
                  Text(
                    AppTranslations.getText(context, 'transfer_details'),
                    style: GoogleFonts.cairo(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 38.w), // balance
                ],
              ),

              SizedBox(height: 10.h),

              // ── Amount row: label (كمية الطلب) + value side by side (RTL/LTR via parent) ──
              GestureDetector(
                onTap: onEditAmount,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(40.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 15.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          AppTranslations.getText(context, 'transfer_amount'),
                          style: GoogleFonts.cairo(
                            fontSize: 11.5.sp,
                            color: Colors.white.withValues(alpha: 0.88),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$sendAmount',
                        style: GoogleFonts.cairo(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.05,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        currencyName,
                        style: GoogleFonts.cairo(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Receiver info card ────────────────────────────────────────────────────────
class _ReceiverCard extends StatelessWidget {
  final AppBrandingConfig branding;
  final String name;
  final String phone;
  // Null for a country-level transfer (no city/region was chosen) - those
  // rows are simply omitted below instead of showing an empty value.
  final String? city;
  final String? area;
  final String pickupPoint;
  final double receivedAmount;
  final String symbol;
  final BuildContext context;

  const _ReceiverCard({
    required this.branding,
    required this.name,
    required this.phone,
    this.city,
    this.area,
    required this.pickupPoint,
    required this.receivedAmount,
    required this.symbol,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: branding.cardBg,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Detail rows ─────────────────────────────────────
            _InfoRow(
              icon: Icons.person_rounded,
              iconColor: const Color(0xFF0F9D8A),
              label: AppTranslations.getText(context, 'recipient'),
              value: name,
              branding: branding,
            ),
            _HDivider(branding: branding),
            _InfoRow(
              icon: Icons.account_balance_wallet_rounded,
              iconColor: const Color(0xFF0EA5E9),
              label: AppTranslations.getText(context, 'received_amount_label'),
              value: '${receivedAmount.toStringAsFixed(1)} $symbol',
              ltr: true,
              branding: branding,
            ),
            _HDivider(branding: branding),
            _InfoRow(
              icon: Icons.phone_rounded,
              iconColor: const Color(0xFF10B981),
              label: AppTranslations.getText(context, 'phone_number'),
              value: phone,
              ltr: true,
              branding: branding,
            ),
            if (city != null) ...[
              _HDivider(branding: branding),
              _InfoRow(
                icon: Icons.location_city_rounded,
                iconColor: const Color(0xFF6366F1),
                label: AppTranslations.getText(context, 'city'),
                value: city!,
                branding: branding,
              ),
            ],
            if (area != null) ...[
              _HDivider(branding: branding),
              _InfoRow(
                icon: Icons.map_rounded,
                iconColor: const Color(0xFFEC4899),
                label: AppTranslations.getText(context, 'Area'),
                value: area!,
                branding: branding,
              ),
            ],
            _HDivider(branding: branding),
            _InfoRow(
              icon: Icons.storefront_rounded,
              iconColor: const Color(0xFF0EA5E9),
              label: AppTranslations.getText(context, 'Pickup location'),
              value: pickupPoint,
              branding: branding,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool ltr;
  final AppBrandingConfig branding;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.branding,
    this.ltr = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    final iconBox = Container(
      width: 33.w,
      height: 33.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 15.sp),
    );

    final valueDirection = (ltr || _isNumericOrRate(value))
        ? TextDirection.ltr
        : (isArabic ? TextDirection.rtl : TextDirection.ltr);

    final valueWidget = Directionality(
      textDirection: valueDirection,
      child: Align(
        alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.cairo(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w700,
            color: branding.primaryText,
          ),
        ),
      ),
    );

    final labelStyle = GoogleFonts.cairo(
      fontSize: 10.5.sp,
      color: branding.secondaryText,
      fontWeight: FontWeight.w400,
    );

    final textBlock = Expanded(
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: labelStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 8.w),
          Expanded(child: valueWidget),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
      child: Row(
        children: isArabic
            ? [textBlock, SizedBox(width: 12.w), iconBox]
            : [iconBox, SizedBox(width: 12.w), textBlock],
      ),
    );
  }

  // سعر الصرف والأرقام تحتاج LTR دائماً
  bool _isNumericOrRate(String v) {
    return v.contains('=') || v.startsWith(RegExp(r'[0-9+\-]'));
  }
}

class _HDivider extends StatelessWidget {
  final AppBrandingConfig branding;
  const _HDivider({required this.branding});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Divider(
      height: 1,
      color: branding.divider.withValues(alpha: 0.4),
      indent: isArabic ? 18.w : 66.w,
      endIndent: isArabic ? 66.w : 18.w,
    );
  }
}

// ── Notice card ───────────────────────────────────────────────────────────────
class _NoticeCard extends StatelessWidget {
  final AppBrandingConfig branding;
  final String currencyName;
  final BuildContext context;

  const _NoticeCard({
    required this.branding,
    required this.currencyName,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: branding.accent.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: branding.accent.withValues(alpha: 0.18), width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded,
                color: branding.accent, size: 18.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: branding.secondaryText,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(
                        text: AppTranslations.getText(
                            context, 'confirmation_message')),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: AppTranslations.getText(
                          context,
                          "The transfer will be paid using the chosen digital currency."),
                    ),
                    TextSpan(
                      text: ' $currencyName',
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: branding.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading overlay ───────────────────────────────────────────────────────────
class _LoadingOverlay extends StatelessWidget {
  final AppBrandingConfig branding;
  const _LoadingOverlay({required this.branding});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.45),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(28.r),
          decoration: BoxDecoration(
            color: branding.cardBg,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: branding.accent),
              SizedBox(height: 16.h),
              Text(
                AppTranslations.getText(context, 'transfer_amount'),
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  color: branding.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}