import 'dart:async';

import 'package:country_picker/country_picker.dart';
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
import 'package:usdt/featue/auth/welcomyou/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_airea/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_airea/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_city/cubit_stat_city.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_conversion_methods/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_conversion_methods/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubite_rate/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubite_rate/cubit_state.dart';
import 'package:usdt/featue/auth/welcomyou/widjt/amount_send.dart';
import 'package:usdt/featue/auth/welcomyou/widjt/edit_rsive.dart';
import 'package:usdt/featue/auth/welcomyou/widjt/notifaction_icon.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit.dart';
import 'package:usdt/featue/sender_information/sender_information_screen_view.dart';

class Welcomyou extends StatefulWidget {
  const Welcomyou({super.key});

  @override
  State<Welcomyou> createState() => _WelcomyouState();
}

class _WelcomyouState extends State<Welcomyou> with TickerProviderStateMixin {
  // ─── Overlays ────────────────────────────────────────────────────────────
  OverlayEntry? _countriesOverlay;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _citiesOverlay;
  final LayerLink _cityLayerLink = LayerLink();
  OverlayEntry? _areasOverlay;
  final LayerLink _areaLayerLink = LayerLink();

  // ─── Controllers ─────────────────────────────────────────────────────────
  Timer? _rateTimer;
  late TextEditingController amountController;
  late TextEditingController receiverController;
  bool _isUpdating = false;

  // ─── Animation ───────────────────────────────────────────────────────────
  late AnimationController _entranceCtrl;
  late AnimationController _sendBtnCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _sendBtnScale;

  @override
  void initState() {
    super.initState();

    // entrance
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic),
        );

    // send button press
    _sendBtnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
      value: 1.0,
    );
    _sendBtnScale = _sendBtnCtrl;

    // data
    context.read<NotificationsCubit>().fetchNotifications();
    context.read<ExchangeRatesCubit>().fetchRates();

    // الكمية الافتراضية = 1
    const String defaultAmount = '1';
    context.read<CurrencyCubit>().changeAmount(defaultAmount);
    amountController = TextEditingController(text: defaultAmount);
    receiverController = TextEditingController();

    // جلب البلدان (يختار سوريا تلقائياً إن وُجدت)
    // ثم جلب مدن البلد المختار وتحديد الأولى افتراضياً
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final countriesCubit = context.read<CountriesCubit>();
      await countriesCubit.fetchCountries();
      if (!mounted) return;
      final countryState = countriesCubit.state;
      if (countryState is! CountriesSuccess) return;

      final citiesCubit = context.read<CitiesCubit>();
      await citiesCubit.fetchCities(countryState.selected.id);
      if (!mounted) return;
      final cityState = citiesCubit.state;
      if (cityState is CitiesSuccess && cityState.cities.isNotEmpty) {
        citiesCubit.selectCity(cityState.cities.first);
      }
    });

    _rateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) context.read<ExchangeRatesCubit>().fetchRates();
    });

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _rateTimer?.cancel();
    amountController.dispose();
    receiverController.dispose();
    _entranceCtrl.dispose();
    _sendBtnCtrl.dispose();
    super.dispose();
  }

  // ─── Overlay helpers ─────────────────────────────────────────────────────
  void _closeAllOverlays() {
    _countriesOverlay?.remove();
    _countriesOverlay = null;
    _citiesOverlay?.remove();
    _citiesOverlay = null;
    _areasOverlay?.remove();
    _areasOverlay = null;
  }

  void _openAreasDropdown(BuildContext context, AreasSuccess state) {
    _closeAllOverlays();
    final branding = appBrandingNotifier.value;
    _areasOverlay = OverlayEntry(
      builder: (_) => Positioned(
        width: 180.w,
        child: CompositedTransformFollower(
          link: _areaLayerLink,
          offset: Offset(0, 54.h),
          showWhenUnlinked: false,
          child: _DropdownCard(
            branding: branding,
            children: state.areas.map((area) {
              return _DropdownTile(
                label: LangHelper.isArabic(context) ? area.nameAr : area.nameEn,
                onTap: () {
                  context.read<AreasCubit>().selectArea(area);
                  context.read<PaymentMethodsCubit>().fetchMethods(area.id);
                  _closeAllOverlays();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_areasOverlay!);
  }

  void _openCitiesDropdown(BuildContext context, CitiesSuccess state) {
    _closeAllOverlays();
    final branding = appBrandingNotifier.value;
    _citiesOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 180.w,
        child: CompositedTransformFollower(
          link: _cityLayerLink,
          offset: Offset(0, 54.h),
          showWhenUnlinked: false,
          child: _DropdownCard(
            branding: branding,
            children: state.cities.map((city) {
              return _DropdownTile(
                label: LangHelper.isArabic(context) ? city.nameAr : city.nameEn,
                onTap: () {
                  context.read<CitiesCubit>().selectCity(city);
                  context.read<AreasCubit>().reset();
                  _closeAllOverlays();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_citiesOverlay!);
  }

  void _showCountriesDropdown(BuildContext context, CountriesSuccess state) {
    _closeAllOverlays();
    final branding = appBrandingNotifier.value;
    _countriesOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 200.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, 54.h),
          showWhenUnlinked: false,
          child: _DropdownCard(
            branding: branding,
            maxHeight: 260.h,
            children: state.countries.map((c) {
              final cd = Country.tryParse(c.code);
              final name =
                  CountryLocalizations.of(
                    context,
                  )?.countryName(countryCode: c.code) ??
                  cd?.name ??
                  c.code;
              return _DropdownTile(
                label: name,
                leading: c.code == 'SY'
                    ? Image.asset(
                        'asset/syrianewsyria.png',
                        width: 24,
                        height: 24,
                      )
                    : Text(
                        cd?.flagEmoji ?? '🏳️',
                        style: const TextStyle(fontSize: 20),
                      ),
                onTap: () {
                  context.read<CountriesCubit>().selectCountry(c);
                  context.read<CitiesCubit>().reset();
                  _closeAllOverlays();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_countriesOverlay!);
  }

  // ─── Business logic ───────────────────────────────────────────────────────
  double _resolveRate(
    ExchangeRatesState rateState,
    CurrencyType currency,
    String symbol,
  ) {
    final sendKey = currency == CurrencyType.usdt ? "USDT" : "USDC";
    final sym = symbol.trim().toUpperCase();
    if (sym == "USDT" || sym == "USDC") return 1.0;
    if (rateState is! ExchangeRatesSuccess) return 1.0;
    final entry = rateState.data.rates[sym];
    if (entry is Map) {
      final parsed = double.tryParse(entry[sendKey]?.toString() ?? "");
      if (parsed != null && parsed > 0) return parsed;
    }
    if (sym == "SYP") {
      final parsed = double.tryParse(
        rateState.data.rates[sendKey]?.toString() ?? "",
      );
      if (parsed != null && parsed > 0) return parsed;
    }
    return 1.0;
  }

  void onSendChanged(String value, double fee) {
    if (_isUpdating) return;
    _isUpdating = true;
    final amount = double.tryParse(value.replaceAll(',', '')) ?? 0;
    if (amount > 0) {
      receiverController.text = (amount - (amount * (fee / 100)))
          .toStringAsFixed(2);
      context.read<CurrencyCubit>().changeAmount(amount.toString());
    } else {
      receiverController.clear();
    }
    _isUpdating = false;
  }

  void onReceiverChanged(String value, double fee, double rate, String symbol) {
    if (_isUpdating) return;
    _isUpdating = true;
    final receiverAmount = double.tryParse(value.replaceAll(',', '')) ?? 0;
    if (receiverAmount > 0) {
      final sym = symbol.trim().toUpperCase();
      final isCrypto = sym == "USDT" || sym == "USDC";
      double total;
      if (!isCrypto) {
        total = (receiverAmount / (rate > 0 ? rate : 1.0)) / (1 - (fee / 100));
      } else {
        total = receiverAmount / (1 - (fee / 100));
      }
      final str = total.toStringAsFixed(2);
      amountController.text = str;
      context.read<CurrencyCubit>().changeAmount(str);
    } else {
      amountController.clear();
      context.read<CurrencyCubit>().changeAmount("0");
    }
    _isUpdating = false;
  }

  bool _isFormValid(BuildContext context) {
    if (context.read<CountriesCubit>().state is! CountriesSuccess) return false;
    final city = context.read<CitiesCubit>().state;
    if (city is! CitiesSuccess || city.selected == null) return false;
    final area = context.read<AreasCubit>().state;
    if (area is! AreasSuccess || area.selected == null) return false;
    final pay = context.read<PaymentMethodsCubit>().state;
    if (pay is! PaymentMethodsSuccess || pay.selected == null) return false;
    if (context.read<CurrencyCubit>().state.amount.isEmpty) return false;
    return true;
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content: CustomSnackBar(
          backgroundColor: appBrandingNotifier.value.iconPrimary,
          message: msg,
          imagePath: AppImages.eerorrimage,
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: GestureDetector(
          onTap: () {
            _closeAllOverlays();
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── App bar ───────────────────────────────────────
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 86.h,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: branding.buildHeaderGradient(),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
                          child: Row(
                            children: [
                              Image.asset(
                                'asset/4cb89412e17e9731c5a074ee767cc8afb7213109.png',
                                height: 30.h,
                                width: 30.w,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hawwel',
                                      style: GoogleFonts.cairo(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w800,
                                        color: branding.buttonText,
                                      ),
                                    ),
                                    Text(
                                      AppTranslations.getText(
                                        context,
                                        'send_transfer_cta',
                                      ),
                                      style: GoogleFonts.cairo(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        color: branding.buttonText.withOpacity(
                                          0.82,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              notfactionicon(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Hero: Amount card ─────────────────────
                        _buildAmountCard(branding, isArabic, context),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 24.h),

                              // ── Destination section ───────────
                              _SectionLabel(
                                label: AppTranslations.getText(
                                  context,
                                  'send_to',
                                ),
                                branding: branding,
                              ),
                              SizedBox(height: 12.h),
                              _buildDestinationSection(
                                branding,
                                isArabic,
                                context,
                              ),

                              SizedBox(height: 28.h),

                              // ── Payment methods ───────────────
                              _SectionLabel(
                                label: AppTranslations.getText(
                                  context,
                                  'Conversion methods',
                                ),
                                branding: branding,
                              ),
                              SizedBox(height: 12.h),
                              _buildPaymentMethods(branding, isArabic, context),

                              SizedBox(height: 28.h),

                              // ── Transfer summary ──────────────
                              _buildTransferSummary(branding, context),

                              SizedBox(height: 20.h),

                              // ── Fees ──────────────────────────
                              _buildFees(branding, context),

                              SizedBox(height: 28.h),

                              // ── Send button ───────────────────
                              _buildSendButton(branding, context),

                              // space for floating nav bar (≈86h) + extra
                              SizedBox(height: 100.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Amount card ──────────────────────────────────────────────────────────
  Widget _buildAmountCard(
    AppBrandingConfig branding,
    bool isArabic,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: branding.buildHeaderGradient(),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: branding.accent.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTranslations.getText(context, "send_amount_label"),
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              color: branding.accent.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          BlocBuilder<CurrencyCubit, CurrencyState>(
            builder: (context, state) {
              final isUsdt = state.currency == CurrencyType.usdt;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.14),
                      Colors.white.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: branding.accent.withOpacity(0.3)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    // Currency toggle
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        context.read<CurrencyCubit>().toggleCurrency();
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Row(
                          key: ValueKey(state.currency),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              isUsdt ? AppImages.usdt : AppImages.usdc,
                              height: 28.h,
                              width: 28.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              isUsdt ? 'USDT' : 'USDC',
                              style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: branding.accent,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.swap_vert_rounded,
                              size: 16.sp,
                              color: branding.accent.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 28.h,
                      margin: EdgeInsets.symmetric(horizontal: 12.w),
                      color: branding.accent.withOpacity(0.3),
                    ),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          context.read<CurrencyCubit>().changeAmount(value);
                          final ps = context.read<PaymentMethodsCubit>().state;
                          double fee = 0;
                          if (ps is PaymentMethodsSuccess &&
                              ps.selected != null) {
                            fee = ps.selected!.fee.toDouble();
                          }
                          onSendChanged(value, fee);
                        },
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: GoogleFonts.cairo(
                            color: branding.accent.withOpacity(0.4),
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w300,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: GoogleFonts.cairo(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Destination section ──────────────────────────────────────────────────
  Widget _buildDestinationSection(
    AppBrandingConfig branding,
    bool isArabic,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: branding.accent.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Country
          CompositedTransformTarget(
            link: _layerLink,
            child: BlocConsumer<CountriesCubit, CountriesState>(
              listener: (ctx, state) {
                if (state is CountriesFailure) {
                  showDialog(
                    context: ctx,
                    builder: (_) => AlertDialog(
                      backgroundColor: const Color(0xFF6B1F2A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AppImages.eerorrimage, height: 50),
                          const SizedBox(height: 15),
                          Text(
                            state.error,
                            style: TextStyle(color: branding.buttonText),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            AppTranslations.getText(ctx, "Ok"),
                            style: TextStyle(color: branding.buttonText),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              builder: (ctx, state) {
                Widget flag = const SizedBox(width: 24);
                String title = AppTranslations.getText(ctx, 'Choose country');

                if (state is CountriesSuccess && state.isCountrySelected) {
                  final sel = state.selected;
                  final cd = Country.tryParse(sel.code);
                  try {
                    title =
                        CountryLocalizations.of(
                          ctx,
                        )?.countryName(countryCode: sel.code) ??
                        cd?.name ??
                        sel.code;
                  } catch (_) {
                    title = cd?.name ?? sel.code;
                  }
                  flag = sel.code == 'SY'
                      ? Image.asset(
                          'asset/syrianewsyria.png',
                          width: 24,
                          height: 24,
                        )
                      : Text(
                          cd?.flagEmoji ?? '🏳️',
                          style: TextStyle(fontSize: 20.sp),
                        );
                }

                return _DestinationRow(
                  icon: Icons.language_rounded,
                  label: AppTranslations.getText(ctx, 'Choose country'),
                  value: title,
                  trailing: flag,
                  branding: branding,
                  isLoading: state is CountriesLoading,
                  isFirst: true,
                  onTap: () async {
                    final cubit = ctx.read<CountriesCubit>();
                    if (state is CountriesInitial ||
                        state is CountriesFailure) {
                      await cubit.fetchCountries();
                    }
                    if (cubit.state is CountriesSuccess && ctx.mounted) {
                      _showCountriesDropdown(
                        ctx,
                        cubit.state as CountriesSuccess,
                      );
                    }
                    ctx.read<CitiesCubit>().reset();
                  },
                );
              },
            ),
          ),

          _Divider(branding: branding),

          // City
          CompositedTransformTarget(
            link: _cityLayerLink,
            child: BlocBuilder<CitiesCubit, CitiesState>(
              builder: (ctx, state) {
                String value = AppTranslations.getText(ctx, 'Choose a city');
                if (state is CitiesSuccess && state.selected != null) {
                  value = LangHelper.isArabic(ctx)
                      ? state.selected!.nameAr
                      : state.selected!.nameEn;
                }
                return _DestinationRow(
                  icon: Icons.location_city_rounded,
                  label: AppTranslations.getText(ctx, 'Choose a city'),
                  value: value,
                  trailing: const SizedBox(),
                  branding: branding,
                  isLoading: state is CitiesLoading,
                  onTap: () async {
                    if (state is CitiesLoading) return;
                    final countryState = ctx.read<CountriesCubit>().state;
                    if (countryState is! CountriesSuccess) return;
                    await ctx.read<CitiesCubit>().fetchCities(
                      countryState.selected.id,
                    );
                    final cs = ctx.read<CitiesCubit>().state;
                    if (cs is CitiesSuccess &&
                        cs.cities.isNotEmpty &&
                        ctx.mounted) {
                      _openCitiesDropdown(ctx, cs);
                    }
                  },
                );
              },
            ),
          ),

          _Divider(branding: branding),

          // Area
          CompositedTransformTarget(
            link: _areaLayerLink,
            child: BlocBuilder<AreasCubit, AreasState>(
              builder: (ctx, state) {
                String value = AppTranslations.getText(ctx, 'Choose a region');
                if (state is AreasSuccess && state.selected != null) {
                  value = LangHelper.isArabic(ctx)
                      ? state.selected!.nameAr
                      : state.selected!.nameEn;
                }
                return _DestinationRow(
                  icon: Icons.place_rounded,
                  label: AppTranslations.getText(ctx, 'Choose a region'),
                  value: value,
                  trailing: const SizedBox(),
                  branding: branding,
                  isLoading: state is AreasLoading,
                  isLast: true,
                  onTap: () async {
                    final cityState = ctx.read<CitiesCubit>().state;
                    if (cityState is! CitiesSuccess ||
                        cityState.selected == null)
                      return;
                    await ctx.read<AreasCubit>().fetchAreas(
                      cityState.selected!.id,
                    );
                    final as_ = ctx.read<AreasCubit>().state;
                    if (as_ is AreasSuccess &&
                        as_.areas.isNotEmpty &&
                        ctx.mounted) {
                      _openAreasDropdown(ctx, as_);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Payment methods ──────────────────────────────────────────────────────
  Widget _buildPaymentMethods(
    AppBrandingConfig branding,
    bool isArabic,
    BuildContext context,
  ) {
    return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
      builder: (ctx, state) {
        if (state is PaymentMethodsLoading) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: CircularProgressIndicator(color: branding.accent),
            ),
          );
        }
        if (state is PaymentMethodsFailure) {
          return Center(
            child: Text(
              state.error,
              style: GoogleFonts.cairo(color: branding.secondaryText),
            ),
          );
        }
        if (state is PaymentMethodsSuccess) {
          if (state.methods.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: branding.accent, size: 32.sp),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      color: branding.secondaryText,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: state.methods.length,
            itemBuilder: (ctx, i) {
              final m = state.methods[i];
              final selected = state.selected?.id == m.id;
              return _ModernPaymentMethodCard(
                branding: branding,
                selected: selected,
                name: LangHelper.isArabic(ctx) ? m.nameAr : m.nameEn,
                logoPath: m.logoPath,
                symbol: m.symbol,
                fee: m.fee.toDouble(),
                isActive: m.isActivated,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ctx.read<PaymentMethodsCubit>().selectMethod(m);
                  final fee = m.fee.toDouble();
                  final symbol = m.symbol;
                  double rate = 1.0;
                  final rs = ctx.read<ExchangeRatesCubit>().state;
                  if (rs is ExchangeRatesSuccess) {
                    rate = _resolveRate(
                      rs,
                      ctx.read<CurrencyCubit>().state.currency,
                      symbol,
                    );
                  }
                  if (amountController.text.isNotEmpty) {
                    onSendChanged(amountController.text, fee);
                  } else if (receiverController.text.isNotEmpty) {
                    onReceiverChanged(
                      receiverController.text,
                      fee,
                      rate,
                      symbol,
                    );
                  }
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  // ─── Transfer summary ─────────────────────────────────────────────────────
  Widget _buildTransferSummary(
    AppBrandingConfig branding,
    BuildContext context,
  ) {
    return BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
      buildWhen: (_, cur) => cur is ExchangeRatesSuccess,
      builder: (ctx, rateState) {
        return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
          builder: (ctx, payState) {
            double fee = 0;
            String symbol = "SYP";
            double rate = 1.0;

            if (payState is PaymentMethodsSuccess &&
                payState.selected != null) {
              fee = payState.selected!.fee.toDouble();
              symbol = payState.selected!.symbol.trim().toUpperCase();
            }

            final currCubit = ctx.watch<CurrencyCubit>();
            rate = _resolveRate(rateState, currCubit.state.currency, symbol);

            final sendAmount = double.tryParse(currCubit.state.amount) ?? 0;
            final afterFee = sendAmount * (1 - (fee / 100));
            String resultText = "";
            if (sendAmount > 0) {
              resultText = (symbol != "USDT" && symbol != "USDC")
                  ? (afterFee * rate).round().toString()
                  : afterFee.toStringAsFixed(2);
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              final hasFocus =
                  FocusScope.of(ctx).focusedChild != null &&
                  receiverController.selection.isValid;
              if (!hasFocus && receiverController.text != resultText) {
                receiverController.value = TextEditingValue(
                  text: resultText,
                  selection: TextSelection.collapsed(offset: resultText.length),
                );
              }
            });

            return Container(
              decoration: BoxDecoration(
                color: branding.cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: branding.accent.withOpacity(0.18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: Trsletastkbl3(
                      text1: AppTranslations.getText(ctx, 'receiver_gets'),
                      text2: symbol,
                      text3: "",
                      isEditable: true,
                      controller: receiverController,
                      onChanged: (v) => onReceiverChanged(v, fee, rate, symbol),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: branding.buildHeaderGradient(),
                          ),
                          child: Image.asset(
                            AppImages.trsltstkbl1,
                            height: 16.h,
                            width: 16.w,
                            color: branding.buttonText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<CurrencyCubit, CurrencyState>(
                      builder: (ctx, state) {
                        final raw = double.tryParse(state.amount) ?? 0;
                        final isUsdt = state.currency == CurrencyType.usdt;
                        return Trsletastkbl2(
                          text1: AppTranslations.getText(ctx, 'you_send'),
                          text2: isUsdt ? 'USDT' : 'USDC',
                          text3: (state.amount.isEmpty || raw == 0)
                              ? '0.00'
                              : raw.toStringAsFixed(2),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── Fees ─────────────────────────────────────────────────────────────────
  Widget _buildFees(AppBrandingConfig branding, BuildContext context) {
    return BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
      builder: (ctx, rateState) {
        return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
          builder: (ctx, payState) {
            int fee = 0;
            String symbol = '';
            double rate = 0;
            bool hasMethod = false;

            if (payState is PaymentMethodsSuccess &&
                payState.selected != null) {
              hasMethod = true;
              fee = payState.selected!.fee.toInt();
              symbol = payState.selected!.symbol.trim().toUpperCase();
              final currency = ctx.read<CurrencyCubit>().state.currency;
              rate = _resolveRate(rateState, currency, symbol);
            }

            final isCrypto = symbol == 'USDT' || symbol == 'USDC';
            final showRate = hasMethod && !isCrypto && rate > 0;

            // Format rate nicely: large numbers → no decimals
            String rateText = '';
            if (showRate) {
              rateText = rate >= 100
                  ? rate.round().toString()
                  : rate.toStringAsFixed(2);
            }

            final sendSymbol =
                ctx.read<CurrencyCubit>().state.currency == CurrencyType.usdt
                ? 'USDT'
                : 'USDC';

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: double.infinity,
              decoration: BoxDecoration(
                color: branding.cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: branding.accent.withValues(alpha: 0.18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              child: Row(
                children: [
                  // ── Exchange rate ──────────────────────────────
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: showRate
                          ? Column(
                              key: ValueKey('rate_$symbol'),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppTranslations.getText(ctx, 'exchange_rate'),
                                  style: GoogleFonts.cairo(
                                    fontSize: 11.sp,
                                    color: branding.secondaryText,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '1 $sendSymbol',
                                      style: GoogleFonts.cairo(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: branding.primaryText,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 1.h,
                                      ),
                                      child: Icon(
                                        Icons.compare_arrows_rounded,
                                        size: 16.sp,
                                        color: branding.accent,
                                      ),
                                    ),
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      transitionBuilder: (child, anim) =>
                                          FadeTransition(
                                            opacity: anim,
                                            child: SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(0, 0.3),
                                                end: Offset.zero,
                                              ).animate(anim),
                                              child: child,
                                            ),
                                          ),
                                      child: Text(
                                        '$rateText $symbol',
                                        key: ValueKey(rateText),
                                        style: GoogleFonts.cairo(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800,
                                          color: branding.accent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(
                              key: const ValueKey('rate_empty'),
                              height: 36.h,
                            ),
                    ),
                  ),

                  // ── Divider ────────────────────────────────────
                  if (showRate) ...[
                    Container(
                      width: 1,
                      height: 36.h,
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      color: branding.accent.withValues(alpha: 0.15),
                    ),
                  ],

                  // ── Fee ────────────────────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppTranslations.getText(ctx, 'fees_label'),
                        style: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          color: branding.secondaryText,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Container(
                          key: ValueKey(fee),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: branding.buildHeaderGradient(),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: branding.accent.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            '$fee%',
                            style: GoogleFonts.cairo(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: branding.buttonText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── Send button ──────────────────────────────────────────────────────────
  Widget _buildSendButton(AppBrandingConfig branding, BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _sendBtnCtrl.reverse(),
      onTapUp: (_) => _sendBtnCtrl.forward(),
      onTapCancel: () => _sendBtnCtrl.forward(),
      onTap: () {
        if (!_isFormValid(context)) {
          _showError(
            context,
            AppTranslations.getTextStatic(context, "Please enter all fields"),
          );
          return;
        }

        final currencyState = context.read<CurrencyCubit>().state;
        final payState = context.read<PaymentMethodsCubit>().state;
        final enteredAmount = double.tryParse(currencyState.amount) ?? 0;

        if (payState is PaymentMethodsSuccess && payState.selected != null) {
          final sel = payState.selected!;
          if (!sel.isActivated) {
            _showError(
              context,
              AppTranslations.getTextStatic(
                context,
                "payment_method_not_active",
              ),
            );
            return;
          }
          final min = sel.minAmount.toDouble();
          final max = sel.maxAmount.toDouble();
          final isAr = Localizations.localeOf(context).languageCode == 'ar';
          if (enteredAmount < min) {
            final t = AppTranslations.getTextStatic(
              context,
              "The amount is less than the minimum for this method",
            );
            _showError(context, isAr ? "$t (\$$min)" : "$t ($min)\$");
            return;
          }
          if (enteredAmount > max) {
            final t = AppTranslations.getTextStatic(
              context,
              "The amount exceeds the maximum for this method",
            );
            _showError(context, isAr ? "$t (\$$max)" : "$t ($max\$)");
            return;
          }
        }

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a1, a2) => const Senderinformation(),
            transitionsBuilder: (_, a1, __, child) => FadeTransition(
              opacity: a1,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOut)),
                child: child,
              ),
            ),
          ),
        );
      },
      child: ScaleTransition(
        scale: _sendBtnScale,
        child: Container(
          height: 58.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: branding.buildHeaderGradient(),
            boxShadow: [
              BoxShadow(
                color: branding.accent.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              AppTranslations.getText(context, 'send_transfer_cta'),
              style: GoogleFonts.cairo(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: branding.buttonText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Helper widgets
// ═══════════════════════════════════════════════════════════════════════════

class _ModernPaymentMethodCard extends StatelessWidget {
  const _ModernPaymentMethodCard({
    required this.branding,
    required this.name,
    required this.logoPath,
    required this.symbol,
    required this.fee,
    required this.selected,
    required this.isActive,
    required this.onTap,
  });

  final AppBrandingConfig branding;
  final String name;
  final String logoPath;
  final String symbol;
  final double fee;
  final bool selected;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'https://admin-api.7awalaty.com/$logoPath';

    return AnimatedScale(
      scale: selected ? 1.0 : 0.97,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: selected
                ? branding.accent.withValues(alpha: 0.1)
                : branding.cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: selected
                  ? branding.accent
                  : branding.accent.withValues(alpha: 0.15),
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? branding.accent.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: selected ? 14 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // ── Horizontal layout: logo | info ──────────────────────
          child: Row(
            children: [
              // Logo box
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(6.r),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: branding.accent,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 18.sp,
                        color: branding.accent.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  // Selected checkmark badge
                  if (selected)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: branding.buildHeaderGradient(),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 9.sp,
                          color: branding.buttonText,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 10.w),

              // Info column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? branding.accent
                            : branding.primaryText,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    // Chips row: symbol + fee + status dot
                    Row(
                      children: [
                        _Chip(
                          label: symbol.toUpperCase(),
                          color: branding.accent.withValues(alpha: 0.12),
                          textColor: branding.accent,
                          branding: branding,
                        ),
                        SizedBox(width: 4.w),
                        _Chip(
                          label:
                              '${fee.toStringAsFixed(fee % 1 == 0 ? 0 : 1)}%',
                          color: branding.link.withValues(alpha: 0.35),
                          textColor: branding.secondaryText,
                          branding: branding,
                        ),
                        const Spacer(),
                        Container(
                          width: 6.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? Colors.green : Colors.redAccent,
                          ),
                        ),
                      ],
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

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    required this.textColor,
    required this.branding,
  });
  final String label;
  final Color color;
  final Color textColor;
  final AppBrandingConfig branding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.branding});
  final String label;
  final AppBrandingConfig branding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            gradient: branding.buildHeaderGradient(),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: branding.primaryText,
          ),
        ),
      ],
    );
  }
}

class _DestinationRow extends StatelessWidget {
  const _DestinationRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.trailing,
    required this.branding,
    required this.onTap,
    this.isLoading = false,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget trailing;
  final AppBrandingConfig branding;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final selected = value != label;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isFirst ? 20.r : 0),
          topRight: Radius.circular(isFirst ? 20.r : 0),
          bottomLeft: Radius.circular(isLast ? 20.r : 0),
          bottomRight: Radius.circular(isLast ? 20.r : 0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: selected
                      ? branding.accent.withOpacity(0.15)
                      : branding.accent.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  size: 18.sp,
                  color: selected ? branding.accent : branding.secondaryText,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: isLoading
                    ? SizedBox(
                        height: 16.h,
                        width: 80.w,
                        child: LinearProgressIndicator(
                          color: branding.accent,
                          backgroundColor: branding.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: GoogleFonts.cairo(
                              fontSize: 11.sp,
                              color: branding.secondaryText,
                            ),
                          ),
                          Text(
                            value,
                            style: GoogleFonts.cairo(
                              fontSize: 14.sp,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected
                                  ? branding.primaryText
                                  : branding.secondaryText.withOpacity(0.78),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),
              SizedBox(width: 8.w),
              trailing,
              SizedBox(width: 4.w),
              Icon(
                isRtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                size: 20.sp,
                color: branding.secondaryText.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.branding});
  final AppBrandingConfig branding;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16.w,
      endIndent: 16.w,
      color: branding.accent.withOpacity(0.1),
    );
  }
}

class _DropdownCard extends StatelessWidget {
  const _DropdownCard({
    required this.branding,
    required this.children,
    this.maxHeight,
  });
  final AppBrandingConfig branding;
  final List<Widget> children;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(16.r),
      color: branding.cardBg,
      shadowColor: Colors.black26,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight ?? 220.h),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          shrinkWrap: true,
          children: children,
        ),
      ),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  const _DropdownTile({required this.label, required this.onTap, this.leading});
  final String label;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
      leading: leading,
      title: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: branding.primaryText,
        ),
      ),
      onTap: onTap,
    );
  }
}
