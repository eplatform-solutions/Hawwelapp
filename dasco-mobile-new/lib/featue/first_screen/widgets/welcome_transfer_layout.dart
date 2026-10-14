import 'dart:async';

import 'package:hawwel/constans/country_defaults_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/digit_utils.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/localization/langhelper.dart';
import 'package:hawwel/featue/auth/login/login_screen_view.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_airea/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_airea/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_stat_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_conversion_methods/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_conversion_methods/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_country_payment_methods/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_country_payment_methods/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubite_rate/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubite_rate/cubit_state.dart';
import 'package:hawwel/featue/auth/welcomyou/data/resolved_payment_selection.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart'
    show PaymentMethodModel;
import 'package:hawwel/featue/auth/welcomyou/widjt/amount_send.dart';
import 'package:hawwel/featue/auth/welcomyou/widjt/edit_rsive.dart';
import 'package:hawwel/featue/auth/welcomyou/widjt/language_toggle_pill.dart';
import 'package:hawwel/featue/auth/welcomyou/widjt/notification_header_button.dart';
import 'package:hawwel/featue/auth/welcomyou/widjt/trkalthoel.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit_stat.dart';
import 'package:hawwel/featue/profail/data/kyc_status_helper.dart';
import 'package:hawwel/featue/idintity_veryfation/idinty_verv.dart';
import 'package:hawwel/featue/sender_information/sender_information_screen_view.dart';

/// Shared transfer UI matching the welcome reception layout.
/// [isAuthenticated]: true = post-login (notifications, validation, sender info).
class WelcomeTransferLayout extends StatefulWidget {
  const WelcomeTransferLayout({super.key, this.isAuthenticated = false});

  final bool isAuthenticated;

  @override
  State<WelcomeTransferLayout> createState() => _WelcomeTransferLayoutState();
}

bool isDropdownOpen = false;

class _WelcomeTransferLayoutState extends State<WelcomeTransferLayout> {
  @override
  void initState() {
    super.initState();

    if (widget.isAuthenticated) {
      context.read<NotificationsCubit>().fetchNotifications();
    }

    context.read<ExchangeRatesCubit>().fetchRates();

    final defaultAmount = widget.isAuthenticated ? '1' : null;
    if (widget.isAuthenticated && defaultAmount != null) {
      context.read<CurrencyCubit>().changeAmount(defaultAmount);
    }
    amountController = TextEditingController(
      text: widget.isAuthenticated
          ? (defaultAmount ?? '1')
          : context.read<CurrencyCubit>().state.amount,
    );
    receiverController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<CountriesCubit>().fetchCountries(
        confirmCountrySelection: false,
      );
      if (!mounted) return;
      // Only covers a country the user had already confirmed in a previous
      // mount of this screen (isCountrySelected == true) - fetchCountries
      // is called here with confirmCountrySelection: false specifically so
      // a fresh load never silently treats countries.first as chosen.
      final countryState = context.read<CountriesCubit>().state;
      if (countryState is CountriesSuccess && countryState.isCountrySelected) {
        context.read<CitiesCubit>().fetchCities(countryState.selected.id);
        context.read<CountryPaymentMethodsCubit>().fetchMethods(
          countryState.selected.id,
        );
      }
    });

    _rateTimer = Timer.periodic(const Duration(seconds: 45), (timer) {
      if (!mounted) return;
      if (_countriesOverlay != null ||
          _citiesOverlay != null ||
          _areasOverlay != null) {
        return;
      }
      context.read<ExchangeRatesCubit>().fetchRates();
    });
  }

  OverlayEntry? _countriesOverlay;
  final GlobalKey _countryFieldKey = GlobalKey();
  final GlobalKey _governorateFieldKey = GlobalKey();
  final GlobalKey _cityFieldKey = GlobalKey();

  OverlayEntry? _citiesOverlay;
  OverlayEntry? _areasOverlay;
  int _overlayRequestNonce = 0;

  int _issueOverlayRequest() => ++_overlayRequestNonce;
  bool _isOverlayRequestActive(int nonce) =>
      mounted && nonce == _overlayRequestNonce;
  void _invalidateOverlayRequests() {
    _overlayRequestNonce++;
  }

  Rect? _anchorRect(GlobalKey key) {
    final ro = key.currentContext?.findRenderObject() as RenderBox?;
    if (ro == null || !ro.hasSize) return null;
    return ro.localToGlobal(Offset.zero) & ro.size;
  }

  TextStyle _dropdownListTitleStyle(Color secondaryColor) {
    return GoogleFonts.cairo(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: secondaryColor,
    );
  }

  Widget _dropdownMenuItemRow({
    Widget? leading,
    required String label,
    required TextStyle titleStyle,
    required VoidCallback onTap,
    double? verticalPadding,
  }) {
    final Widget startSlot = SizedBox(
      width: 48,
      child: Center(child: leading ?? const SizedBox.shrink()),
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 56.h),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: (verticalPadding ?? 8).h,
              horizontal: 6.w,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                startSlot,
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _removeAreasOverlay() {
    _invalidateOverlayRequests();
    _areasOverlay?.remove();
    _areasOverlay = null;
  }

  void _closeAllOverlays() {
    _invalidateOverlayRequests();
    _countriesOverlay?.remove();
    _countriesOverlay = null;

    _citiesOverlay?.remove();
    _citiesOverlay = null;

    _areasOverlay?.remove();
    _areasOverlay = null;
  }

  void _openAreasDropdown(BuildContext callerContext, AreasSuccess state) {
    _closeAllOverlays();
    final requestNonce = _issueOverlayRequest();
    final overlayState = Overlay.of(callerContext);
    final branding = appBrandingNotifier.value;
    final isArabic = Localizations.localeOf(callerContext).languageCode == 'ar';
    final mq = MediaQuery.of(callerContext);
    final areasCubit = context.read<AreasCubit>();
    final paymentMethodsCubit = context.read<PaymentMethodsCubit>();
    final areas = List.from(state.areas);
    final titleStyle = _dropdownListTitleStyle(branding.secondaryText);

    void insertAt(Rect rect) {
      if (!_isOverlayRequestActive(requestNonce)) return;
      final maxW = mq.size.width - mq.padding.horizontal;
      final w = rect.width.clamp(120.0, maxW);
      var left = rect.left;
      if (left + w > mq.size.width - mq.padding.right) {
        left = mq.size.width - mq.padding.right - w;
      }
      if (left < mq.padding.left) left = mq.padding.left;

      _areasOverlay = OverlayEntry(
        builder: (_) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _removeAreasOverlay,
              ),
            ),
            Positioned(
              left: left,
              top: rect.bottom + 4,
              width: w,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                color: branding.cardBg,
                child: Directionality(
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 250.h),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: areas.length,
                      itemBuilder: (context, index) {
                        final area = areas[index];
                        final label = isArabic ? area.nameAr : area.nameEn;
                        return _dropdownMenuItemRow(
                          label: label,
                          titleStyle: titleStyle,
                          onTap: () {
                            if (!mounted) return;
                            areasCubit.selectArea(area);
                            paymentMethodsCubit.fetchMethods(area.id);
                            _removeAreasOverlay();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      if (!_isOverlayRequestActive(requestNonce)) return;
      overlayState.insert(_areasOverlay!);
    }

    final rect0 = _anchorRect(_cityFieldKey);
    if (rect0 != null) {
      insertAt(rect0);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isOverlayRequestActive(requestNonce)) return;
        final rect = _anchorRect(_cityFieldKey);
        if (rect == null) return;
        insertAt(rect);
      });
    }
  }

  void _removeCitiesOverlay() {
    _invalidateOverlayRequests();
    _citiesOverlay?.remove();
    _citiesOverlay = null;
  }

  void _openCitiesDropdown(BuildContext callerContext, CitiesSuccess state) {
    _closeAllOverlays();
    final requestNonce = _issueOverlayRequest();
    final overlayState = Overlay.of(callerContext);
    final branding = appBrandingNotifier.value;
    final isArabic = Localizations.localeOf(callerContext).languageCode == 'ar';
    final mq = MediaQuery.of(callerContext);
    final citiesCubit = context.read<CitiesCubit>();
    final areasCubit = context.read<AreasCubit>();
    final paymentMethodsCubit = context.read<PaymentMethodsCubit>();
    final cities = List<CityModel>.from(state.cities);
    final titleStyle = _dropdownListTitleStyle(branding.secondaryText);

    void insertAt(Rect rect) {
      if (!_isOverlayRequestActive(requestNonce)) return;
      final maxW = mq.size.width - mq.padding.horizontal;
      final w = rect.width.clamp(120.0, maxW);
      var left = rect.left;
      if (left + w > mq.size.width - mq.padding.right) {
        left = mq.size.width - mq.padding.right - w;
      }
      if (left < mq.padding.left) left = mq.padding.left;

      _citiesOverlay = OverlayEntry(
        builder: (_) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _removeCitiesOverlay,
              ),
            ),
            Positioned(
              left: left,
              top: rect.bottom + 4,
              width: w,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                color: branding.cardBg,
                child: Directionality(
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 250.h),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        final label = isArabic ? city.nameAr : city.nameEn;
                        return _dropdownMenuItemRow(
                          label: label,
                          titleStyle: titleStyle,
                          onTap: () {
                            if (!mounted) return;
                            citiesCubit.selectCity(city);
                            unawaited(areasCubit.fetchAreas(city.id));
                            paymentMethodsCubit.reset();
                            _removeAreasOverlay();
                            _removeCitiesOverlay();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      if (!_isOverlayRequestActive(requestNonce)) return;
      overlayState.insert(_citiesOverlay!);
    }

    final rect0 = _anchorRect(_governorateFieldKey);
    if (rect0 != null) {
      insertAt(rect0);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isOverlayRequestActive(requestNonce)) return;
        final rect = _anchorRect(_governorateFieldKey);
        if (rect == null) return;
        insertAt(rect);
      });
    }
  }

  /// Country picker: opens immediately (loading inside overlay until API returns).
  void _showCountriesPickerOverlay(BuildContext callerContext) {
    _closeAllOverlays();
    final requestNonce = _issueOverlayRequest();
    final overlayState = Overlay.of(callerContext);
    final branding = appBrandingNotifier.value;
    final mq = MediaQuery.of(callerContext);
    final countriesCubit = context.read<CountriesCubit>();
    final citiesCubit = context.read<CitiesCubit>();
    final areasCubit = context.read<AreasCubit>();
    final paymentMethodsCubit = context.read<PaymentMethodsCubit>();
    final countryPaymentMethodsCubit =
        context.read<CountryPaymentMethodsCubit>();
    final titleStyle = _dropdownListTitleStyle(branding.secondaryText);

    void insertAt(Rect rect) {
      if (!_isOverlayRequestActive(requestNonce)) return;
      final maxW = mq.size.width - mq.padding.horizontal;
      final w = rect.width.clamp(120.0, maxW);
      var left = rect.left;
      if (left + w > mq.size.width - mq.padding.right) {
        left = mq.size.width - mq.padding.right - w;
      }
      if (left < mq.padding.left) left = mq.padding.left;

      _countriesOverlay = OverlayEntry(
        builder: (overlayContext) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeAllOverlays,
              ),
            ),
            Positioned(
              left: left,
              top: rect.bottom + 4,
              width: w,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                color: branding.cardBg,
                child: BlocBuilder<CountriesCubit, CountriesState>(
                  bloc: countriesCubit,
                  buildWhen: (prev, curr) =>
                      curr is CountriesSuccess ||
                      curr is CountriesLoading ||
                      curr is CountriesInitial ||
                      curr is CountriesFailure,
                  builder: (ctx, state) {
                    if (state is CountriesSuccess) {
                      return Container(
                        constraints: BoxConstraints(maxHeight: 250.h),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: state.countries.length,
                          itemBuilder: (itemCtx, index) {
                            final c = state.countries[index];
                            final countryName =
                                CountryDefaultsHelper.localizedCountryName(
                                  itemCtx,
                                  c.code,
                                  fallback: c.code,
                                );
                            final leading = CountryDefaultsHelper.countryFlag(
                              c.code,
                              size: 20,
                            );
                            return _dropdownMenuItemRow(
                              leading: leading,
                              label: countryName,
                              titleStyle: titleStyle,
                              onTap: () {
                                if (!mounted) return;
                                final currentCountryState =
                                    countriesCubit.state;
                                final currentCountryId =
                                    currentCountryState is CountriesSuccess
                                    ? currentCountryState.selected.id
                                    : null;
                                final wasConfirmed =
                                    currentCountryState is CountriesSuccess &&
                                    currentCountryState.isCountrySelected;
                                // Also true on the very first real tap, even
                                // when it happens to match the unconfirmed
                                // phantom default (e.g. it's alphabetically
                                // first) - otherwise this looks like "no
                                // change" and the country-level payment
                                // methods fetch never fires.
                                final didChangeCountry =
                                    currentCountryId != c.id || !wasConfirmed;

                                _removeCitiesOverlay();
                                countriesCubit.selectCountry(c);
                                if (didChangeCountry) {
                                  citiesCubit.reset();
                                  areasCubit.reset();
                                  paymentMethodsCubit.reset();
                                  countryPaymentMethodsCubit.reset();
                                  // نجلب المدن مسبقاً فقط لمعرفة إن كان
                                  // البلد بلا مدن أصلاً، فنخفي مربع
                                  // المحافظة كلياً بدل تركه بدون استعمال.
                                  citiesCubit.fetchCities(c.id);
                                  countryPaymentMethodsCubit.fetchMethods(
                                    c.id,
                                  );
                                }
                                _countriesOverlay?.remove();
                                _countriesOverlay = null;
                              },
                            );
                          },
                        ),
                      );
                    }
                    if (state is CountriesFailure) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.error,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 13.sp,
                                color: branding.error,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            TextButton(
                              onPressed: () {
                                unawaited(
                                  countriesCubit.fetchCountries(
                                    confirmCountrySelection: false,
                                  ),
                                );
                              },
                              child: Text(
                                AppTranslations.getText(ctx, 'Ok'),
                                style: TextStyle(color: branding.iconPrimary),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox(
                      height: 100.h,
                      child: Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: branding.iconPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );

      if (!_isOverlayRequestActive(requestNonce)) return;
      overlayState.insert(_countriesOverlay!);
    }

    final rect0 = _anchorRect(_countryFieldKey);
    if (rect0 != null) {
      insertAt(rect0);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isOverlayRequestActive(requestNonce)) return;
        final rect = _anchorRect(_countryFieldKey);
        if (rect == null) return;
        insertAt(rect);
      });
    }
  }

  // Widget _countryBox({
  //   required String title,
  //   required Widget flag,
  //   required VoidCallback onArrowTap,
  // }) {
  //   return CustomPaint(
  //     painter: _CustomBorderPainter(leftGap: 0, rightGap: 70.w),
  //     child: Container(
  //       width: 170.w,
  //       height: 45.h,
  //       padding: EdgeInsets.symmetric(horizontal: 8.w),
  //       child: Row(
  //         children: [
  //           GestureDetector(
  //             onTap: onArrowTap,
  //             child: Image.asset(AppImages.trkyicon, height: 25.h, width: 25.h),
  //           ),
  //           SizedBox(width: 15.w),
  //           Expanded(
  //             child: Text(
  //               title,
  //               maxLines: 1,
  //               style: GoogleFonts.cairo(
  //                 fontSize: 16.sp,
  //                 fontWeight: FontWeight.w600,
  //                 color: const Color(0xFFB9A779),
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 26.w, height: 25.h, child: flag),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Timer? _rateTimer;
  late TextEditingController amountController;
  late TextEditingController receiverController;
  bool _isUpdating = false;
  final Set<String> _prefetchedPaymentLogoUrls = <String>{};

  void _prefetchPaymentMethodLogos(
    BuildContext context,
    List<PaymentMethodModel> methods,
  ) {
    final futures = <Future<void>>[];
    for (final method in methods) {
      for (final url in paymentLogoUrlCandidates(method.logoPath)) {
        if (!_prefetchedPaymentLogoUrls.add(url)) continue;
        futures.add(
          precacheImage(NetworkImage(url), context).catchError((_) {}),
        );
      }
    }
    if (futures.isNotEmpty) {
      unawaited(Future.wait(futures));
    }
  }

  double _resolveRateForPayoutSymbol(
    ExchangeRatesState rateState,
    CurrencyType sendingCurrency,
    String payoutSymbol,
  ) {
    final sendKey = sendingCurrency == CurrencyType.usdt ? "USDT" : "USDC";
    final symbol = payoutSymbol.trim().toUpperCase();

    if (symbol == "USDT" || symbol == "USDC") return 1.0;
    if (rateState is! ExchangeRatesSuccess) return 1.0;

    final dynamic rateEntry = rateState.data.rates[symbol];
    if (rateEntry is Map) {
      final dynamic selectedRate = rateEntry[sendKey];
      final parsed = double.tryParse(selectedRate?.toString() ?? "");
      if (parsed != null && parsed > 0) return parsed;
    }

    if (symbol == "SYP") {
      final legacy = rateState.data.rates[sendKey];
      final parsed = double.tryParse(legacy?.toString() ?? "");
      if (parsed != null && parsed > 0) return parsed;
    }

    return 1.0;
  }

  String _trimTrailingZero(double v) =>
      v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  String _rateTextForSymbol(
    String rawSymbol,
    ExchangeRatesState rateState,
    CurrencyType sendingCurrency,
    String sendKey,
    bool isArabic,
  ) {
    final symbol = rawSymbol.trim().toUpperCase();
    final payoutLabel = SendCurrencyHelper.displayLabelForSymbol(
      symbol,
      isArabic: isArabic,
    );
    if (symbol == 'USDT' || symbol == 'USDC') {
      return '1 $sendKey ≈ 1 $payoutLabel';
    }
    final rate = _resolveRateForPayoutSymbol(rateState, sendingCurrency, symbol);
    return '1 $sendKey ≈ ${_trimTrailingZero(rate)} $payoutLabel';
  }

  Widget _rateFeeSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    required dynamic branding,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: branding.accent),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: branding.secondaryText,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: branding.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  /// Two-line summary shown above the send button only once a payment
  /// method is selected: the transfer fee and the exchange rate for that
  /// method. Reuses the same [ExchangeRatesCubit]/[PaymentMethodsCubit]
  /// state and [_resolveRateForPayoutSymbol] the receiver-amount field
  /// already watches, so it needs no extra fetch.
  Widget _buildRateFeeSummaryTable(BuildContext context, bool isArabic) {
    final branding = appBrandingNotifier.value;
    return BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
      buildWhen: (previous, current) => current is ExchangeRatesSuccess,
      builder: (context, rateState) {
        return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
          builder: (context, paymentState) {
            // Country-level methods live in a separate cubit; reading only
            // the region one left this card blank (or on SYP) for them.
            final resolved = resolvePaymentSelection(
              cityState: context.watch<CitiesCubit>().state,
              areaState: context.watch<AreasCubit>().state,
              paymentState: paymentState,
              countryPaymentState:
                  context.watch<CountryPaymentMethodsCubit>().state,
            );
            if (resolved == null) return const SizedBox.shrink();
            final selected = resolved.method;

            final sendingCurrency =
                context.watch<CurrencyCubit>().state.currency;
            final sendKey =
                sendingCurrency == CurrencyType.usdt ? 'USDT' : 'USDC';
            final feeText = '${_trimTrailingZero(selected.fee)}%';
            final rateText = _rateTextForSymbol(
              selected.symbol,
              rateState,
              sendingCurrency,
              sendKey,
              isArabic,
            );
            final dividerColor = branding.accent.withValues(alpha: 0.15);

            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: branding.accent.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: branding.accent.withValues(alpha: 0.18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _rateFeeSummaryRow(
                    icon: Icons.percent_rounded,
                    label: AppTranslations.getText(
                      context,
                      'transfer_fee_label',
                    ),
                    value: feeText,
                    branding: branding,
                  ),
                  Divider(height: 1, thickness: 0.6, color: dividerColor),
                  _rateFeeSummaryRow(
                    icon: Icons.currency_exchange_rounded,
                    label: AppTranslations.getText(
                      context,
                      'rate_summary_label',
                    ),
                    value: rateText,
                    branding: branding,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Same grid/tile used for both the region-scoped and the country-level
  /// payment methods - they render in the identical box, so they share one
  /// builder rather than each screen owning its own copy.
  Widget _buildPaymentMethodsGrid(
    BuildContext context,
    List<PaymentMethodModel> methods, {
    required PaymentMethodModel? selected,
    required bool isCountryLevel,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.55,
      ),
      itemCount: methods.length,
      itemBuilder: (context, index) {
        final m = methods[index];

        return Trkalthoel(
          image: m.normalizedLogoUrl.isNotEmpty
              ? m.normalizedLogoUrl
              : (m.normalizedLogoPath.isNotEmpty
                    ? m.normalizedLogoPath
                    : (m.cardLogoPath.isNotEmpty
                          ? m.cardLogoPath
                          : (m.originalLogoUrl.isNotEmpty
                                ? m.originalLogoUrl
                                : m.logoPath))),
          namer: LangHelper.isArabic(context) ? m.nameAr : m.nameEn,
          selected: selected?.id == m.id,
          onTap: () =>
              _handleMethodSelected(context, m, isCountryLevel: isCountryLevel),
        );
      },
    );
  }

  void _handleMethodSelected(
    BuildContext context,
    PaymentMethodModel m, {
    required bool isCountryLevel,
  }) {
    // 1. تحديد الطريقة المختارة - وإلغاء اختيار الطريقة الأخرى، بحيث يبقى
    // مسار واحد فقط (منطقة أو بلد) مُعتمداً في كل لحظة.
    if (isCountryLevel) {
      context.read<CountryPaymentMethodsCubit>().selectMethod(m);
      context.read<PaymentMethodsCubit>().clearSelection();
    } else {
      context.read<PaymentMethodsCubit>().selectMethod(m);
      context.read<CountryPaymentMethodsCubit>().clearSelection();
    }

    final fee = m.fee.toDouble();
    final symbol = m.symbol; // العملة الخاصة بالوسيلة المختارة (SYP, USDT, etc..)

    // 2. جلب سعر الصرف الحالي من الـ ExchangeRatesCubit
    double currentRate = 1.0;
    final rateState = context.read<ExchangeRatesCubit>().state;
    if (rateState is ExchangeRatesSuccess) {
      final sendingCurrency = context.read<CurrencyCubit>().state.currency;
      currentRate = _resolveRateForPayoutSymbol(
        rateState,
        sendingCurrency,
        symbol,
      );
    }

    // 3. تحديث الحسابات بناءً على الحقل الممتلئ
    final sendAmountStr = context.read<CurrencyCubit>().state.amount;
    final parsedSend = tryParseWesternAmount(sendAmountStr) ?? 0;
    if (sendAmountStr.isNotEmpty && parsedSend > 0) {
      onSendChanged(sendAmountStr, fee);
    } else if (receiverController.text.isNotEmpty) {
      // استدعاء الدالة بـ 4 بارامترات كما تم تعريفها حديثاً
      onReceiverChanged(receiverController.text, fee, currentRate, symbol);
    }
  }

  void onSendChanged(String value, double fee) {
    if (_isUpdating) return;
    _isUpdating = true;

    double amount = tryParseWesternAmount(value) ?? 0;

    if (amount > 0) {
      // المبلغ المدخل مضروب في (1 ناقص النسبة)
      double receiverAmount = amount - (amount * (fee / 100));

      // تحديث خانة المستلم بدقة عشرية أيضاً
      receiverController.text = receiverAmount.toStringAsFixed(2);

      context.read<CurrencyCubit>().changeAmount(amount.toString());
    } else {
      receiverController.clear();
    }
    _isUpdating = false;
  }

  void onReceiverChanged(String value, double fee, double rate, String symbol) {
    if (_isUpdating) return;
    _isUpdating = true;

    double receiverAmount = tryParseWesternAmount(value) ?? 0;

    if (receiverAmount > 0) {
      double totalAmountInUSD;

      final normalizedSymbol = symbol.trim().toUpperCase();
      final isCryptoPayout =
          normalizedSymbol == "USDT" || normalizedSymbol == "USDC";

      if (!isCryptoPayout) {
        final safeRate = rate > 0 ? rate : 1.0;
        double netAmountInUSD = receiverAmount / safeRate;
        totalAmountInUSD = netAmountInUSD / (1 - (fee / 100));
      } else {
        totalAmountInUSD = receiverAmount / (1 - (fee / 100));
      }

      // تحديث خانة المرسل (دائماً دولار بكسرين عشريين)
      String finalAmountStr = totalAmountInUSD.toStringAsFixed(2);
      amountController.text = finalAmountStr;

      // تحديث الكيوبيت بالمبلغ الكلي بالدولار
      context.read<CurrencyCubit>().changeAmount(finalAmountStr);
    } else {
      amountController.clear();
      context.read<CurrencyCubit>().changeAmount("0");
    }

    _isUpdating = false;
  }

  @override
  void dispose() {
    _rateTimer?.cancel();
    _closeAllOverlays();
    amountController.dispose();
    receiverController.dispose();
    super.dispose();
  }

  static const String _appLogoAsset =
      'asset/4cb89412e17e9731c5a074ee767cc8afb7213109.png';

  Widget _buildCurrencyToggleChip(BuildContext context) {
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, state) {
        final isUsdt = state.currency == CurrencyType.usdt;
        // With a single allowed stablecoin there is nothing to toggle between,
        // and a tappable chip that refuses to change reads as a broken button.
        final canSwitch = SendCurrencyHelper.hasCurrencyChoice;
        return Material(
          color: Colors.white.withValues(alpha: 0.25),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: !canSwitch
                ? null
                : () {
              HapticFeedback.mediumImpact();
              context.read<CurrencyCubit>().toggleCurrency();
            },
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: Image.asset(
                isUsdt ? AppImages.usdt : AppImages.usdc,
                height: 22.h,
                width: 22.w,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Fixed LTR header: [notifications][currency] … title … [language][logo]
  Widget _buildFixedHomeHeaderBar(BuildContext context, dynamic branding) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NotificationHeaderButton(requireAuth: !widget.isAuthenticated),
              SizedBox(width: 8.w),
              _buildCurrencyToggleChip(context),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                AppTranslations.getText(context, 'welcome_title'),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: branding.textColorValue,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LanguageTogglePill(),
              SizedBox(width: 8.w),
              Image.asset(_appLogoAsset, height: 28.h, width: 28.w),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;
    final homeScreenBg = branding.screenBg;
    final homePrimaryText = branding.primaryText;
    final homeSecondaryText = branding.secondaryText;
    final homeBorderColor = branding.cardBorder;
    final homeButtonText = branding.buttonText;
    BoxDecoration locationFieldBorder() => BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: branding.accent, width: 2),
    );
    TextStyle locationFieldTitleStyle() => GoogleFonts.cairo(
      fontSize: 15.sp,
      fontWeight: FontWeight.w700,
      height: 1.25,
      color: branding.textColorValue,
    );
    // Widget _countryBox({
    //   required String title,
    //   required Widget flag,
    //   required VoidCallback onArrowTap,
    // }) {
    //   return CustomPaint(
    //     painter: _CustomBorderPainter(
    //       leftGap: isArabic ? 0 : 70.w,
    //       rightGap: isArabic ? 70.w : 0,
    //     ),
    //     child: Container(
    //       width: 170.w,
    //       height: 45.h,
    //       padding: EdgeInsets.symmetric(horizontal: 8.w),
    //       child: Row(
    //         //mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           GestureDetector(
    //             onTap: onArrowTap,
    //             child: Image.asset(
    //               AppImages.trkyicon,
    //               height: 25.h,
    //               width: 20.h,
    //             ),
    //           ),

    //           SizedBox(
    //             width: isArabic
    //                 ? title == "أختر الدولة"
    //                       ? 25.w
    //                       : 35.w
    //                 : title == "Choose country"
    //                 ? 8.w
    //                 : 35.w,
    //           ),
    //           Expanded(
    //             child: Text(
    //               title,
    //               maxLines: 1,
    //               style: GoogleFonts.cairo(
    //                 fontSize: 14.sp,
    //                 fontWeight: FontWeight.w600,
    //                 color: const Color(0xFFB9A779),
    //               ),
    //             ),
    //           ),
    //           SizedBox(width: 25.w, height: 25.h, child: flag),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    Widget countryBox({
      required String title,
      required Widget flag,
      required VoidCallback onTap,
      double? boxWidth,
      Key? boxKey,
    }) {
      return GestureDetector(
        key: boxKey,
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: boxWidth ?? double.infinity,
            height: 45.h,
            decoration: locationFieldBorder(),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppImages.trkyicon,
                      height: 20.h,
                      width: 17,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: locationFieldTitleStyle(),
                  ),
                ),
                SizedBox(
                  width: 25.w,
                  height: 25.h,
                  child: flag,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: homeScreenBg,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _closeAllOverlays();
            FocusScope.of(context).unfocus();
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification ||
                  notification is ScrollUpdateNotification ||
                  notification is UserScrollNotification) {
                _closeAllOverlays();
              }
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 130.h),
                    decoration: BoxDecoration(color: homeScreenBg),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: branding.buildHeaderGradient(),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SafeArea(
                                bottom: false,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    16.w,
                                    10.h,
                                    16.w,
                                    12.h,
                                  ),
                                  child: _buildFixedHomeHeaderBar(
                                    context,
                                    branding,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    BlocConsumer<
                                      CountriesCubit,
                                      CountriesState
                                    >(
                                      // 1. هون بنعرض الديالوج أول ما الحالة تصير Failure
                                      listener: (context, state) {
                                        if (state is CountriesFailure) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: homeBorderColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    AppImages.eerorrimage,
                                                    height: 50,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    state.error,
                                                    style: TextStyle(
                                                      color:
                                                          branding.buttonText,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(
                                                    AppTranslations.getText(
                                                      context,
                                                      "Ok",
                                                    ),
                                                    style: TextStyle(
                                                      color:
                                                          branding.buttonText,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      // 2. هون الـ UI بضل شغال طبيعي ومستقر
                                      builder: (context, state) {
                                        // حالة البداية
                                        if (state is CountriesInitial) {
                                          return countryBox(
                                            title: AppTranslations.getText(
                                              context,
                                              'Choose country',
                                            ),
                                            flag: const SizedBox(),
                                            boxKey: _countryFieldKey,
                                            onTap: () {
                                              final cubit = context
                                                  .read<CountriesCubit>();
                                              final citiesCubit = context
                                                  .read<CitiesCubit>();
                                              final areasCubit = context
                                                  .read<AreasCubit>();
                                              final paymentMethodsCubit =
                                                  context
                                                      .read<
                                                        PaymentMethodsCubit
                                                      >();
                                              citiesCubit.reset();
                                              areasCubit.reset();
                                              paymentMethodsCubit.reset();
                                              _showCountriesPickerOverlay(
                                                context,
                                              );
                                              unawaited(
                                                cubit.fetchCountries(
                                                  confirmCountrySelection:
                                                      false,
                                                ),
                                              );
                                            },
                                          );
                                        }

                                        // حالة التحميل
                                        if (state is CountriesLoading) {
                                          return KeyedSubtree(
                                            key: _countryFieldKey,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                width: double.infinity,
                                                height: 45.h,
                                                decoration:
                                                    locationFieldBorder(),
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color:
                                                              homeSecondaryText,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }

                                        // حالة الخطأ (هون بنرجع الـ Box فاضي أو عليه رسالة بسيطة عشان ما يضرب التصميم)
                                        if (state is CountriesFailure) {
                                          return countryBox(
                                            title: AppTranslations.getText(
                                              context,
                                              'Choose country',
                                            ),
                                            flag: Icon(
                                              Icons.error_outline,
                                              color: branding.error,
                                            ),
                                            boxKey: _countryFieldKey,
                                            onTap: () {
                                              _showCountriesPickerOverlay(
                                                context,
                                              );
                                              unawaited(
                                                context
                                                    .read<CountriesCubit>()
                                                    .fetchCountries(
                                                      confirmCountrySelection:
                                                          false,
                                                    ),
                                              );
                                            },
                                          );
                                        }

                                        // حالة النجاح
                                        if (state is CountriesSuccess) {
                                          if (!state.isCountrySelected) {
                                            return countryBox(
                                              title: AppTranslations.getText(
                                                context,
                                                'Choose country',
                                              ),
                                              flag: const SizedBox(),
                                              boxKey: _countryFieldKey,
                                              onTap: () =>
                                                  _showCountriesPickerOverlay(
                                                    context,
                                                  ),
                                            );
                                          }

                                          final selected = state.selected;
                                          final translatedName =
                                              CountryDefaultsHelper
                                                  .localizedCountryName(
                                                context,
                                                selected.code,
                                                fallback: selected.code,
                                              );

                                          return BlocBuilder<
                                            CitiesCubit,
                                            CitiesState
                                          >(
                                            builder: (context, cityState) {
                                              String title =
                                                  AppTranslations.getText(
                                                    context,
                                                    'choose_governorate',
                                                  );
                                              if (cityState is CitiesSuccess &&
                                                  cityState.selected != null) {
                                                title =
                                                    LangHelper.isArabic(context)
                                                    ? cityState.selected!.nameAr
                                                    : cityState
                                                          .selected!
                                                          .nameEn;
                                              }

                                              final governorateBox = KeyedSubtree(
                                                key: _governorateFieldKey,
                                                child: GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: () async {
                                                    if (cityState
                                                        is CitiesLoading) {
                                                      return;
                                                    }

                                                    _removeCitiesOverlay();

                                                    final cs = context
                                                        .read<CountriesCubit>()
                                                        .state;
                                                    if (cs
                                                        is! CountriesSuccess) {
                                                      return;
                                                    }

                                                    final countryId =
                                                        cs.selected.id;

                                                    final citiesCubit = context
                                                        .read<CitiesCubit>();
                                                    await citiesCubit
                                                        .fetchCities(countryId);
                                                    if (!context.mounted) {
                                                      return;
                                                    }

                                                    final st =
                                                        citiesCubit.state;
                                                    if (st is CitiesSuccess &&
                                                        st.cities.isNotEmpty) {
                                                      _openCitiesDropdown(
                                                        context,
                                                        st,
                                                      );
                                                    }
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: Container(
                                                      height: 45.h,
                                                      decoration:
                                                          locationFieldBorder(),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                          ),
                                                      child:
                                                          cityState
                                                              is CitiesLoading
                                                          ? Center(
                                                              child: SizedBox(
                                                                width: 20,
                                                                height: 20,
                                                                child: CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                  color:
                                                                      homeSecondaryText,
                                                                ),
                                                              ),
                                                            )
                                                          : Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 22,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Image.asset(
                                                                      AppImages
                                                                          .trkyicon,
                                                                      height:
                                                                          12.h,
                                                                      width: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    title,
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        locationFieldTitleStyle(),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 22,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Image.asset(
                                                                      AppImages
                                                                          .ahtermadena,
                                                                      height:
                                                                          20.h,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              );

                                              final countryBoxWidget = countryBox(
                                                title: translatedName,
                                                flag: CountryDefaultsHelper
                                                    .countryFlag(
                                                  selected.code,
                                                  size: 22.sp,
                                                ),
                                                onTap: () {
                                                  _removeCitiesOverlay();
                                                  _showCountriesPickerOverlay(
                                                    context,
                                                  );
                                                },
                                                boxKey: _countryFieldKey,
                                              );

                                              // لسه ما عرفنا إذا كان البلد
                                              // عنده مدن أصلاً (الطلب لسه
                                              // بالطريق) - ما لازم نظهر
                                              // مربع المحافظة أبداً بهاي
                                              // اللحظة، لأنه بيومض ويختفي
                                              // إذا تبين إنه البلد بلا مدن.
                                              final stillResolvingCities =
                                                  cityState is CitiesInitial ||
                                                  cityState is CitiesLoading;

                                              // البلد ليس لديه أي مدينة على
                                              // الإطلاق (يعتمد فقط على طريقة
                                              // دفع مربوطة بالبلد) - نخفي
                                              // مربع المحافظة كلياً بدل أن
                                              // يبقى ظاهراً بدون استعمال.
                                              final countryHasNoCities =
                                                  cityState is CitiesSuccess &&
                                                  cityState.cities.isEmpty;

                                              if (stillResolvingCities ||
                                                  countryHasNoCities) {
                                                return countryBoxWidget;
                                              }

                                              final hasGovernorateSelection =
                                                  cityState is CitiesSuccess &&
                                                  cityState.selected != null;

                                              if (!hasGovernorateSelection) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    countryBoxWidget,
                                                    SizedBox(height: 8.h),
                                                    governorateBox,
                                                  ],
                                                );
                                              }

                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: countryBoxWidget,
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Expanded(
                                                    child: governorateBox,
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        return const SizedBox();
                                      },
                                    ),
                                    BlocBuilder<CountriesCubit, CountriesState>(
                                      builder: (context, countryState) {
                                        if (countryState is! CountriesSuccess ||
                                            !countryState.isCountrySelected) {
                                          return const SizedBox.shrink();
                                        }
                                        return BlocBuilder<
                                          CitiesCubit,
                                          CitiesState
                                        >(
                                          builder: (context, cityState) {
                                            if (cityState is! CitiesSuccess ||
                                                cityState.selected == null) {
                                              return const SizedBox.shrink();
                                            }
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: 12.h,
                                              ),
                                              child: KeyedSubtree(
                                                key: _cityFieldKey,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: BlocBuilder<AreasCubit, AreasState>(
                                                    builder: (context, state) {
                                                      String title =
                                                          AppTranslations.getText(
                                                            context,
                                                            'choose_city_final',
                                                          );

                                                      if (state
                                                          is AreasLoading) {
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 45.h,
                                                            decoration:
                                                                locationFieldBorder(),
                                                            child: Center(
                                                              child: SizedBox(
                                                                width: 20,
                                                                height: 20,
                                                                child: CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                  color:
                                                                      homeSecondaryText,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }

                                                      // A city with no
                                                      // regions configured
                                                      // (e.g. Jordan: only
                                                      // governorates) must
                                                      // not show a region
                                                      // box at all.
                                                      if (state
                                                              is AreasSuccess &&
                                                          state.areas.isEmpty) {
                                                        return const SizedBox
                                                            .shrink();
                                                      }

                                                      if (state
                                                              is AreasSuccess &&
                                                          state.selected !=
                                                              null) {
                                                        title =
                                                            LangHelper.isArabic(
                                                              context,
                                                            )
                                                            ? state
                                                                  .selected!
                                                                  .nameAr
                                                            : state
                                                                  .selected!
                                                                  .nameEn;
                                                      }

                                                      return GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .opaque,
                                                        onTap: () async {
                                                          _removeAreasOverlay();
                                                          final cs = context
                                                              .read<
                                                                CitiesCubit
                                                              >()
                                                              .state;

                                                          if (cs
                                                                  is! CitiesSuccess ||
                                                              cs.selected ==
                                                                  null) {
                                                            return;
                                                          }

                                                          final cityId =
                                                              cs.selected!.id;

                                                          final areasCubit =
                                                              context
                                                                  .read<
                                                                    AreasCubit
                                                                  >();
                                                          await areasCubit
                                                              .fetchAreas(
                                                                cityId,
                                                              );
                                                          if (!context
                                                              .mounted) {
                                                            return;
                                                          }

                                                          final areaState =
                                                              areasCubit.state;

                                                          if (areaState
                                                                  is AreasSuccess &&
                                                              areaState
                                                                  .areas
                                                                  .isNotEmpty) {
                                                            _openAreasDropdown(
                                                              context,
                                                              areaState,
                                                            );
                                                          }
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          child: Container(
                                                            height: 45.h,
                                                            decoration:
                                                                locationFieldBorder(),
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      8.w,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 22,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Image.asset(
                                                                      AppImages
                                                                          .trkyicon,
                                                                      height:
                                                                          15.h,
                                                                      width: 16,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    title,
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        locationFieldTitleStyle(),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 22,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Image.asset(
                                                                      AppImages
                                                                          .ahtermantka,
                                                                      height:
                                                                          17.h,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.h),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          AppTranslations.getText(
                            context,
                            'Conversion methods',
                          ),
                          style: GoogleFonts.cairo(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: homePrimaryText,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
                          listener: (context, state) {
                            if (state is PaymentMethodsSuccess) {
                              _prefetchPaymentMethodLogos(
                                context,
                                state.methods,
                              );
                            }
                          },
                          builder: (context, paymentState) {
                            return BlocConsumer<
                              CountryPaymentMethodsCubit,
                              CountryPaymentMethodsState
                            >(
                              listener: (context, countryState) {
                                if (countryState
                                    is CountryPaymentMethodsSuccess) {
                                  _prefetchPaymentMethodLogos(
                                    context,
                                    countryState.methods,
                                  );
                                }
                              },
                              builder: (context, countryState) {
                                if (paymentState is PaymentMethodsLoading) {
                                  return const CircularProgressIndicator();
                                }

                                if (paymentState is PaymentMethodsFailure) {
                                  return Text(paymentState.error);
                                }

                                if (paymentState is PaymentMethodsSuccess) {
                                  return _buildPaymentMethodsGrid(
                                    context,
                                    paymentState.methods,
                                    selected: paymentState.selected,
                                    isCountryLevel: false,
                                  );
                                }

                                // لم يتم اختيار مدينة/منطقة بعد (أو لم تنجح
                                // طرق الدفع الخاصة بها) - نعرض بدلاً من ذلك
                                // طريقة الدفع المربوطة بالبلد مباشرة إن
                                // وجدت، في نفس المربع وبنفس الشكل، دون أي
                                // حاجة لاختيار مدينة أو منطقة.
                                if (countryState
                                    is CountryPaymentMethodsLoading) {
                                  return const CircularProgressIndicator();
                                }

                                if (countryState
                                        is CountryPaymentMethodsSuccess &&
                                    countryState.methods.isNotEmpty) {
                                  return _buildPaymentMethodsGrid(
                                    context,
                                    countryState.methods,
                                    selected: countryState.selected,
                                    isCountryLevel: true,
                                  );
                                }

                                return const SizedBox();
                              },
                            );
                          },
                        ),

                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 15.0.w,
                        //     vertical: 40.h,
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       BlocBuilder<
                        //         PaymentMethodsCubit,
                        //         PaymentMethodsState
                        //       >(
                        //         builder: (context, state) {
                        //           int fee = 0;
                        //           String symbol = "USDT";

                        //           if (state is PaymentMethodsSuccess &&
                        //               state.selected != null) {
                        //             fee = state.selected!.fee.toInt();

                        //             //
                        //             symbol = state.selected!.symbol;
                        //           }

                        //           return Container(
                        //             height: 54.h,
                        //             width: 250.w,
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.only(
                        //                 topLeft: Radius.circular(
                        //                   8,
                        //                   //  isArabic ? 0 : 8,
                        //                 ),
                        //                 bottomLeft: Radius.circular(
                        //                   8,
                        //                   //   isArabic ? 0 : 8,
                        //                 ),
                        //                 topRight: Radius.circular(
                        //                   8,
                        //                   // isArabic ? 8 : 0,
                        //                 ),
                        //                 bottomRight: Radius.circular(
                        //                   8,
                        //                   //  isArabic ? 8 : 0,
                        //                 ),
                        //               ),
                        //               border: Border.all(
                        //                 color: const Color(0xFF6B1F2A),
                        //               ),
                        //             ),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   '$fee%',
                        //                   style: GoogleFonts.cairo(
                        //                     fontSize: 15.sp,
                        //                     fontWeight: FontWeight.w600,
                        //                     color: const Color(0xFF565656),
                        //                   ),
                        //                 ),
                        //                 SizedBox(width: 130.w),
                        //                 Text(
                        //                   AppTranslations.getText(
                        //                     context,
                        //                     'fees_label',
                        //                   ),
                        //                   style: GoogleFonts.cairo(
                        //                     fontSize: 16.sp,
                        //                     fontWeight: FontWeight.w600,
                        //                     color: const Color(0xFF000000),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           );
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 60.h),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
                        //       builder: (context, rateState) {
                        //         return BlocBuilder<
                        //           PaymentMethodsCubit,
                        //           PaymentMethodsState
                        //         >(
                        //           builder: (context, paymentState) {
                        //             double fee = 0;
                        //             String symbol = "";
                        //             if (paymentState is PaymentMethodsSuccess &&
                        //                 paymentState.selected != null) {
                        //               fee = paymentState.selected!.fee
                        //                   .toDouble();
                        //               symbol = paymentState.selected!.symbol;
                        //             }

                        //             // 2. استخراج حالة العملة (المبلغ المرسل ونوع العملة الرقمية)
                        //             final currencyState = context
                        //                 .watch<CurrencyCubit>()
                        //                 .state;
                        //             double amount = 0;
                        //             if (currencyState.amount.isNotEmpty) {
                        //               amount =
                        //                   double.tryParse(
                        //                     currencyState.amount,
                        //                   ) ??
                        //                   0;
                        //             }

                        //             double exchangeRate = 1.0;
                        //             if (rateState is ExchangeRatesSuccess) {
                        //               String currencyKey =
                        //                   (currencyState.currency ==
                        //                       CurrencyType.usdt)
                        //                   ? "USDT"
                        //                   : "USDC";

                        //               var rateData =
                        //                   rateState.data.rates[currencyKey];
                        //               if (rateData != null) {
                        //                 exchangeRate =
                        //                     double.tryParse(
                        //                       rateData.toString(),
                        //                     ) ??
                        //                     1.0;
                        //               }
                        //             }

                        //             final feeValue = amount * fee / 100;
                        //             double netAmount = amount - feeValue;
                        //             final finalResultText = symbol == "SYP"
                        //                 ? (netAmount * exchangeRate).toStringAsFixed(0)
                        //                 : netAmount.toStringAsFixed(2);

                        //             // WidgetsBinding.instance
                        //             //     .addPostFrameCallback((_) {
                        //             //       if (receiverController.text !=
                        //             //               finalResultText &&
                        //             //           !FocusScope.of(
                        //             //             context,
                        //             //           ).hasFocus) {
                        //             //         receiverController.text =
                        //             //             finalResultText;
                        //             //       }
                        //             //     });
                        //             // داخل الـ BlocBuilder اللي فيه الـ receiverController
                        //             WidgetsBinding.instance.addPostFrameCallback((
                        //               _,
                        //             ) {
                        //               // إذا المستخدم عم يكتب بخانة "المستلم"، مــــــــا بنلمس النص تبعه أبداً
                        //               // ولا بنخليه يعيد حساب الصافي من "المرسل" لأن المرسل هو اللي عم يلحقنا
                        //               if (FocusScope.of(context).hasFocus &&
                        //                   receiverController.text.isNotEmpty) {
                        //                 return;
                        //               }

                        //               // الحساب العادي فقط في حال كان التغيير جاي من برا (مثلاً غيرت العملة أو الطريقة)
                        //               final feeValue = amount * fee / 100;
                        //               double netAmount = amount - feeValue;

                        //               // جبر الكسور: لو الرقم 99.99999 بصير 100
                        //               String finalResultText = netAmount
                        //                   .toStringAsFixed(2);
                        //               // netAmount
                        //               //     .toStringAsFixed(2);
                        //               if (receiverController.text !=
                        //                   finalResultText) {
                        //                 receiverController.text =
                        //                     finalResultText;
                        //               }
                        //             });
                        //             return Trsletastkbl3(
                        //               text1: AppTranslations.getText(
                        //                 context,
                        //                 'receiver_gets',
                        //               ),
                        //               text2: symbol,
                        //               text3:
                        //                   "", // القيمة تظهر عبر الـ controller
                        //               isEditable: true,
                        //               controller: receiverController,
                        //               onChanged: (value) {
                        //                 // نمرر الـ fee والـ exchangeRate للدالة إذا كنت تحتاجها للحسبة العكسية
                        //                 onReceiverChanged(value, fee, context);
                        //               },
                        //             );
                        //           },
                        //         );
                        //       },
                        //     ),
                        //     // SizedBox(width: 6.w),
                        //     // BlocBuilder<
                        //     //   PaymentMethodsCubit,
                        //     //   PaymentMethodsState
                        //     // >(
                        //     //   builder: (context, paymentState) {
                        //     //     double fee = 0;
                        //     //     if (paymentState is PaymentMethodsSuccess &&
                        //     //         paymentState.selected != null) {
                        //     //       fee = paymentState.selected!.fee.toDouble();
                        //     //     }

                        //     //     final currencyState = context
                        //     //         .watch<CurrencyCubit>()
                        //     //         .state;
                        //     //     double amount = 0;

                        //     //     if (currencyState.amount.isNotEmpty) {
                        //     //       amount =
                        //     //           double.tryParse(currencyState.amount) ??
                        //     //           0;
                        //     //     }

                        //     //     final feeValue = amount * fee / 100;
                        //     //     final receiverAmount = amount - feeValue;

                        //     //     return Trsletastkbl3(
                        //     //       text1: AppTranslations.getText(
                        //     //         context,
                        //     //         'receiver_gets',
                        //     //       ),
                        //     //       text2:
                        //     //           paymentState is PaymentMethodsSuccess &&
                        //     //               paymentState.selected != null
                        //     //           ? paymentState.selected!.symbol
                        //     //           : "",
                        //     //       text3: "",

                        //     //       isEditable: true,
                        //     //       controller: receiverController,
                        //     //       onChanged: (value) {
                        //     //         onReceiverChanged(value, fee, context);
                        //     //       },
                        //     //     );
                        //     //   },
                        //     // ),
                        //     Image.asset(
                        //       AppImages.trsltstkbl1,
                        //       height: 15.h,
                        //       width: 15.w,
                        //     ),
                        //     BlocBuilder<CurrencyCubit, CurrencyState>(
                        //       builder: (context, state) {
                        //         final isUsdt =
                        //             state.currency == CurrencyType.usdt;
                        //         final amountToShow = state.amount.isEmpty
                        //             ? '0.00'
                        //             : state.amount;

                        //         return Trsletastkbl2(
                        //           text1: AppTranslations.getText(
                        //             context,
                        //             'you_send',
                        //           ),
                        //           text2: isUsdt ? 'USDT' : 'USDC',
                        //           text3: amountToShow,
                        //         );
                        //       },
                        //     ),
                        //   ],
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // --- خانة المرسل (الإجمالي) ---
                              BlocBuilder<CurrencyCubit, CurrencyState>(
                                // داخل الـ BlocBuilder الخاص بالـ CurrencyCubit
                                builder: (context, state) {
                                  return Trsletastkbl2(
                                    text1: AppTranslations.getText(
                                      context,
                                      'you_send',
                                    ),
                                    text2: SendCurrencyHelper.displayLabelForType(
                                      state.currency,
                                      isArabic: isArabic,
                                    ),
                                    text3: '',
                                    editable: true,
                                    amountController: amountController,
                                    onAmountChanged: (value) {
                                      context
                                          .read<CurrencyCubit>()
                                          .changeAmount(value);
                                      final paymentState = context
                                          .read<PaymentMethodsCubit>()
                                          .state;
                                      double fee = 0;
                                      if (paymentState
                                              is PaymentMethodsSuccess &&
                                          paymentState.selected != null) {
                                        fee = paymentState.selected!.fee
                                            .toDouble();
                                      }
                                      onSendChanged(value, fee);
                                    },
                                  );
                                },
                              ),
                              SizedBox(width: 12.w),
                              // الصورة في المنتصف
                              Image.asset(
                                AppImages.trsltstkbl1,
                                height: 15.h,
                                width: 15.w,
                              ),
                              SizedBox(width: 12.w),
                              // --- خانة المستلم (الصافي) ---
                              // BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
                              //   builder: (context, rateState) {
                              //     return BlocBuilder<
                              //       PaymentMethodsCubit,
                              //       PaymentMethodsState
                              //     >(
                              //       builder: (context, paymentState) {
                              //         double fee = 0;
                              //         String symbol = "";
                              //         if (paymentState is PaymentMethodsSuccess &&
                              //             paymentState.selected != null) {
                              //           fee = paymentState.selected!.fee
                              //               .toDouble();
                              //           symbol = paymentState.selected!.symbol;
                              //         }

                              //         final currencyState = context
                              //             .watch<CurrencyCubit>()
                              //             .state;
                              //         double amount =
                              //             double.tryParse(currencyState.amount) ??
                              //             0;

                              //         // الحسبة للصافي
                              //         double netAmount =
                              //             amount / (1 + (fee / 100));

                              //         // تعديل هنا: جعل النص دائماً رقم صحيح بدون فواصل لجميع العملات
                              //         String finalResultText = netAmount
                              //             .round()
                              //             .toString();

                              //         // تحديث التكست فيلد تلقائياً
                              //         WidgetsBinding.instance
                              //             .addPostFrameCallback((_) {
                              //               if (!FocusScope.of(
                              //                     context,
                              //                   ).hasFocus &&
                              //                   receiverController.text !=
                              //                       finalResultText) {
                              //                 receiverController.text =
                              //                     finalResultText;
                              //               }
                              //             });

                              //         return Trsletastkbl3(
                              //           text1: AppTranslations.getText(
                              //             context,
                              //             'receiver_gets',
                              //           ),
                              //           text2: symbol,
                              //           text3: "",
                              //           isEditable: true,
                              //           controller: receiverController,
                              //           onChanged: (value) => onReceiverChanged(
                              //             value,
                              //             fee,
                              //             context,
                              //           ),
                              //         );
                              //       },
                              //     );
                              //   },
                              // ),
                              // BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
                              //   builder: (context, rateState) {
                              //     return BlocBuilder<
                              //       PaymentMethodsCubit,
                              //       PaymentMethodsState
                              //     >(
                              //       builder: (context, paymentState) {
                              //         double fee = 0;
                              //         String symbol = "";

                              //         if (paymentState is PaymentMethodsSuccess &&
                              //             paymentState.selected != null) {
                              //           fee = paymentState.selected!.fee
                              //               .toDouble();
                              //           symbol = paymentState.selected!.symbol;
                              //         }

                              //         // قراءة حالة المبلغ الحالي
                              //         final currencyState = context
                              //             .watch<CurrencyCubit>()
                              //             .state;
                              //         double amount =
                              //             double.tryParse(currencyState.amount) ??
                              //             0;

                              //         // الحسبة للصافي
                              //         double netAmount =
                              //             amount / (1 + (fee / 100));

                              //         // التنسيق: نضمن هنا أن أي قيمة "صفرية" تظهر 0.00
                              //         // وأي قيمة حقيقية تظهر كرقم صحيح (round)
                              //         String finalResultText =
                              //             (amount <= 0 || netAmount <= 0)
                              //             ? "0.00"
                              //             : netAmount.round().toString();

                              //         // التحديث التلقائي للـ Controller
                              //         WidgetsBinding.instance.addPostFrameCallback((
                              //           _,
                              //         ) {
                              //           // إذا لم يكن المستخدم يكتب حالياً، والقيمة في الحقل تختلف عن النتيجة المحسوبة
                              //           if (!FocusScope.of(context).hasFocus &&
                              //               receiverController.text !=
                              //                   finalResultText) {
                              //             receiverController.text =
                              //                 finalResultText;
                              //           }
                              //         });

                              //         return Trsletastkbl3(
                              //           text1: AppTranslations.getText(
                              //             context,
                              //             'receiver_gets',
                              //           ),
                              //           text2: symbol,
                              //           text3:
                              //               "", // الحقل يدار بواسطة الـ controller
                              //           isEditable: true,
                              //           controller: receiverController,
                              //           onChanged: (value) => onReceiverChanged(
                              //             value,
                              //             fee,
                              //             context,
                              //           ),
                              //         );
                              //       },
                              //     );
                              //   },
                              // ),
                              BlocBuilder<
                                ExchangeRatesCubit,
                                ExchangeRatesState
                              >(
                                buildWhen: (previous, current) =>
                                    current is ExchangeRatesSuccess,
                                builder: (context, rateState) {
                                  return BlocBuilder<
                                    PaymentMethodsCubit,
                                    PaymentMethodsState
                                  >(
                                    builder: (context, paymentState) {
                                      double fee = 0;
                                      String symbol = "SYP";
                                      double currentRateValue = 1.0;

                                      // 1. جلب البيانات من الـ States
                                      // (region-scoped OR country-level
                                      // method - the latter used to be
                                      // ignored here, so a JOD wallet still
                                      // showed the SYP rate.)
                                      final resolvedMethod =
                                          resolvePaymentSelection(
                                            cityState: context
                                                .watch<CitiesCubit>()
                                                .state,
                                            areaState: context
                                                .watch<AreasCubit>()
                                                .state,
                                            paymentState: paymentState,
                                            countryPaymentState: context
                                                .watch<
                                                  CountryPaymentMethodsCubit
                                                >()
                                                .state,
                                          )?.method;
                                      if (resolvedMethod != null) {
                                        fee = resolvedMethod.fee.toDouble();
                                        symbol = resolvedMethod.symbol
                                            .toString()
                                            .trim()
                                            .toUpperCase();
                                      }

                                      final currencyCubit = context
                                          .watch<CurrencyCubit>();
                                      currentRateValue =
                                          _resolveRateForPayoutSymbol(
                                            rateState,
                                            currencyCubit.state.currency,
                                            symbol,
                                          );

                                      // 2. الحسبة الدقيقة
                                      double currentSendAmount =
                                          tryParseWesternAmount(
                                            currencyCubit.state.amount,
                                          ) ??
                                          0;
                                      double amountAfterFeeUSD =
                                          currentSendAmount * (1 - (fee / 100));

                                      String finalResultText = "";
                                      if (currentSendAmount > 0) {
                                        if (symbol != "USDT" &&
                                            symbol != "USDC") {
                                          finalResultText =
                                              (amountAfterFeeUSD *
                                                      currentRateValue)
                                                  .round()
                                                  .toString();
                                        } else {
                                          finalResultText = amountAfterFeeUSD
                                              .toStringAsFixed(2);
                                        }
                                      }

                                      // 3. 🔥 التحديث الذكي للـ Controller
                                      // السطر هاد بيخليك تقدر تكتب: "إذا الحقل مو مضغوط عليه حالياً، حدّث القيمة"
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            final hasFocus =
                                                FocusScope.of(
                                                      context,
                                                    ).focusedChild !=
                                                    null &&
                                                receiverController
                                                    .selection
                                                    .isValid;

                                            if (!hasFocus) {
                                              if (receiverController.text !=
                                                  finalResultText) {
                                                receiverController
                                                    .value = TextEditingValue(
                                                  text: finalResultText,
                                                  selection:
                                                      TextSelection.collapsed(
                                                        offset: finalResultText
                                                            .length,
                                                      ),
                                                );
                                              }
                                            }
                                          });

                                      // 4. عرض الـ Widget
                                      return Trsletastkbl3(
                                        text1: AppTranslations.getText(
                                          context,
                                          'receiver_gets',
                                        ),
                                        text2: SendCurrencyHelper.displayLabelForSymbol(
                                          symbol,
                                          isArabic: isArabic,
                                        ),
                                        text3: "",
                                        isEditable: true,
                                        controller: receiverController,
                                        onChanged: (value) {
                                          // تحديث الـ Cubit فوراً عند الكتابة يدوياً
                                          onReceiverChanged(
                                            value,
                                            fee,
                                            currentRateValue,
                                            symbol,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              // BlocListener<
                              //   ExchangeRatesCubit,
                              //   ExchangeRatesState
                              // >(
                              //   listenWhen: (previous, current) =>
                              //       current is ExchangeRatesUserBlocked,
                              //   listener: (context, state) {
                              //     if (state is ExchangeRatesUserBlocked) {
                              //       _rateTimer
                              //           ?.cancel(); // إيقاف التحديث التلقائي

                              //       showDialog(
                              //         context: context,
                              //         barrierDismissible: false,
                              //         builder: (_) => AlertDialog(
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(
                              //               15.r,
                              //             ),
                              //           ),
                              //           title: Icon(
                              //             Icons.error_outline,
                              //             color: Colors.red,
                              //             size: 40.sp,
                              //           ),
                              //           content: Text(
                              //             state.message,
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //               fontSize: 16.sp,
                              //               fontWeight: FontWeight.bold,
                              //             ),
                              //           ),
                              //           actions: [
                              //             TextButton(
                              //               style: TextButton.styleFrom(
                              //                 backgroundColor: Colors.black,
                              //                 minimumSize: Size(
                              //                   double.infinity,
                              //                   45.h,
                              //                 ),
                              //               ),
                              //               onPressed: () {
                              //                 Functions().logout();
                              //                 Navigator.pushAndRemoveUntil(
                              //                   context,
                              //                   MaterialPageRoute(
                              //                     builder: (_) =>
                              //                         const Loginview(),
                              //                   ),
                              //                   (route) => false,
                              //                 );
                              //               },
                              //               child: Text(
                              //                 "تأكيد",
                              //                 style: TextStyle(
                              //                   color: Color(0xFFE6C07A),
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       );
                              //     }
                              //   },
                              //   child:
                              //       BlocBuilder<
                              //         ExchangeRatesCubit,
                              //         ExchangeRatesState
                              //       >(
                              //         builder: (context, rateState) {
                              //           return BlocBuilder<
                              //             PaymentMethodsCubit,
                              //             PaymentMethodsState
                              //           >(
                              //             builder: (context, paymentState) {
                              //               double fee = 0;
                              //               String symbol = "";

                              //               if (paymentState
                              //                       is PaymentMethodsSuccess &&
                              //                   paymentState.selected != null) {
                              //                 fee = paymentState.selected!.fee
                              //                     .toDouble();
                              //                 symbol =
                              //                     paymentState.selected!.symbol;
                              //               }

                              //               final currencyState = context
                              //                   .watch<CurrencyCubit>()
                              //                   .state;
                              //               double amount =
                              //                   double.tryParse(
                              //                     currencyState.amount,
                              //                   ) ??
                              //                   0;

                              //               // الحسبة (الصافي)
                              //               double netAmount =
                              //                   amount / (1 + (fee / 100));

                              //               String finalResultText =
                              //                   (amount <= 0 || netAmount <= 0)
                              //                   ? "0.00"
                              //                   : netAmount.round().toString();

                              //               WidgetsBinding.instance
                              //                   .addPostFrameCallback((_) {
                              //                     if (!FocusScope.of(
                              //                           context,
                              //                         ).hasFocus &&
                              //                         receiverController.text !=
                              //                             finalResultText) {
                              //                       receiverController.text =
                              //                           finalResultText;
                              //                     }
                              //                   });

                              //               return Trsletastkbl3(
                              //                 text1: AppTranslations.getText(
                              //                   context,
                              //                   'receiver_gets',
                              //                 ),
                              //                 text2: symbol,
                              //                 text3: "",
                              //                 isEditable: true,
                              //                 controller: receiverController,
                              //                 onChanged: (value) =>
                              //                     onReceiverChanged(
                              //                       value,
                              //                       fee,
                              //                       context,
                              //                     ),
                              //               );
                              //             },
                              //           );
                              //         },
                              //       ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _buildRateFeeSummaryTable(context, isArabic),
                        SizedBox(height: 24.h),
                        GestureDetector(
                          onTap: () {
                            if (widget.isAuthenticated) {
                              _handleAuthenticatedSend(context);
                              return;
                            }
                            // if (!_isFormValid(context)) {
                            //   setState(() {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         backgroundColor:
                            //             Colors.transparent, // مهم جدًا
                            //         elevation: 0, // مهم جدًا
                            //         behavior: SnackBarBehavior.floating, // مهم
                            //         margin: EdgeInsets.zero, // إلغاء الهوامش
                            //         padding: EdgeInsets.zero,

                            //         content: CustomSnackBar(
                            //           backgroundColor: Color(0xFF6B1F2A),
                            //           message: AppTranslations.getTextStatic(
                            //             context,
                            //             "Please enter all fields",
                            //           ),
                            //           imagePath: AppImages.eerorrimage,
                            //         ),
                            //         // Text(state.message)
                            //       ),
                            //     );
                            //   });
                            //   return;
                            // }
                            // if (!_isenoughtmony(context)) {
                            //   setState(() {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         backgroundColor:
                            //             Colors.transparent, // مهم جدًا
                            //         elevation: 0, // مهم جدًا
                            //         behavior: SnackBarBehavior.floating, // مهم
                            //         margin: EdgeInsets.zero, // إلغاء الهوامش
                            //         padding: EdgeInsets.zero,

                            //         content: CustomSnackBar(
                            //           backgroundColor: Color(0xFF6B1F2A),
                            //           message: AppTranslations.getTextStatic(
                            //             context,
                            //             "amount_must_be_greater_than_15",
                            //           ),
                            //           imagePath: AppImages.eerorrimage,
                            //         ),
                            //         // Text(state.message)
                            //       ),
                            //     );
                            //   });
                            //   return;
                            // }
                            // final currencyState = context
                            //     .read<CurrencyCubit>()
                            //     .state;
                            // final paymentState = context
                            //     .read<PaymentMethodsCubit>()
                            //     .state;

                            // // تحويل المبلغ المدخل لرقم
                            // double enteredAmount =
                            //     double.tryParse(currencyState.amount) ?? 0;

                            // 2. فحص الحد الأدنى العام (15)
                            // if (enteredAmount < 15) {
                            //   _showError(
                            //     context,
                            //     "amount_must_be_greater_than_15",
                            //   );
                            //   return;
                            // }

                            // 3. فحص حدود بوابة الدفع المختارة (Min & Max) من الـ API
                            // if (paymentState is PaymentMethodsSuccess &&
                            //     paymentState.selected != null) {
                            //   double minLimit = paymentState.selected!.minAmount
                            //       .toDouble();
                            //   double maxLimit = paymentState.selected!.maxAmount
                            //       .toDouble();

                            // if (enteredAmount < minLimit) {
                            //   // يمكنك تمرير رسالة ديناميكية أو ثابتة
                            //   _showError(
                            //     context,
                            //     "The amount is less than the minimum for this method ($minLimit)",
                            //   );
                            //   return;
                            // }

                            // if (enteredAmount > maxLimit) {
                            //   _showError(
                            //     context,
                            //     "The amount exceeds the maximum for this method ($maxLimit)",
                            //   );
                            //   return;
                            // }
                            // فحص الحد الأدنى
                            //   if (paymentState is PaymentMethodsSuccess &&
                            //       paymentState.selected != null) {
                            //     double minLimit = paymentState
                            //         .selected!
                            //         .minAmount
                            //         .toDouble();
                            //     double maxLimit = paymentState
                            //         .selected!
                            //         .maxAmount
                            //         .toDouble();

                            //     // فحص الحد الأدنى
                            //     if (enteredAmount < minLimit) {
                            //       String
                            //       translatedText = AppTranslations.getTextStatic(
                            //         context,
                            //         "The amount is less than the minimum for this method",
                            //       );

                            //       // دمج النص مع الرقم بشكل مباشر لضمان الظهور
                            //       String finalMsg =
                            //           "$translatedText ($minLimit)";

                            //       _showError(context, finalMsg);
                            //       return;
                            //     }

                            //     // فحص الحد الأقصى
                            //     if (enteredAmount > maxLimit) {
                            //       String
                            //       translatedText = AppTranslations.getTextStatic(
                            //         context,
                            //         "The amount exceeds the maximum for this method",
                            //       );

                            //       // دمج النص مع الرقم بشكل مباشر
                            //       String finalMsg =
                            //           "$translatedText ($maxLimit)";

                            //       _showError(context, finalMsg);
                            //       return;
                            //     }
                            //   }
                            // }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Loginview(),
                              ),
                            );
                          },
                          child: Container(
                            height: 60.h,
                            width: 245.w,
                            decoration: branding.buildButtonDecoration(
                              radius: 30,
                            ),
                            child: Center(
                              child: Text(
                                AppTranslations.getText(
                                  context,
                                  'send_transfer_cta',
                                ),
                                style: GoogleFonts.cairo(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: homeButtonText,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.isAuthenticated) ...[
                          SizedBox(height: 40.h),
                          BlocBuilder<Userinfogcubit, UserinfoState>(
                            builder: (context, userState) {
                              if (userState is! UserinfoSuccessState) {
                                return const SizedBox.shrink();
                              }
                              final kycState = KycStatusHelper.resolve(
                                userState.user,
                              );
                              if (kycState == 'approved') {
                                return const SizedBox.shrink();
                              }
                              return _buildKycAlertStrip(context, kycState);
                            },
                          ),
                          SizedBox(height: 100.h),
                        ],
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
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

  void _handleAuthenticatedSend(BuildContext context) {
    if (!_isFormValid(context)) {
      _showError(
        context,
        AppTranslations.getTextStatic(context, 'Please enter all fields'),
      );
      return;
    }

    final userState = context.read<Userinfogcubit>().state;
    if (userState is UserinfoSuccessState &&
        !KycStatusHelper.canTransfer(userState.user)) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      _showKycRequiredDialog(
        context,
        KycStatusHelper.gateMessage(userState.user, isArabic),
        canSubmit: KycStatusHelper.canSubmitDocuments(userState.user),
      );
      return;
    }

    final currencyState = context.read<CurrencyCubit>().state;
    final cityState = context.read<CitiesCubit>().state;
    final areaState = context.read<AreasCubit>().state;
    final payState = context.read<PaymentMethodsCubit>().state;
    final countryPaymentState = context
        .read<CountryPaymentMethodsCubit>()
        .state;
    final resolvedSelection = resolvePaymentSelection(
      cityState: cityState,
      areaState: areaState,
      paymentState: payState,
      countryPaymentState: countryPaymentState,
    );
    final enteredAmount = tryParseWesternAmount(currencyState.amount) ?? 0;

    if (resolvedSelection != null) {
      final sel = resolvedSelection.method;
      if (!sel.isActivated) {
        _showError(
          context,
          AppTranslations.getTextStatic(context, 'payment_method_not_active'),
        );
        return;
      }
      final min = sel.minAmount.toDouble();
      final max = sel.maxAmount.toDouble();
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      if (enteredAmount < min) {
        final t = AppTranslations.getTextStatic(
          context,
          'The amount is less than the minimum for this method',
        );
        _showError(context, isAr ? '$t (\$$min)' : '$t ($min)\$');
        return;
      }
      if (enteredAmount > max) {
        final t = AppTranslations.getTextStatic(
          context,
          'The amount exceeds the maximum for this method',
        );
        _showError(context, isAr ? '$t (\$$max)' : '$t ($max\$)');
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Senderinformation()),
    );
  }

  void _showKycRequiredDialog(
    BuildContext context,
    String message, {
    bool canSubmit = true,
  }) {
    final branding = appBrandingNotifier.value;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
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
          message,
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
          // Pending / blocked users get the explanation only - an upload
          // button for them led straight to a server rejection.
          if (canSubmit)
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
  }

  void _showError(BuildContext context, String message) {
    final branding = appBrandingNotifier.value;
    final snackColor = branding.buttonBg;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content: CustomSnackBar(
          backgroundColor: snackColor,
          message:
              message, // نعرض الرسالة كما هي لأننا سنترجمها قبل إرسالها لهون
          imagePath: AppImages.eerorrimage,
        ),
      ),
    );
  }

  bool _isFormValid(BuildContext context) {
    final countryState = context.read<CountriesCubit>().state;
    final cityState = context.read<CitiesCubit>().state;
    final areaState = context.read<AreasCubit>().state;
    final paymentState = context.read<PaymentMethodsCubit>().state;
    final countryPaymentState = context
        .read<CountryPaymentMethodsCubit>()
        .state;
    final currencyState = context.read<CurrencyCubit>().state;

    if (countryState is! CountriesSuccess) return false;

    // مقبول إما عبر مسار المدينة/المنطقة الكامل، أو عبر طريقة دفع مربوطة
    // بالبلد مباشرة (بدون مدينة/منطقة) - انظر resolvePaymentSelection.
    final resolvedSelection = resolvePaymentSelection(
      cityState: cityState,
      areaState: areaState,
      paymentState: paymentState,
      countryPaymentState: countryPaymentState,
    );
    if (resolvedSelection == null) return false;

    if (currencyState.amount.isEmpty) return false;

    return true;
  }

  Widget _buildKycAlertStrip(BuildContext context, String kycState) {
    final isPending = kycState == 'pending';
    final isBlocked = kycState == 'blocked';
    final alertColor = isPending ? Colors.orange.shade800 : Colors.red;
    final label = AppTranslations.getText(
      context,
      isPending
          ? 'verification_request_under_review'
          : isBlocked
              ? 'identity_verification_blocked'
              : 'identity_verification',
    );
    final icon = isPending
        ? Icons.hourglass_top_rounded
        : isBlocked
            ? Icons.block_rounded
            : Icons.warning_amber_rounded;

    final content = Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: alertColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: alertColor, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: alertColor,
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: (isPending || isBlocked)
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => idintyview()),
                  );
                },
                borderRadius: BorderRadius.circular(10.r),
                child: content,
              ),
            ),
    );
  }
}
