import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/localization/lang_cubit.dart';
import 'package:usdt/constans/localization/langhelper.dart';
import 'package:usdt/constans/token.dart';
import 'package:usdt/featue/auth/login/login_screen_view.dart';
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
import 'package:usdt/featue/auth/welcomyou/widjt/trkalthoel.dart';
import 'package:usdt/featue/auth/welcomyou/widjt/trsltstakbl.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit_mark.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/notifation/notifacation_view.dart';
import 'package:usdt/featue/sender_information/sender_information_screen_view.dart';
import 'package:usdt/featue/transaction_historu/data/cubit/cubit.dart';
import 'package:usdt/featue/transaction_historu/data/cubit/cubit_state.dart';
import 'package:usdt/featue/transaction_historu/data/model.dart';

class Welcomyoufirstscreen extends StatefulWidget {
  const Welcomyoufirstscreen({super.key});

  @override
  State<Welcomyoufirstscreen> createState() => _WelcomyoufirstscreenState();
}

bool isDropdownOpen = false;

class _WelcomyoufirstscreenState extends State<Welcomyoufirstscreen> {
  @override
  void initState() {
    super.initState();

    // context.read<NotificationsCubit>().fetchNotifications();
    context.read<ExchangeRatesCubit>().fetchRates(); // طلب الأسعار
    amountController = TextEditingController(
      text: context.read<CurrencyCubit>().state.amount,
    );

    _rateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        context.read<ExchangeRatesCubit>().fetchRates();
      }
    });
  }

  OverlayEntry? _countriesOverlay;
  final LayerLink _layerLink = LayerLink();
  // OverlayEntry? _countriesOverlay;
  OverlayEntry? _citiesOverlay;
  //OverlayEntry? _citiesOverlay;
  final LayerLink _cityLayerLink = LayerLink();

  final LayerLink _countryLayerLink = LayerLink();
  //final LayerLink _cityLayerLink = LayerLink();
  OverlayEntry? _areasOverlay;
  final LayerLink _areaLayerLink = LayerLink();
  void _removeAreasOverlay() {
    _areasOverlay?.remove();
    _areasOverlay = null;
  }

  void _closeAllOverlays() {
    _countriesOverlay?.remove();
    _countriesOverlay = null;

    _citiesOverlay?.remove();
    _citiesOverlay = null;

    _areasOverlay?.remove();
    _areasOverlay = null;
  }

  void _openAreasDropdown(BuildContext context, AreasSuccess state) {
    _removeAreasOverlay();
    _closeAllOverlays();
    final overlay = Overlay.of(context);

    _areasOverlay = OverlayEntry(
      builder: (_) => Positioned(
        width: 170.w,
        child: CompositedTransformFollower(
          link: _areaLayerLink,
          offset: Localizations.localeOf(context).languageCode == 'ar'
              ? Offset(-10, 55.h)
              : Offset(-3, 55.h),
          // offset: Localizations.localeOf(context).languageCode == 'ar'
          //     ? Offset(-10, 55.h)
          //     : Offset(-3, 55.h),
          showWhenUnlinked: false,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Directionality(
              textDirection:
                  Localizations.localeOf(context).languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: state.areas.map((area) {
                  return ListTile(
                    title: Text(
                      LangHelper.isArabic(context) ? area.nameAr : area.nameEn,
                      style: GoogleFonts.cairo(),
                    ),
                    onTap: () {
                      context.read<AreasCubit>().selectArea(area);
                      context.read<PaymentMethodsCubit>().fetchMethods(area.id);
                      _removeAreasOverlay();
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_areasOverlay!);
  }

  void _removeCitiesOverlay() {
    _citiesOverlay?.remove();
    _citiesOverlay = null;
  }

  void _openCitiesDropdown(BuildContext context, CitiesSuccess state) {
    _removeCitiesOverlay();
    _closeAllOverlays();
    final overlay = Overlay.of(context);

    _citiesOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 170.w,
        child: CompositedTransformFollower(
          link: _cityLayerLink,
          showWhenUnlinked: false,
          offset: Localizations.localeOf(context).languageCode == 'ar'
              ? Offset(-10, 55.h)
              : Offset(-5, 55.h),
          // offset: Localizations.localeOf(context).languageCode == 'ar'
          //     ? Offset(-10, 55.h)
          //     : Offset(-5, 55.h),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Directionality(
              textDirection:
                  Localizations.localeOf(context).languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: state.cities.map((city) {
                  return ListTile(
                    title: Text(
                      LangHelper.isArabic(context) ? city.nameAr : city.nameEn,
                      style: GoogleFonts.cairo(),
                    ),
                    onTap: () {
                      context.read<CitiesCubit>().selectCity(city);
                      context.read<AreasCubit>().reset();

                      _removeCitiesOverlay();
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_citiesOverlay!);
  }

  // void _showCountriesDropdown(BuildContext context, CountriesSuccess state) {
  //   _countriesOverlay?.remove();
  //   _countriesOverlay = null;

  //   final overlay = Overlay.of(context);

  //   _countriesOverlay = OverlayEntry(
  //     builder: (context) {
  //       return Positioned(
  //         width: 170.w,
  //         child: CompositedTransformFollower(
  //           link: _layerLink,
  //           offset: Localizations.localeOf(context).languageCode == 'ar'
  //               ? Offset(-20, 30.h)
  //               : Offset(0, 55.h), // ⬅️ ينزل تحت البوكس
  //           showWhenUnlinked: false,
  //           child: Material(
  //             elevation: 6,
  //             borderRadius: BorderRadius.circular(8),
  //             child: Directionality(
  //               textDirection: TextDirection.ltr,
  //               child: ListView(
  //                 padding: EdgeInsets.zero,
  //                 shrinkWrap: true,
  //                 children: state.countries.map((c) {
  //                   return ListTile(
  //                     dense: true,
  //                     leading: c.code == 'SY'
  //                         ? Image.asset(
  //                             'asset/image 3.png',
  //                             width: 24,
  //                             height: 24,
  //                           )
  //                         : Text(
  //                             Country.parse(c.code).flagEmoji,
  //                             style: const TextStyle(fontSize: 20),
  //                           ),

  //                     title: Text(
  //                       Country.parse(c.code).name,
  //                       style: GoogleFonts.cairo(fontSize: 14),
  //                     ),
  //                     onTap: () {
  //                       context.read<CountriesCubit>().selectCountry(c);
  //                       context.read<AreasCubit>().reset();
  //                       context.read<PaymentMethodsCubit>().reset();
  //                       _countriesOverlay?.remove();
  //                       _countriesOverlay = null;
  //                     },
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   overlay.insert(_countriesOverlay!);
  // }
  void _showCountriesDropdown(BuildContext context, CountriesSuccess state) {
    _countriesOverlay?.remove();
    _countriesOverlay = null;
    _closeAllOverlays();
    final overlay = Overlay.of(context);
    final branding = appBrandingNotifier.value;

    _countriesOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 170.w,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: Localizations.localeOf(context).languageCode == 'ar'
                ? Offset(-20, 55.h)
                : Offset(0, 55.h),
            showWhenUnlinked: false,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(8),
              color: branding.cardBg,
              child: Container(
                constraints: BoxConstraints(maxHeight: 250.h),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: state.countries.map((c) {
                    // جلب بيانات الدولة
                    final countryData = Country.tryParse(c.code);

                    // الطريقة المضمونة للترجمة العربية من داخل البكج
                    String countryName =
                        CountryLocalizations.of(
                          context,
                        )?.countryName(countryCode: c.code) ??
                        (countryData?.name ?? c.code);

                    return ListTile(
                      dense: true,
                      leading: c.code == 'SY'
                          ? Image.asset(
                              'asset/syrianewsyria.png',
                              width: 25,
                              height: 45,
                            )
                          : Text(
                              countryData?.flagEmoji ?? '🏳️',
                              style: const TextStyle(fontSize: 20),
                            ),
                      title: Text(
                        countryName,
                        style: GoogleFonts.cairo(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        context.read<CountriesCubit>().selectCountry(c);
                        context.read<CitiesCubit>().reset();
                        _countriesOverlay?.remove();
                        _countriesOverlay = null;
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_countriesOverlay!);
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
  late TextEditingController amountController = TextEditingController();
  late TextEditingController receiverController = TextEditingController();
  bool _isUpdating = false;

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
  void onSendChanged(String value, double fee) {
    if (_isUpdating) return;
    _isUpdating = true;

    double amount = double.tryParse(value.replaceAll(',', '')) ?? 0;

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

    double receiverAmount = double.tryParse(value.replaceAll(',', '')) ?? 0;

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
    amountController.dispose();
    receiverController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;
  Country? _selectedCountry;
  @override
  Widget build(BuildContext context) {
    void _closeAllDropdowns() {
      _countriesOverlay?.remove();
      _countriesOverlay = null;

      _citiesOverlay?.remove();
      _citiesOverlay = null;

      _areasOverlay?.remove();
      _areasOverlay = null;
    }

    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;
    final homeScreenBg = branding.screenBg;
    final homePrimaryText = branding.primaryText;
    final homeSecondaryText = branding.secondaryText;
    final homeBorderColor = branding.cardBorder;
    final homeButtonText = branding.buttonText;
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
    Widget _countryBox({
      required String title,
      required Widget flag,
      required VoidCallback onTap, // تم تغيير الاسم ليعبر عن الصندوق كاملاً
      String? countryCode,
    }) {
      return CustomPaint(
        painter: _CustomBorderPainter(
          leftGap: isArabic ? 0 : 62.w,
          rightGap: isArabic ? 62.w : 0,
        ),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque, // يضمن التقاط النقر في الفراغات
          child: Container(
            width: 170.w,
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // أيقونة السهم
                Image.asset(AppImages.trkyicon, height: 20.h, width: 17.h),
                // العنوان (اسم الدولة)
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: homeSecondaryText,
                    ),
                  ),
                ),
                // العلم (يدعم العلم المخصص لسوريا)
                SizedBox(
                  width: 25.w,
                  height: 25.h,
                  child: countryCode == 'SY'
                      ? Image.asset(
                          "asset/syrianewsyria.png",
                          fit: BoxFit.contain,
                        )
                      : flag,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          //  resizeToAvoidBottomInset: true,
          backgroundColor: homeScreenBg,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _closeAllDropdowns();
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 130.h),
                    decoration: BoxDecoration(color: homeScreenBg),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // الخلفية
                            Container(
                              height: 230.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: branding.buildHeaderGradient(),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              right: isArabic ? null : 10.w,
                              left: isArabic ? 10.w : null,
                              child: Image.asset(
                                'asset/4cb89412e17e9731c5a074ee767cc8afb7213109.png',
                                height: 25.h,
                                width: 25.w,
                                // height: 200,
                                // width: 200,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: isArabic ? 165.w : 130.w,

                              // left: isArabic ? 0 : 120.w,
                              child: Text(
                                AppTranslations.getText(
                                  context,
                                  "welcome_title",
                                ),
                                style: GoogleFonts.cairo(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: branding.textColorValue,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              right: isArabic ? 10.w : null,
                              left: isArabic ? null : 10.w,
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Loginview(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<LanguageCubit>()
                                            .toggleLanguage();
                                      },
                                      child: Image.asset(
                                        'asset/language.png',
                                        color: homePrimaryText,
                                        height: 25.h,
                                        width: 25.w,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Image.asset(
                                      AppImages.notifaction,
                                      height: 25.h,
                                      width: 25.w,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // notfactionicon(),
                            // Positioned(
                            //   top: 10.h,
                            //   right: isArabic ? 10.w : null,
                            //   left: isArabic ? null : 10.w,
                            //   child: GestureDetector(
                            //     onTap: () async {
                            //       context
                            //           .read<MarkAllReadCubit>()
                            //           .markAllRead();

                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => const Notifation(),
                            //         ),
                            //       );
                            //     },
                            //     child:
                            //         BlocBuilder<
                            //           NotificationsCubit,
                            //           NotificationsState
                            //         >(
                            //           builder: (context, state) {
                            //             int unreadCount = 0;

                            //             if (state is NotificationsSuccess) {
                            //               unreadCount = state.unreadCount;
                            //             }

                            //             return Stack(
                            //               clipBehavior: Clip.none,
                            //               children: [
                            //                 Image.asset(
                            //                   AppImages.notifaction,
                            //                   height: 25.h,
                            //                   width: 25.w,
                            //                 ),

                            //                 if (unreadCount > 0)
                            //                   Positioned(
                            //                     top: -2,
                            //                     right: 1,
                            //                     child: Container(
                            //                       width: 8,
                            //                       height: 8,
                            //                       decoration:
                            //                           const BoxDecoration(
                            //                             color: Color.fromARGB(
                            //                               255,
                            //                               185,
                            //                               27,
                            //                               16,
                            //                             ),
                            //                             shape: BoxShape.circle,
                            //                           ),
                            //                     ),
                            //                   ),
                            //               ],
                            //             );
                            //           },
                            //         ),
                            //   ),
                            // ),

                            // send_amount_label
                            Positioned(
                              top: 66.h,
                              right: isArabic ? 193.w : null,
                              left: isArabic ? null : 193.w,
                              child: Text(
                                AppTranslations.getText(
                                  context,
                                  "send_amount_label",
                                ),
                                style: GoogleFonts.cairo(
                                  fontSize: isArabic ? 11.sp : 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: homeSecondaryText,
                                ),
                              ),
                            ),

                            // send_to
                            Positioned(
                              top: 65.h,
                              right: isArabic ? 25.w : null,
                              left: isArabic ? null : 25.w,
                              child: Text(
                                AppTranslations.getText(context, "send_to"),
                                style: GoogleFonts.cairo(
                                  fontSize: isArabic ? 11.sp : 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: homeSecondaryText,
                                ),
                              ),
                            ),

                            // Positioned(
                            //   top: 60.h,
                            //   right: isArabic ? 325.w : null,
                            //   left: isArabic ? null : 325.w,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       context
                            //           .read<CurrencyCubit>()
                            //           .toggleCurrency();
                            //     },
                            //     child: Image.asset(
                            //       AppImages.cercl,
                            //       height: 25.h,
                            //       width: 25.w,
                            //     ),
                            //   ),
                            // ),
                            // Positioned(
                            //   top: 60.h,
                            //   right: isArabic ? 325.w : null,
                            //   left: isArabic ? null : 325.w,
                            //   child: GestureDetector(
                            //     onTapDown: (details) {
                            //       // بجيب مكان الضغطة عشان يطلع المنيو عندها بالضبط
                            //       final position = details.globalPosition;

                            //       showMenu<CurrencyType>(
                            //         context: context,
                            //         position: RelativeRect.fromLTRB(
                            //           isArabic ? 0 : 100,
                            //           120,
                            //           isArabic ? 10 : 0,
                            //           10,
                            //         ),
                            //         items: [
                            //           PopupMenuItem(
                            //             value: CurrencyType.usdt,
                            //             child: isArabic
                            //                 ? Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.end,
                            //                     children: [
                            //                       Text(
                            //                         "USDT",
                            //                         style: GoogleFonts.cairo(),
                            //                       ),
                            //                       Image.asset(
                            //                         AppImages.usdc,
                            //                         height: 15.h,
                            //                         width: 15.w,
                            //                       ),
                            //                     ],
                            //                   )
                            //                 : Row(
                            //                     children: [
                            //                       Image.asset(
                            //                         AppImages.usdc,
                            //                         height: 15.h,
                            //                         width: 15.w,
                            //                       ),

                            //                       SizedBox(width: 5.w),
                            //                       Text(
                            //                         "USDT",
                            //                         style: GoogleFonts.cairo(),
                            //                       ),
                            //                     ],
                            //                   ),
                            //           ),
                            //           PopupMenuItem(
                            //             value: CurrencyType.usdc,
                            //             child: isArabic
                            //                 ? Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.end,
                            //                     children: [
                            //                       Text(
                            //                         "USDC",
                            //                         style: GoogleFonts.cairo(),
                            //                       ),
                            //                       Image.asset(
                            //                         AppImages.usdt,
                            //                         height: 15.h,
                            //                         width: 15.w,
                            //                       ),
                            //                     ],
                            //                   )
                            //                 : Row(
                            //                     children: [
                            //                       Image.asset(
                            //                         AppImages.usdt,
                            //                         height: 15.h,
                            //                         width: 15.w,
                            //                       ),
                            //                       SizedBox(width: 5.w),
                            //                       Text(
                            //                         "USDC",
                            //                         style: GoogleFonts.cairo(),
                            //                       ),
                            //                     ],
                            //                   ),
                            //           ),
                            //         ],
                            //       ).then((value) {
                            //         if (value != null) {
                            //           context.read<CurrencyCubit>().setCurrency(
                            //             value,
                            //           );
                            //         }
                            //       });
                            //     },
                            //     child: Image.asset(
                            //       AppImages.cercl,
                            //       height: 25.h,
                            //       width: 25.w,
                            //     ),
                            //   ),
                            // ),
                            Positioned(
                              top: 60.h,
                              right: isArabic ? 325.w : null,
                              left: isArabic ? null : 325.w,
                              child: BlocBuilder<CurrencyCubit, CurrencyState>(
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () {
                                      // هزة خفيفة للموبايل عند الضغط (تعطي شعور فخم)
                                      HapticFeedback.mediumImpact();
                                      context
                                          .read<CurrencyCubit>()
                                          .toggleCurrency();
                                    },
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      // تأثير "القلب" أو التلاشي عند التبديل
                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            return ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            );
                                          },
                                      child: Image.asset(
                                        // الصورة بتتبدل حسب حالة الكيوبيت
                                        state.currency == CurrencyType.usdt
                                            ? AppImages.usdt
                                            : AppImages.usdc,
                                        // بنعطيه Key فريد عشان الـ AnimatedSwitcher يعرف إنه الصورة تغيرت فيعمل أنيميشن
                                        key: ValueKey(state.currency),
                                        height: 25.h,
                                        width: 25.w,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 0.h,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  SizedBox(height: 76.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        BlocBuilder<
                                          CurrencyCubit,
                                          CurrencyState
                                        >(
                                          builder: (context, state) {
                                            final isUsdt =
                                                state.currency ==
                                                CurrencyType.usdt;

                                            return CustomPaint(
                                              painter: _CustomBorderPainter(
                                                leftGap: isArabic
                                                    ? 40.w
                                                    : 108.w,
                                                rightGap: isArabic
                                                    ? 115.w
                                                    : 40.w,
                                              ),
                                              child: Container(
                                                width: 170.w,
                                                height: 45.h,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 2.w,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        isUsdt
                                                            ? AppImages.usdc
                                                            : AppImages.usdt,
                                                        height: 24.h,
                                                        width: 24.h,
                                                      ),

                                                      SizedBox(width: 8.w),

                                                      Text(
                                                        isUsdt
                                                            ? 'USDT'
                                                            : 'USDC',
                                                        style:
                                                            GoogleFonts.cairo(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  homeSecondaryText,
                                                            ),
                                                      ),

                                                      SizedBox(width: 10.w),

                                                      Expanded(
                                                        child: TextField(
                                                          controller:
                                                              amountController,
                                                          keyboardType:
                                                              const TextInputType.numberWithOptions(
                                                                decimal: true,
                                                              ),
                                                          // onChanged: (value) {
                                                          //   context
                                                          //       .read<
                                                          //         CurrencyCubit
                                                          //       >()
                                                          //       .changeAmount(
                                                          //         value,
                                                          //       );
                                                          // },
                                                          onChanged: (value) {
                                                            context
                                                                .read<
                                                                  CurrencyCubit
                                                                >()
                                                                .changeAmount(
                                                                  value,
                                                                );

                                                            final paymentState =
                                                                context
                                                                    .read<
                                                                      PaymentMethodsCubit
                                                                    >()
                                                                    .state;
                                                            double fee = 0;

                                                            if (paymentState
                                                                    is PaymentMethodsSuccess &&
                                                                paymentState
                                                                        .selected !=
                                                                    null) {
                                                              fee = paymentState
                                                                  .selected!
                                                                  .fee
                                                                  .toDouble();
                                                            }

                                                            onSendChanged(
                                                              value,
                                                              fee,
                                                            );
                                                          },

                                                          decoration:
                                                              const InputDecoration(
                                                                hintText:
                                                                    '0.00',
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                isDense: true,
                                                              ),
                                                          style:
                                                              GoogleFonts.cairo(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    homeSecondaryText,
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

                                        // CompositedTransformTarget(
                                        //   link: _layerLink,
                                        //   child: BlocBuilder<CountriesCubit, CountriesState>(
                                        //     builder: (context, state) {
                                        //       if (state is CountriesInitial) {
                                        //         return _countryBox(
                                        //           title:
                                        //               AppTranslations.getText(
                                        //                 context,
                                        //                 'Choose country',
                                        //               ),
                                        //           flag: Text(
                                        //             ' ',
                                        //             style: TextStyle(
                                        //               fontSize: 20.sp,
                                        //             ),
                                        //           ),

                                        //           onArrowTap: () async {
                                        //             final cubit = context
                                        //                 .read<CountriesCubit>();

                                        //             await cubit
                                        //                 .fetchCountries();

                                        //             final state = cubit.state;
                                        //             if (state
                                        //                 is CountriesSuccess) {
                                        //               _showCountriesDropdown(
                                        //                 context,
                                        //                 state,
                                        //               );
                                        //             }

                                        //             context
                                        //                 .read<CitiesCubit>()
                                        //                 .reset();
                                        //           },
                                        //         );
                                        //       }

                                        //       if (state is CountriesLoading) {
                                        //         return CustomPaint(
                                        //           painter: _CustomBorderPainter(
                                        //             leftGap: isArabic
                                        //                 ? 0
                                        //                 : 70.w,
                                        //             rightGap: isArabic
                                        //                 ? 70.w
                                        //                 : 0.w,
                                        //           ),
                                        //           child: Container(
                                        //             width: 160.w,
                                        //             height: 45.h,
                                        //             padding:
                                        //                 EdgeInsets.symmetric(
                                        //                   horizontal: 8.w,
                                        //                 ),
                                        //             child: Center(
                                        //               child:
                                        //                   CircularProgressIndicator(
                                        //                     padding:
                                        //                         EdgeInsets.all(
                                        //                           5,
                                        //                         ),
                                        //                     color: const Color(
                                        //                       0xFFB9A779,
                                        //                     ),
                                        //                   ),
                                        //             ),
                                        //           ),
                                        //         );
                                        //       }

                                        //       if (state is CountriesFailure) {
                                        //         return Text(state.error);
                                        //       }

                                        //       if (state is CountriesSuccess) {
                                        //         final selected = state.selected;

                                        //         return _countryBox(
                                        //           title: Country.parse(
                                        //             selected.code,
                                        //           ).name,
                                        //           flag: selected.code == 'SY'
                                        //               ? Image.asset(
                                        //                   "asset/image.png",
                                        //                   fit: BoxFit.cover,
                                        //                 )
                                        //               : Text(
                                        //                   Country.parse(
                                        //                     selected.code,
                                        //                   ).flagEmoji,
                                        //                   style: TextStyle(
                                        //                     fontSize: 22.sp,
                                        //                   ),
                                        //                 ),
                                        //           // Country.parse(
                                        //           //   selected.code,
                                        //           // ).flagEmoji,
                                        //           onArrowTap: () {
                                        //             _showCountriesDropdown(
                                        //               context,
                                        //               state,
                                        //             );
                                        //             context
                                        //                 .read<CitiesCubit>()
                                        //                 .reset();
                                        //           },
                                        //         );
                                        //       }

                                        //       return const SizedBox();
                                        //     },
                                        //   ),
                                        // ),
                                        // CompositedTransformTarget(
                                        //   link: _layerLink,
                                        //   child: BlocBuilder<CountriesCubit, CountriesState>(
                                        //     builder: (context, state) {
                                        //       // 1. حالة البداية (قبل جلب البيانات)
                                        //       if (state is CountriesInitial) {
                                        //         return _countryBox(
                                        //           title:
                                        //               AppTranslations.getText(
                                        //                 context,
                                        //                 'Choose country',
                                        //               ),
                                        //           flag: const SizedBox(),
                                        //           onTap: () async {
                                        //             final cubit = context
                                        //                 .read<CountriesCubit>();
                                        //             await cubit
                                        //                 .fetchCountries();
                                        //             if (cubit.state
                                        //                 is CountriesSuccess) {
                                        //               _showCountriesDropdown(
                                        //                 context,
                                        //                 cubit.state
                                        //                     as CountriesSuccess,
                                        //               );
                                        //             }
                                        //             context
                                        //                 .read<CitiesCubit>()
                                        //                 .reset();
                                        //           },
                                        //         );
                                        //       }

                                        //       // 2. حالة التحميل (Loading)
                                        //       if (state is CountriesLoading) {
                                        //         return CustomPaint(
                                        //           painter: _CustomBorderPainter(
                                        //             leftGap: isArabic
                                        //                 ? 0
                                        //                 : 70.w,
                                        //             rightGap: isArabic
                                        //                 ? 70.w
                                        //                 : 0,
                                        //           ),
                                        //           child: Container(
                                        //             width: 160.w,
                                        //             height: 45.h,
                                        //             child: const Center(
                                        //               child: SizedBox(
                                        //                 width: 20,
                                        //                 height: 20,
                                        //                 child:
                                        //                     CircularProgressIndicator(
                                        //                       strokeWidth: 2,
                                        //                       color: Color(
                                        //                         0xFFB9A779,
                                        //                       ),
                                        //                     ),
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         );
                                        //       }

                                        //       // 3. حالة الخطأ (Failure)
                                        //       if (state is CountriesFailure) {
                                        //         return Text(state.error);
                                        //       }

                                        //       // 4. حالة النجاح (Success)
                                        //       if (state is CountriesSuccess) {
                                        //         // إذا لم يتم اختيار دولة بعد
                                        //         if (!state.isCountrySelected) {
                                        //           return _countryBox(
                                        //             title:
                                        //                 AppTranslations.getText(
                                        //                   context,
                                        //                   'Choose country',
                                        //                 ),
                                        //             flag: const SizedBox(),
                                        //             onTap: () =>
                                        //                 _showCountriesDropdown(
                                        //                   context,
                                        //                   state,
                                        //                 ),
                                        //           );
                                        //         }

                                        //         // في حال تم اختيار دولة (تعريف المتغيرات هنا يحل مشكلة الـ unassigned)
                                        //         final selected =
                                        //             state.selected!;
                                        //         final countryData =
                                        //             Country.tryParse(
                                        //               selected.code,
                                        //             );

                                        //         String translatedName;
                                        //         try {
                                        //           translatedName =
                                        //               CountryLocalizations.of(
                                        //                 context,
                                        //               )?.countryName(
                                        //                 countryCode:
                                        //                     selected.code,
                                        //               ) ??
                                        //               countryData?.name ??
                                        //               selected.code;
                                        //         } catch (e) {
                                        //           translatedName =
                                        //               countryData?.name ??
                                        //               selected.code;
                                        //         }

                                        //         return _countryBox(
                                        //           countryCode: selected.code,
                                        //           title: translatedName,
                                        //           flag: selected.code == 'SY'
                                        //               ? Image.asset(
                                        //                   "asset/newsyria2.png",
                                        //                   fit: BoxFit.contain,
                                        //                 )
                                        //               : Text(
                                        //                   countryData
                                        //                           ?.flagEmoji ??
                                        //                       '🏳️',
                                        //                   style: TextStyle(
                                        //                     fontSize: 22.sp,
                                        //                   ),
                                        //                 ),
                                        //           onTap: () {
                                        //             _showCountriesDropdown(
                                        //               context,
                                        //               state,
                                        //             );
                                        //             context
                                        //                 .read<CitiesCubit>()
                                        //                 .reset();
                                        //             context
                                        //                 .read<AreasCubit>()
                                        //                 .reset();
                                        //           },
                                        //         );
                                        //       }

                                        //       return const SizedBox();
                                        //     },
                                        //   ),
                                        // ),
                                        CompositedTransformTarget(
                                          link: _layerLink,
                                          child: BlocConsumer<CountriesCubit, CountriesState>(
                                            // 1. هون بنعرض الديالوج أول ما الحالة تصير Failure
                                            listener: (context, state) {
                                              if (state is CountriesFailure) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    backgroundColor:
                                                        homeBorderColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image.asset(
                                                          AppImages.eerorrimage,
                                                          height: 50,
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          state
                                                              .error,
                                                          style:
                                                              TextStyle(
                                                                color: branding.buttonText,
                                                              ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                            ),
                                                        child: Text(
                                                          AppTranslations.getText(
                                                            context,
                                                            "Ok",
                                                          ),
                                                          style: TextStyle(
                                                            color: branding.buttonText,
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
                                                return _countryBox(
                                                  title:
                                                      AppTranslations.getText(
                                                        context,
                                                        'Choose country',
                                                      ),
                                                  flag: const SizedBox(),
                                                  onTap: () async {
                                                    final cubit = context
                                                        .read<CountriesCubit>();
                                                    await cubit
                                                        .fetchCountries();
                                                    if (cubit.state
                                                        is CountriesSuccess) {
                                                      _showCountriesDropdown(
                                                        context,
                                                        cubit.state
                                                            as CountriesSuccess,
                                                      );
                                                    }
                                                    context
                                                        .read<CitiesCubit>()
                                                        .reset();
                                                  },
                                                );
                                              }

                                              // حالة التحميل
                                              if (state is CountriesLoading) {
                                                return CustomPaint(
                                                  painter: _CustomBorderPainter(
                                                    leftGap: isArabic
                                                        ? 0
                                                        : 70.w,
                                                    rightGap: isArabic
                                                        ? 70.w
                                                        : 0,
                                                  ),
                                                  child: Container(
                                                    width: 160.w,
                                                    height: 45.h,
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
                                                );
                                              }

                                              // حالة الخطأ (هون بنرجع الـ Box فاضي أو عليه رسالة بسيطة عشان ما يضرب التصميم)
                                              if (state is CountriesFailure) {
                                                return _countryBox(
                                                  title:
                                                      AppTranslations.getText(
                                                        context,
                                                        'Choose country',
                                                      ),
                                                  flag: Icon(
                                                    Icons.error_outline,
                                                    color: branding.error,
                                                  ),
                                                  onTap: () => context
                                                      .read<CountriesCubit>()
                                                      .fetchCountries(),
                                                );
                                              }

                                              // حالة النجاح
                                              if (state is CountriesSuccess) {
                                                if (!state.isCountrySelected) {
                                                  return _countryBox(
                                                    title:
                                                        AppTranslations.getText(
                                                          context,
                                                          'Choose country',
                                                        ),
                                                    flag: const SizedBox(),
                                                    onTap: () =>
                                                        _showCountriesDropdown(
                                                          context,
                                                          state,
                                                        ),
                                                  );
                                                }

                                                final selected =
                                                    state.selected!;
                                                final countryData =
                                                    Country.tryParse(
                                                      selected.code,
                                                    );
                                                String translatedName;
                                                try {
                                                  translatedName =
                                                      CountryLocalizations.of(
                                                        context,
                                                      )?.countryName(
                                                        countryCode:
                                                            selected.code,
                                                      ) ??
                                                      countryData?.name ??
                                                      selected.code;
                                                } catch (e) {
                                                  translatedName =
                                                      countryData?.name ??
                                                      selected.code;
                                                }

                                                return _countryBox(
                                                  countryCode: selected.code,
                                                  title: translatedName,
                                                  flag: selected.code == 'SY'
                                                      ? Image.asset(
                                                          "asset/newsyria2.png",
                                                          fit: BoxFit.contain,
                                                        )
                                                      : Text(
                                                          countryData
                                                                  ?.flagEmoji ??
                                                              '🏳️',
                                                          style: TextStyle(
                                                            fontSize: 22.sp,
                                                          ),
                                                        ),
                                                  onTap: () {
                                                    _showCountriesDropdown(
                                                      context,
                                                      state,
                                                    );
                                                    context
                                                        .read<CitiesCubit>()
                                                        .reset();
                                                    context
                                                        .read<AreasCubit>()
                                                        .reset();
                                                  },
                                                );
                                              }

                                              return const SizedBox();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 25.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 18.w,
                                    ),
                                    child: Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.center,
                                      children: [
                                        // Expanded(
                                        //   child: CompositedTransformTarget(
                                        //     link: _areaLayerLink,
                                        //     child: BlocBuilder<AreasCubit, AreasState>(
                                        //       builder: (context, state) {
                                        //         String title =
                                        //             AppTranslations.getText(
                                        //               context,
                                        //               'Choose a region',
                                        //             );
                                        //         if (state is AreasLoading) {
                                        //           return CustomPaint(
                                        //             painter:
                                        //                 _CustomBorderPainter(
                                        //                   leftGap: 0,
                                        //                   rightGap: 0.w,
                                        //                 ),
                                        //             child: Container(
                                        //               width: 180.w,
                                        //               height: 45.h,
                                        //               padding:
                                        //                   EdgeInsets.symmetric(
                                        //                     horizontal: 8.w,
                                        //                   ),
                                        //               child: Center(
                                        //                 child: SizedBox(
                                        //                   width: 20,
                                        //                   height: 20,
                                        //                   child:
                                        //                       CircularProgressIndicator(
                                        //                         strokeWidth: 2,
                                        //                         color:
                                        //                             const Color(
                                        //                               0xFFB9A779,
                                        //                             ),
                                        //                       ),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           );
                                        //         }
                                        //         if (state is AreasSuccess &&
                                        //             state.selected != null) {
                                        //           //   title = state.selected!.name;
                                        //           title =
                                        //               LangHelper.isArabic(
                                        //                 context,
                                        //               )
                                        //               ? state.selected!.nameAr
                                        //               : state.selected!.nameEn;
                                        //         }

                                        //         return CustomPaint(
                                        //           painter: _CustomBorderPainter(
                                        //             leftGap: 0,
                                        //             rightGap: 0,
                                        //           ),
                                        //           child: Container(
                                        //             height: 45.h,
                                        //             padding:
                                        //                 EdgeInsets.symmetric(
                                        //                   horizontal: 8.w,
                                        //                 ),
                                        //             child: Row(
                                        //               mainAxisSize:
                                        //                   MainAxisSize.min,
                                        //               mainAxisAlignment:
                                        //                   MainAxisAlignment
                                        //                       .spaceAround,
                                        //               // mainAxisAlignment:
                                        //               //     MainAxisAlignment
                                        //               //         .center,
                                        //               children: [
                                        //                 GestureDetector(
                                        //                   onTap: () async {
                                        //                     _removeAreasOverlay();
                                        //                     final cityState =
                                        //                         context
                                        //                             .read<
                                        //                               CitiesCubit
                                        //                             >()
                                        //                             .state;

                                        //                     if (cityState
                                        //                             is! CitiesSuccess ||
                                        //                         cityState
                                        //                                 .selected ==
                                        //                             null)
                                        //                       return;

                                        //                     final cityId =
                                        //                         cityState
                                        //                             .selected!
                                        //                             .id;

                                        //                     await context
                                        //                         .read<
                                        //                           AreasCubit
                                        //                         >()
                                        //                         .fetchAreas(
                                        //                           cityId,
                                        //                         );

                                        //                     final areaState =
                                        //                         context
                                        //                             .read<
                                        //                               AreasCubit
                                        //                             >()
                                        //                             .state;

                                        //                     if (areaState
                                        //                             is AreasSuccess &&
                                        //                         areaState
                                        //                             .areas
                                        //                             .isNotEmpty) {
                                        //                       _openAreasDropdown(
                                        //                         context,
                                        //                         areaState,
                                        //                       );
                                        //                     }
                                        //                   },
                                        //                   child: Image.asset(
                                        //                     AppImages.trkyicon,
                                        //                     height: 15.h,
                                        //                     width: 16,
                                        //                   ),
                                        //                 ),
                                        //                 // SizedBox(
                                        //                 //   width: isArabic
                                        //                 //       ? title ==
                                        //                 //                 "اختر منطقة"
                                        //                 //             ? 23.w
                                        //                 //             : 30.w
                                        //                 //       : title ==
                                        //                 //             "Choose a region"
                                        //                 //       ? 6.w
                                        //                 //       : 30.w,
                                        //                 // ),
                                        //                 // SizedBox(
                                        //                 //   width: isArabic
                                        //                 //       ? title ==
                                        //                 //                 "أختر منطقة"
                                        //                 //             ? 40.w
                                        //                 //             : 60.w
                                        //                 //       : title ==
                                        //                 //             "Choose a region"
                                        //                 //       ? 6.w
                                        //                 //       : 65.w,
                                        //                 // ),
                                        //                 Flexible(
                                        //                   child: Text(
                                        //                     title,
                                        //                     maxLines: 1,

                                        //                     style: GoogleFonts.cairo(
                                        //                       fontSize: 13.sp,
                                        //                       fontWeight:
                                        //                           FontWeight
                                        //                               .w600,
                                        //                       color:
                                        //                           const Color(
                                        //                             0xFFB9A779,
                                        //                           ),
                                        //                     ),
                                        //                   ),
                                        //                 ),
                                        //                 Image.asset(
                                        //                   AppImages.ahtermantka,
                                        //                   height: 17.h,
                                        //                 ),

                                        //                 /// ⬇️ السهم
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         );
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: CompositedTransformTarget(
                                            link: _areaLayerLink,
                                            child: BlocBuilder<AreasCubit, AreasState>(
                                              builder: (context, state) {
                                                String title =
                                                    AppTranslations.getText(
                                                      context,
                                                      'Choose a region',
                                                    );

                                                if (state is AreasLoading) {
                                                  // حالة التحميل (بإمكانك جعلها قابلة للضغط أيضاً لو أردت)
                                                  return CustomPaint(
                                                    painter:
                                                        _CustomBorderPainter(
                                                          leftGap: 0,
                                                          rightGap: 0.w,
                                                        ),
                                                    child: Container(
                                                      width: 180.w,
                                                      height: 45.h,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8.w,
                                                          ),
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
                                                  );
                                                  ;
                                                }

                                                if (state is AreasSuccess &&
                                                    state.selected != null) {
                                                  title =
                                                      LangHelper.isArabic(
                                                        context,
                                                      )
                                                      ? state.selected!.nameAr
                                                      : state.selected!.nameEn;
                                                }

                                                // ⬇️ هنا التعديل: جعلنا GestureDetector يغلف الـ CustomPaint بالكامل
                                                return GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .opaque, // يضمن استجابة المساحات الفارغة للضغط
                                                  onTap: () async {
                                                    _removeAreasOverlay();
                                                    final cityState = context
                                                        .read<CitiesCubit>()
                                                        .state;

                                                    if (cityState
                                                            is! CitiesSuccess ||
                                                        cityState.selected ==
                                                            null)
                                                      return;

                                                    final cityId =
                                                        cityState.selected!.id;

                                                    // تنفيذ جلب المناطق
                                                    await context
                                                        .read<AreasCubit>()
                                                        .fetchAreas(cityId);

                                                    final areaState = context
                                                        .read<AreasCubit>()
                                                        .state;

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
                                                  child: CustomPaint(
                                                    painter:
                                                        _CustomBorderPainter(
                                                          leftGap: 0,
                                                          rightGap: 0,
                                                        ),
                                                    child: Container(
                                                      height: 45.h,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8.w,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround, // توزيع العناصر
                                                        children: [
                                                          // الأيقونة الأولى
                                                          Image.asset(
                                                            AppImages.trkyicon,
                                                            height: 15.h,
                                                            width: 16,
                                                          ),

                                                          // النص
                                                          Flexible(
                                                            child: Text(
                                                              title,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts.cairo(
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    homeSecondaryText,
                                                              ),
                                                            ),
                                                          ),

                                                          // أيقونة السهم (أو الصورة المحددة)
                                                          Image.asset(
                                                            AppImages
                                                                .ahtermantka,
                                                            height: 17.h,
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
                                        // Expanded(
                                        //   child: CompositedTransformTarget(
                                        //     link: _cityLayerLink,
                                        //     child: BlocBuilder<CitiesCubit, CitiesState>(
                                        //       builder: (context, state) {
                                        //         String title =
                                        //             AppTranslations.getText(
                                        //               context,
                                        //               'Choose a city',
                                        //             );
                                        //         if (state is CitiesLoading) {
                                        //           return CustomPaint(
                                        //             painter:
                                        //                 _CustomBorderPainter(
                                        //                   leftGap: 0,
                                        //                   rightGap: 0.w,
                                        //                 ),
                                        //             child: Container(
                                        //               width: 170.w,
                                        //               height: 45.h,
                                        //               padding:
                                        //                   EdgeInsets.symmetric(
                                        //                     horizontal: 0.w,
                                        //                   ),
                                        //               child: Center(
                                        //                 child: SizedBox(
                                        //                   width: 20,
                                        //                   height: 20,
                                        //                   child:
                                        //                       CircularProgressIndicator(
                                        //                         strokeWidth: 2,
                                        //                         color:
                                        //                             const Color(
                                        //                               0xFFB9A779,
                                        //                             ),
                                        //                       ),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           );
                                        //         }
                                        //         if (state is CitiesSuccess &&
                                        //             state.selected != null) {
                                        //           //  title = state.selected!.name;
                                        //           title =
                                        //               LangHelper.isArabic(
                                        //                 context,
                                        //               )
                                        //               ? state.selected!.nameAr
                                        //               : state.selected!.nameEn;
                                        //         }

                                        //         return CustomPaint(
                                        //           painter: _CustomBorderPainter(
                                        //             leftGap: 0,
                                        //             rightGap: 0,
                                        //           ),
                                        //           child: Container(
                                        //             height: 45.h,
                                        //             padding:
                                        //                 EdgeInsets.symmetric(
                                        //                   horizontal: 0.w,
                                        //                 ),
                                        //             child: Row(
                                        //               mainAxisSize:
                                        //                   MainAxisSize.min,
                                        //               mainAxisAlignment:
                                        //                   MainAxisAlignment
                                        //                       .spaceAround,
                                        //               children: [
                                        //                 GestureDetector(
                                        //                   onTap: () async {
                                        //                     _removeCitiesOverlay();

                                        //                     final countryState =
                                        //                         context
                                        //                             .read<
                                        //                               CountriesCubit
                                        //                             >()
                                        //                             .state;

                                        //                     if (countryState
                                        //                         is! CountriesSuccess)
                                        //                       return;

                                        //                     final countryId =
                                        //                         countryState
                                        //                             .selected
                                        //                             .id;

                                        //                     await context
                                        //                         .read<
                                        //                           CitiesCubit
                                        //                         >()
                                        //                         .fetchCities(
                                        //                           countryId,
                                        //                         );

                                        //                     final cityState =
                                        //                         context
                                        //                             .read<
                                        //                               CitiesCubit
                                        //                             >()
                                        //                             .state;

                                        //                     if (cityState
                                        //                             is CitiesSuccess &&
                                        //                         cityState
                                        //                             .cities
                                        //                             .isNotEmpty) {
                                        //                       _openCitiesDropdown(
                                        //                         context,
                                        //                         cityState,
                                        //                       );
                                        //                     }
                                        //                   },
                                        //                   child: Image.asset(
                                        //                     AppImages.trkyicon,
                                        //                     height: 12.h,
                                        //                     width: 15,
                                        //                   ),
                                        //                 ),
                                        //                 // SizedBox(
                                        //                 //   width: isArabic
                                        //                 //       ? title !=
                                        //                 //                 "اختر مدينة"
                                        //                 //             ? 35.w
                                        //                 //             : 35.w
                                        //                 //       : title ==
                                        //                 //             "Choose a city"
                                        //                 //       ? 13.w
                                        //                 //       : 35.w,
                                        //                 // ),
                                        //                 // SizedBox(
                                        //                 //   width: isArabic
                                        //                 //       ? title ==
                                        //                 //                 "أختر مدينة"
                                        //                 //             ? 40.w
                                        //                 //             : 50.w
                                        //                 //       : title ==
                                        //                 //             "Choose a city"
                                        //                 //       ? 10.w
                                        //                 //       : 50.w,
                                        //                 // ),
                                        //                 Flexible(
                                        //                   child: Text(
                                        //                     title,
                                        //                     maxLines: 1,
                                        //                     // overflow: TextOverflow
                                        //                     //     .ellipsis,
                                        //                     style: GoogleFonts.cairo(
                                        //                       fontSize: 14.sp,
                                        //                       fontWeight:
                                        //                           FontWeight
                                        //                               .w600,
                                        //                       color:
                                        //                           const Color(
                                        //                             0xFFB9A779,
                                        //                           ),
                                        //                     ),
                                        //                   ),
                                        //                 ),
                                        //                 Image.asset(
                                        //                   AppImages.ahtermadena,
                                        //                   height: 20.h,
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         );
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: CompositedTransformTarget(
                                            link: _cityLayerLink,
                                            child: BlocBuilder<CitiesCubit, CitiesState>(
                                              builder: (context, state) {
                                                // 1. تحديد النص المعروض بناءً على الحالة واللغة
                                                String title =
                                                    AppTranslations.getText(
                                                      context,
                                                      'Choose a city',
                                                    );
                                                if (state is CitiesSuccess &&
                                                    state.selected != null) {
                                                  title =
                                                      LangHelper.isArabic(
                                                        context,
                                                      )
                                                      ? state.selected!.nameAr
                                                      : state.selected!.nameEn;
                                                }

                                                // 2. جعل العنصر كاملاً قابلاً للضغط
                                                return GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .opaque, // يضمن استجابة المساحات الفارغة للضغط
                                                  onTap: () async {
                                                    if (state is CitiesLoading)
                                                      return; // منع الضغط أثناء التحميل

                                                    _removeCitiesOverlay();

                                                    final countryState = context
                                                        .read<CountriesCubit>()
                                                        .state;
                                                    if (countryState
                                                        is! CountriesSuccess)
                                                      return;

                                                    final countryId =
                                                        countryState
                                                            .selected
                                                            .id;

                                                    // جلب المدن
                                                    await context
                                                        .read<CitiesCubit>()
                                                        .fetchCities(countryId);

                                                    final cityState = context
                                                        .read<CitiesCubit>()
                                                        .state;
                                                    if (cityState
                                                            is CitiesSuccess &&
                                                        cityState
                                                            .cities
                                                            .isNotEmpty) {
                                                      _openCitiesDropdown(
                                                        context,
                                                        cityState,
                                                      );
                                                    }
                                                  },
                                                  child: CustomPaint(
                                                    painter:
                                                        _CustomBorderPainter(
                                                          leftGap: 0,
                                                          rightGap: 0,
                                                        ),
                                                    child: Container(
                                                      height: 45.h,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                          ),
                                                      child:
                                                          state is CitiesLoading
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
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                // الأيقونة الأولى
                                                                Image.asset(
                                                                  AppImages
                                                                      .trkyicon,
                                                                  height: 12.h,
                                                                  width: 15,
                                                                ),

                                                                // نص المدينة (مرن ليأخذ المساحة المتاحة)
                                                                Flexible(
                                                                  child: Text(
                                                                    title,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.cairo(
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color:
                                                                          homeSecondaryText,
                                                                    ),
                                                                  ),
                                                                ),

                                                                // أيقونة السهم/الاختيار
                                                                Image.asset(
                                                                  AppImages
                                                                      .ahtermadena,
                                                                  height: 20.h,
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                ],
                              ),
                            ),
                          ],
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
                        BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
                          builder: (context, state) {
                            if (state is PaymentMethodsLoading) {
                              return const CircularProgressIndicator();
                            }

                            if (state is PaymentMethodsFailure) {
                              return Text(state.error);
                            }

                            if (state is PaymentMethodsSuccess) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 3.1,
                                    ),
                                itemCount: state.methods.length,
                                itemBuilder: (context, index) {
                                  final m = state.methods[index];

                                  return Trkalthoel(
                                    image: m.logoPath,
                                    namer: LangHelper.isArabic(context)
                                        ? m.nameAr
                                        : m.nameEn,
                                    selected: state.selected?.id == m.id,
                                    onTap: () {
                                      // 1. تحديد الطريقة المختارة
                                      context
                                          .read<PaymentMethodsCubit>()
                                          .selectMethod(m);

                                      final fee = m.fee.toDouble();
                                      final symbol = m
                                          .symbol; // العملة الخاصة بالوسيلة المختارة (SYP, USDT, etc..)

                                      // 2. جلب سعر الصرف الحالي من الـ ExchangeRatesCubit
                                      double currentRate = 1.0;
                                      final rateState = context
                                          .read<ExchangeRatesCubit>()
                                          .state;
                                      if (rateState is ExchangeRatesSuccess) {
                                        final sendingCurrency =
                                            context
                                                .read<CurrencyCubit>()
                                                .state
                                                .currency;
                                        currentRate =
                                            _resolveRateForPayoutSymbol(
                                              rateState,
                                              sendingCurrency,
                                              symbol,
                                            );
                                      }

                                      // 3. تحديث الحسابات بناءً على الحقل الممتلئ
                                      if (amountController.text.isNotEmpty) {
                                        // دالة الإرسال (تأكد أنك حدثتها أيضاً لتستقبل سعر الصرف إذا لزم الأمر)
                                        onSendChanged(
                                          amountController.text,
                                          fee,
                                        );
                                      } else if (receiverController
                                          .text
                                          .isNotEmpty) {
                                        // استدعاء الدالة بـ 4 بارامترات كما تم تعريفها حديثاً
                                        onReceiverChanged(
                                          receiverController.text,
                                          fee,
                                          currentRate,
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

                        //             String finalResultText;
                        //             if (symbol == "SY" || symbol == "SYP") {
                        //               finalResultText =
                        //                   (netAmount * exchangeRate)
                        //                       .toStringAsFixed(
                        //                         0,
                        //                       ); // ليرة بدون فواصل
                        //             } else {
                        //               finalResultText = netAmount
                        //                   .toStringAsFixed(2);
                        //             }

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            BlocBuilder<ExchangeRatesCubit, ExchangeRatesState>(
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
                                    if (paymentState is PaymentMethodsSuccess &&
                                        paymentState.selected != null) {
                                      fee = paymentState.selected!.fee
                                          .toDouble();
                                      symbol = paymentState.selected!.symbol
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
                                        double.tryParse(
                                          currencyCubit.state.amount,
                                        ) ??
                                        0;
                                    double amountAfterFeeUSD =
                                        currentSendAmount * (1 - (fee / 100));

                                    String finalResultText = "";
                                    if (currentSendAmount > 0) {
                                      if (symbol != "USDT" && symbol != "USDC") {
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
                                      text2: symbol,
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
                            // الصورة في المنتصف
                            Image.asset(
                              AppImages.trsltstkbl1,
                              height: 15.h,
                              width: 15.w,
                            ),

                            // // --- خانة المرسل (الإجمالي) ---
                            // BlocBuilder<CurrencyCubit, CurrencyState>(
                            //   builder: (context, state) {
                            //     final isUsdt =
                            //         state.currency == CurrencyType.usdt;

                            //     double rawAmount =
                            //         double.tryParse(state.amount) ?? 0;

                            //     // تعديل هنا: عرض الرقم المرسل كـ رقم صحيح بدون فواصل
                            //     final amountToShow = state.amount.isEmpty
                            //         ? '0.00'
                            //         : rawAmount
                            //               .round()
                            //               .toString(); // استخدمنا round لتحويله لرقم صحيح

                            //     return Trsletastkbl2(
                            //       text1: AppTranslations.getText(
                            //         context,
                            //         'you_send',
                            //       ),
                            //       text2: isUsdt ? 'USDT' : 'USDC',
                            //       text3: amountToShow,
                            //     );
                            //   },
                            // ),
                            BlocBuilder<CurrencyCubit, CurrencyState>(
                              // builder: (context, state) {
                              //   final isUsdt =
                              //       state.currency == CurrencyType.usdt;
                              //   double rawAmount =
                              //       double.tryParse(state.amount) ?? 0;

                              //   String amountToShow;

                              //   if (state.amount.isEmpty || rawAmount == 0) {
                              //     // الحالة التي طلبتها: عند البداية أو الصفر
                              //     amountToShow = '0.00';
                              //   } else {
                              //     // إذا كان الرقم مثلاً 102.0، سيعرض 102 (رقم صحيح)
                              //     // أما إذا كنت تفضل بقاء الفواصل دائماً، استبدل .round() بـ .toStringAsFixed(2)
                              //     amountToShow = rawAmount.round().toString();
                              //   }

                              //   return Trsletastkbl2(
                              //     text1: AppTranslations.getText(
                              //       context,
                              //       'you_send',
                              //     ),
                              //     text2: isUsdt ? 'USDT' : 'USDC',
                              //     text3: amountToShow,
                              //   );
                              // },
                              // داخل الـ BlocBuilder الخاص بالـ CurrencyCubit
                              builder: (context, state) {
                                double rawAmount =
                                    double.tryParse(state.amount) ?? 0;
                                String amountToShow;
                                final isUsdt =
                                    state.currency == CurrencyType.usdt;
                                if (state.amount.isEmpty || rawAmount == 0) {
                                  amountToShow = '0.00';
                                } else {
                                  // ⚠️ استبدل .round() بـ .toStringAsFixed(2) ليتطابق مع الحقل العلوي
                                  amountToShow = rawAmount.toStringAsFixed(2);
                                }

                                return Trsletastkbl2(
                                  text1: AppTranslations.getText(
                                    context,
                                    'you_send',
                                  ),
                                  text2: isUsdt ? 'USDT' : 'USDC',
                                  text3:
                                      amountToShow, // الآن سيظهر 666.66 بالضبط
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 50.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0.w,
                            vertical: 0.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BlocBuilder<
                                PaymentMethodsCubit,
                                PaymentMethodsState
                              >(
                                builder: (context, state) {
                                  int fee = 0;
                                  String symbol = "USDT";

                                  if (state is PaymentMethodsSuccess &&
                                      state.selected != null) {
                                    fee = state.selected!.fee.toInt();

                                    //
                                    symbol = state.selected!.symbol;
                                  }

                                  return Container(
                                    height: 54.h,
                                    width: 250.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          8,
                                          //  isArabic ? 0 : 8,
                                        ),
                                        bottomLeft: Radius.circular(
                                          8,
                                          //   isArabic ? 0 : 8,
                                        ),
                                        topRight: Radius.circular(
                                          8,
                                          // isArabic ? 8 : 0,
                                        ),
                                        bottomRight: Radius.circular(
                                          8,
                                          //  isArabic ? 8 : 0,
                                        ),
                                      ),
                                      border: Border.all(
                                        color: homeBorderColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$fee%',
                                          style: GoogleFonts.cairo(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: homeSecondaryText,
                                          ),
                                        ),
                                        SizedBox(width: 130.w),
                                        Text(
                                          AppTranslations.getText(
                                            context,
                                            'fees_label',
                                          ),
                                          style: GoogleFonts.cairo(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: homePrimaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50.h),
                        GestureDetector(
                          onTap: () {
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
                                builder: (context) => Loginview(),
                              ),
                            );
                          },
                          child: Container(
                            height: 60.h,
                            width: 245.w,
                            decoration: branding.buildButtonDecoration(radius: 30),
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

  bool _isenoughtmony(BuildContext context) {
    final currencyState = context.read<CurrencyCubit>().state;
    if (int.parse(currencyState.amount) < 15) return false;
    return true;
  }

  bool _isFormValid(BuildContext context) {
    final countryState = context.read<CountriesCubit>().state;
    final cityState = context.read<CitiesCubit>().state;
    final areaState = context.read<AreasCubit>().state;
    final paymentState = context.read<PaymentMethodsCubit>().state;
    final currencyState = context.read<CurrencyCubit>().state;

    if (countryState is! CountriesSuccess) return false;
    if (cityState is! CitiesSuccess || cityState.selected == null) return false;
    if (areaState is! AreasSuccess || areaState.selected == null) return false;
    if (paymentState is! PaymentMethodsSuccess || paymentState.selected == null)
      return false;
    if (currencyState.amount.isEmpty || currencyState.amount == null)
      return false;

    return true;
  }
}

class _CustomBorderPainter extends CustomPainter {
  final double leftGap;
  final double rightGap;
  _CustomBorderPainter({this.leftGap = 40, this.rightGap = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final branding = appBrandingNotifier.value;
    final borderColor = branding.accent;
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(size.width - rightGap, 0);
    path.lineTo(leftGap, 0);
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CustomBorderPainter oldDelegate) =>
      leftGap != oldDelegate.leftGap || rightGap != oldDelegate.rightGap;
}
