import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/localization/langhelper.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_airea/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_airea/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_city/cubit_stat_city.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_conversion_methods/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_conversion_methods/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_transfers/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_transfers/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubite_rate/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubite_rate/cubit_state.dart';
import 'package:usdt/featue/transfer_execution/page_view.dart';

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
      listener: (context, state) {
        if (state is TransferSuccess) {
          context.read<CountriesCubit>().reset();
          context.read<CitiesCubit>().reset();
          context.read<AreasCubit>().reset();
          context.read<PaymentMethodsCubit>().reset();
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

  Widget _buildPage(
      BuildContext context, bool isArabic, AppBrandingConfig branding) {
    final cityState = context.read<CitiesCubit>().state;
    final areaState = context.read<AreasCubit>().state;
    final paymentState = context.read<PaymentMethodsCubit>().state;
    final currencyState = context.read<CurrencyCubit>().state;

    if (cityState is! CitiesSuccess ||
        paymentState is! PaymentMethodsSuccess ||
        areaState is! AreasSuccess) {
      return const SizedBox.shrink();
    }

    final area = areaState.selected!;
    final city = cityState.selected!;
    final method = paymentState.selected!;
    final currencyName =
        currencyState.currency == CurrencyType.usdt ? "USDT" : "USDC";
    final double sendAmount =
        double.tryParse(currencyState.amount) ?? 0.0;
    final double feeAmount = sendAmount * (method.fee.toInt() / 100);
    final double netAmount = sendAmount - feeAmount;

    // ── حساب سعر الصرف مرة واحدة للصفحة كلها ─────────────────
    return BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
      buildWhen: (prev, curr) =>
          curr is ExchangeRatesSuccess || curr is ExchangeRatesInitial,
      builder: (context, rateState) {
        String exchangeRateText = "";
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

          if (rateValue > 1.0) {
            exchangeRateText =
                "1 $currencyName = ${rateValue.round()} $sym";
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
                      city: LangHelper.isArabic(context)
                          ? city.nameAr
                          : city.nameEn,
                      area: LangHelper.isArabic(context)
                          ? area.nameAr
                          : area.nameEn,
                      pickupPoint: LangHelper.isArabic(context)
                          ? method.nameAr
                          : method.nameEn,
                      receivedAmount: localAmount.round().toDouble(),
                      symbol: method.symbol,
                      exchangeRate: exchangeRateText,
                      context: context,
                    ),

                    SizedBox(height: 16.h),

                    // ── Notice ─────────────────────────────────
                    _NoticeCard(
                        branding: branding,
                        currencyName: currencyName,
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
                                  phone: widget.number,
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
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
          child: Column(
            children: [
              // ── Nav row ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(ctx);
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

              SizedBox(height: 24.h),

              // ── Send amount pill ──────────────────────────────
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_balance_wallet_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 16.sp),
                    SizedBox(width: 6.w),
                    Text(
                      AppTranslations.getText(context, 'transfer_amount'),
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // ── Big amount ────────────────────────────────────
              Text(
                '$sendAmount',
                style: GoogleFonts.cairo(
                  fontSize: 42.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              Text(
                currencyName,
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),

              SizedBox(height: 20.h),

              // ── Fee row ───────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AmountChip(
                    label: AppTranslations.getText(context, 'fees_label'),
                    value:
                        '- ${feeAmount.toStringAsFixed(2)} $currencyName',
                    valueColor: Colors.redAccent.shade100,
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 1,
                    height: 32.h,
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                  SizedBox(width: 12.w),
                  _AmountChip(
                    label: AppTranslations.getText(
                        context, 'recipient receives'),
                    // إذا كانت العملة مختلفة → اعرض المبلغ بالعملة المحلية
                    // وإلا → اعرض netAmount بنفس العملة
                    value: hasConversion
                        ? '${localAmount.round()} $localSymbol'
                        : '${netAmount.toStringAsFixed(2)} $currencyName',
                    valueColor: const Color(0xFF86EFAC),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _AmountChip({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11.sp,
            color: Colors.white.withValues(alpha: 0.65),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ── Receiver info card ────────────────────────────────────────────────────────
class _ReceiverCard extends StatelessWidget {
  final AppBrandingConfig branding;
  final String name;
  final String phone;
  final String city;
  final String area;
  final String pickupPoint;
  final double receivedAmount;
  final String symbol;
  final String exchangeRate;
  final BuildContext context;

  const _ReceiverCard({
    required this.branding,
    required this.name,
    required this.phone,
    required this.city,
    required this.area,
    required this.pickupPoint,
    required this.receivedAmount,
    required this.symbol,
    required this.exchangeRate,
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
            // ── Header row ──────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    branding.accent.withValues(alpha: 0.12),
                    branding.accent.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      gradient: branding.buildHeaderGradient(),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_rounded,
                        color: Colors.white, size: 20.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.getText(context, 'recipient'),
                          style: GoogleFonts.cairo(
                            fontSize: 11.sp,
                            color: branding.secondaryText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          name,
                          style: GoogleFonts.cairo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: branding.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // received amount badge
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      gradient: branding.buildHeaderGradient(),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '$receivedAmount $symbol',
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Detail rows ─────────────────────────────────────
            _InfoRow(
              icon: Icons.phone_rounded,
              iconColor: const Color(0xFF10B981),
              label: AppTranslations.getText(context, 'phone_number'),
              value: phone,
              ltr: true,
              branding: branding,
            ),
            _HDivider(branding: branding),
            _InfoRow(
              icon: Icons.location_city_rounded,
              iconColor: const Color(0xFF6366F1),
              label: AppTranslations.getText(context, 'city'),
              value: city,
              branding: branding,
            ),
            _HDivider(branding: branding),
            _InfoRow(
              icon: Icons.map_rounded,
              iconColor: const Color(0xFFEC4899),
              label: AppTranslations.getText(context, 'Area'),
              value: area,
              branding: branding,
            ),
            _HDivider(branding: branding),
            _InfoRow(
              icon: Icons.storefront_rounded,
              iconColor: const Color(0xFF0EA5E9),
              label: AppTranslations.getText(context, 'Pickup location'),
              value: pickupPoint,
              branding: branding,
            ),
            if (exchangeRate.isNotEmpty) ...[
              _HDivider(branding: branding),
              _InfoRow(
                icon: Icons.currency_exchange_rounded,
                iconColor: const Color(0xFFF59E0B),
                label: AppTranslations.getText(context, 'exchange_rate'),
                value: exchangeRate,
                branding: branding,
              ),
            ],
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 17.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 10.5.sp,
                    color: branding.secondaryText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // أرقام + سعر الصرف + هاتف → دائماً LTR
                Directionality(
                  textDirection: (ltr || _isNumericOrRate(value))
                      ? TextDirection.ltr
                      : (isArabic ? TextDirection.rtl : TextDirection.ltr),
                  child: Text(
                    value,
                    style: GoogleFonts.cairo(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: branding.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    return Divider(
      height: 1,
      color: branding.divider.withValues(alpha: 0.4),
      indent: 66.w,
      endIndent: 18.w,
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