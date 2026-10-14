// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hawwel/constans/appr_images.dart';
// import 'package:hawwel/constans/localization/app_tranzaction.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit_stat.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/cubit_airea/cubit.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/cubit_airea/cubit_stat.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_stat_city.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/cubit_conversion_methods/cubit.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/cubit_conversion_methods/cubit_stat.dart';
// import 'package:hawwel/featue/auth/welcomyou/widjt/trkalthoel.dart';
// import 'package:hawwel/featue/auth/welcomyou/widjt/trsltstakbl.dart';
// import 'package:hawwel/featue/notifation/notifacation_view.dart';
// import 'package:hawwel/featue/sender_information/sender_information_screen_view.dart';

// class Welcomyou extends StatefulWidget {
//   const Welcomyou({super.key});

//   @override
//   State<Welcomyou> createState() => _WelcomyouState();
// }

// bool isDropdownOpen = false;

// class _WelcomyouState extends State<Welcomyou> {
//   OverlayEntry? _countriesOverlay;
//   final LayerLink _layerLink = LayerLink();
//   // OverlayEntry? _countriesOverlay;
//   OverlayEntry? _citiesOverlay;
//   //OverlayEntry? _citiesOverlay;
//   final LayerLink _cityLayerLink = LayerLink();

//   final LayerLink _countryLayerLink = LayerLink();
//   //final LayerLink _cityLayerLink = LayerLink();
//   OverlayEntry? _areasOverlay;
//   final LayerLink _areaLayerLink = LayerLink();
//   void _removeAreasOverlay() {
//     _areasOverlay?.remove();
//     _areasOverlay = null;
//   }

//   void _openAreasDropdown(BuildContext context, AreasSuccess state) {
//     _removeAreasOverlay();

//     final overlay = Overlay.of(context);

//     _areasOverlay = OverlayEntry(
//       builder: (_) => Positioned(
//         width: 190.w,
//         child: CompositedTransformFollower(
//           link: _areaLayerLink,
//           offset: Offset(0, 50.h),
//           showWhenUnlinked: false,
//           child: Material(
//             elevation: 6,
//             borderRadius: BorderRadius.circular(12),
//             child: ListView(
//               shrinkWrap: true,
//               padding: EdgeInsets.zero,
//               children: state.areas.map((area) {
//                 return ListTile(
//                   title: Text(area.name, style: GoogleFonts.cairo()),
//                   onTap: () {
//                     context.read<AreasCubit>().selectArea(area);
//                     context.read<PaymentMethodsCubit>().fetchMethods(area.id);
//                     _removeAreasOverlay();
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//     );

//     overlay.insert(_areasOverlay!);
//   }

//   void _removeCitiesOverlay() {
//     _citiesOverlay?.remove();
//     _citiesOverlay = null;
//   }

//   void _openCitiesDropdown(BuildContext context, CitiesSuccess state) {
//     _removeCitiesOverlay(); // 🔥 أهم سطر

//     final overlay = Overlay.of(context);

//     _citiesOverlay = OverlayEntry(
//       builder: (context) => Positioned(
//         width: 190.w,
//         child: CompositedTransformFollower(
//           link: _cityLayerLink,
//           showWhenUnlinked: false,
//           offset: Offset(0, 50.h),
//           child: Material(
//             elevation: 6,
//             borderRadius: BorderRadius.circular(12),
//             child: ListView(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               children: state.cities.map((city) {
//                 return ListTile(
//                   title: Text(city.name, style: GoogleFonts.cairo()),
//                   onTap: () {
//                     context.read<CitiesCubit>().selectCity(city);
//                     _removeCitiesOverlay();
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//     );

//     overlay.insert(_citiesOverlay!);
//   }

//   void _showCountriesDropdown(BuildContext context, CountriesSuccess state) {
//     // إذا مفتوح سكّرو
//     _countriesOverlay?.remove();
//     _countriesOverlay = null;

//     final overlay = Overlay.of(context);

//     _countriesOverlay = OverlayEntry(
//       builder: (context) {
//         return Positioned(
//           width: 200.w,
//           child: CompositedTransformFollower(
//             link: _layerLink,
//             offset: Offset(0, 45.h), // ⬅️ ينزل تحت البوكس
//             showWhenUnlinked: false,
//             child: Material(
//               elevation: 6,
//               borderRadius: BorderRadius.circular(8),
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 children: state.countries.map((c) {
//                   return ListTile(
//                     dense: true,
//                     leading: Text(
//                       Country.parse(c.code).flagEmoji,
//                       style: const TextStyle(fontSize: 20),
//                     ),
//                     title: Text(
//                       Country.parse(c.code).name,
//                       style: GoogleFonts.cairo(fontSize: 14),
//                     ),
//                     onTap: () {
//                       context.read<CountriesCubit>().selectCountry(c);

//                       _countriesOverlay?.remove();
//                       _countriesOverlay = null;
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         );
//       },
//     );

//     overlay.insert(_countriesOverlay!);
//   }

//   Widget _countryBox({
//     required String title,
//     required String flag,
//     required VoidCallback onArrowTap,
//   }) {
//     return CustomPaint(
//       painter: _CustomBorderPainter(leftGap: 0, rightGap: 70.w),
//       child: Container(
//         width: 170.w,
//         height: 45.h,
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         child: Row(
//           children: [
//             GestureDetector(
//               onTap: onArrowTap,
//               child: Image.asset(AppImages.trkyicon, height: 20.h, width: 20.h),
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Text(
//                 title,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.cairo(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w600,
//                   color: const Color(0xFFB9A779),
//                 ),
//               ),
//             ),
//             Text(flag, style: TextStyle(fontSize: 22.sp)),
//             SizedBox(width: 6.w),
//           ],
//         ),
//       ),
//     );
//   }

//   int _currentIndex = 0; // الفهرس الحالي للناف بار
//   Country? _selectedCountry;
//   @override
//   Widget build(BuildContext context) {
//     final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
//     return Directionality(
//       textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: const Color(0xFF8A947D),
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.only(bottom: 130.h),
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFFB9A779), Color(0xFF849D95)],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Stack(
//                         children: [
//                           // الخلفية
//                           Container(
//                             height: 280.h,
//                             width: double.infinity,
//                             decoration: const BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Color(0xFF00443A),
//                                   Color(0xFF007E6B),
//                                   Color(0x9900AA91),
//                                 ],
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                               ),
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(20),
//                                 bottomRight: Radius.circular(20),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 10.h,
//                             right: isArabic ? null : 10.w,
//                             left: isArabic ? 10.w : null,
//                             child: Image.asset(
//                               'asset/4cb89412e17e9731c5a074ee767cc8afb7213109.png',
//                               height: 25.h,
//                               width: 25.w,
//                               // height: 200,
//                               // width: 200,
//                             ),
//                           ),
//                           // Positioned(
//                           //   top: 25.h,
//                           //   right: 110.w,
//                           //   child: Container(
//                           //     height: 65.h,
//                           //     width: 150.w,
//                           //     decoration: BoxDecoration(
//                           //       gradient: LinearGradient(
//                           //         colors: [
//                           //           Color(0xFFB9A779),
//                           //           Color(0xFF007E6B),
//                           //         ],
//                           //         begin: Alignment.centerLeft,
//                           //         end: Alignment.centerRight,
//                           //       ),
//                           //       borderRadius: BorderRadius.circular(20.r),
//                           //     ),
//                           //     child: Column(
//                           //       mainAxisAlignment: MainAxisAlignment.center,
//                           //       children: [
//                           //         Text(
//                           //           AppTranslations.getText(
//                           //             context,
//                           //             'current balance',
//                           //           ),
//                           //           style: GoogleFonts.cairo(
//                           //             fontSize: 16.sp,
//                           //             fontWeight: FontWeight.w700,
//                           //           ),
//                           //         ),
//                           //         Text(
//                           //           '283.65\$',
//                           //           style: GoogleFonts.cairo(
//                           //             fontSize: 16.sp,
//                           //             fontWeight: FontWeight.w700,
//                           //           ),
//                           //         ),
//                           //       ],
//                           //     ),
//                           //   ),
//                           // ),
//                           // 🔔 زر الإشعارات
//                           Positioned(
//                             top: 10.h,
//                             right: isArabic ? 10.w : null,
//                             left: isArabic ? null : 10.w,
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => Notifation(),
//                                   ),
//                                 );
//                               },
//                               child: Image.asset(
//                                 AppImages.notifaction,
//                                 height: 25.h,
//                                 width: 25.w,
//                               ),
//                             ),
//                           ),

//                           // send_amount_label
//                           Positioned(
//                             top: 80.h,
//                             right: isArabic ? 192.w : null,
//                             left: isArabic ? null : 253.w,
//                             child: Text(
//                               AppTranslations.getText(
//                                 context,
//                                 "send_amount_label",
//                               ),
//                               style: GoogleFonts.cairo(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFFB9A779),
//                               ),
//                             ),
//                           ),

//                           // send_to
//                           Positioned(
//                             top: 135.h,
//                             right: isArabic ? 25.w : null,
//                             left: isArabic ? null : 125.w,
//                             child: Text(
//                               AppTranslations.getText(context, "send_to"),
//                               style: GoogleFonts.cairo(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFFB9A779),
//                               ),
//                             ),
//                           ),

//                           // send_from
//                           // Positioned(
//                           //   top: 95.h,
//                           //   right: isArabic ? 25.w : null,
//                           //   left: isArabic ? null : 120.w,
//                           //   child: Text(
//                           //     AppTranslations.getText(context, "send_from"),
//                           //     style: GoogleFonts.cairo(
//                           //       fontSize: 14.sp,
//                           //       fontWeight: FontWeight.w600,
//                           //       color: Color(0xFFB9A779),
//                           //     ),
//                           //   ),
//                           // ),

//                           // دائرة
//                           // Positioned(
//                           //   top: 75.h,
//                           //   right: isArabic ? 325.w : null,
//                           //   left: isArabic ? null : 190.w,
//                           //   child: Image.asset(
//                           //     AppImages.cercl,
//                           //     height: 25.h,
//                           //     width: 25.w,
//                           //   ),
//                           // ),
//                           Positioned(
//                             top: 75.h,
//                             right: isArabic ? 325.w : null,
//                             left: isArabic ? null : 190.w,
//                             child: GestureDetector(
//                               onTap: () {
//                                 context.read<CurrencyCubit>().toggleCurrency();
//                               },
//                               child: Image.asset(
//                                 AppImages.cercl,
//                                 height: 25.h,
//                                 width: 25.w,
//                               ),
//                             ),
//                           ),

//                           // باقي المحتوى
//                           Positioned(
//                             top: 0.h,
//                             left: 0,
//                             right: 0,
//                             child: Column(
//                               children: [
//                                 SizedBox(height: 88.h),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 22.w,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       // CustomPaint(
//                                       //   painter: _CustomBorderPainter(
//                                       //     leftGap: 40.w,
//                                       //     rightGap: 108.w,
//                                       //   ),
//                                       //   child: Container(
//                                       //     width: 170.w,
//                                       //     height: 45.h,
//                                       //     child: Row(
//                                       //       children: [
//                                       //         Padding(
//                                       //           padding: EdgeInsets.symmetric(
//                                       //             horizontal: 8.w,
//                                       //           ),
//                                       //           child: Image.asset(
//                                       //             AppImages.usdt,
//                                       //             height: 20.h,
//                                       //             width: 20.h,
//                                       //           ),
//                                       //         ),
//                                       //         SizedBox(width: 15.w),
//                                       //         Text(
//                                       //           'USDT',
//                                       //           style: GoogleFonts.cairo(
//                                       //             fontSize: 18.sp,
//                                       //             fontWeight: FontWeight.w600,
//                                       //             color: Color(0xFFB9A779),
//                                       //           ),
//                                       //         ),
//                                       //         SizedBox(width: 25.w),
//                                       //         Image.asset(
//                                       //           AppImages.usdtcont,
//                                       //           height: 30.h,
//                                       //           width: 30.h,
//                                       //         ),
//                                       //       ],
//                                       //     ),
//                                       //   ),
//                                       // ),
//                                       BlocBuilder<CurrencyCubit, CurrencyState>(
//                                         builder: (context, state) {
//                                           final isUsdt =
//                                               state.currency ==
//                                               CurrencyType.usdt;

//                                           return CustomPaint(
//                                             painter: _CustomBorderPainter(
//                                               leftGap: 40.w,
//                                               rightGap: 108.w,
//                                             ),
//                                             child: Container(
//                                               width: 170.w,
//                                               height: 45.h,
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: 8.w,
//                                               ),
//                                               child: Row(
//                                                 children: [
//                                                   Image.asset(
//                                                     isUsdt
//                                                         ? AppImages.usdt
//                                                         : AppImages.usdc,
//                                                     height: 30.h,
//                                                     width: 30.h,
//                                                   ),
//                                                   // Image.asset(
//                                                   //   AppImages.usdt,
//                                                   //   height: 20.h,
//                                                   //   width: 20.h,
//                                                   // ),
//                                                   SizedBox(width: 10.w),
//                                                   Text(
//                                                     isUsdt ? 'USDT' : 'USDC',
//                                                     style: GoogleFonts.cairo(
//                                                       fontSize: 16.sp,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       color: Color(0xFFB9A779),
//                                                     ),
//                                                   ),
//                                                   SizedBox(width: 10.w),

//                                                   
//                                                   Expanded(
//                                                     child: TextField(
//                                                       keyboardType:
//                                                           TextInputType.number,
//                                                       onChanged: (v) {
//                                                         context
//                                                             .read<
//                                                               CurrencyCubit
//                                                             >()
//                                                             .changeAmount(v);
//                                                       },
//                                                       decoration:
//                                                           InputDecoration(
//                                                             hintText: '0.00',

//                                                             border: InputBorder
//                                                                 .none,
//                                                           ),
//                                                       style: GoogleFonts.cairo(
//                                                         fontSize: 16.sp,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: Color(
//                                                           0xFFB9A779,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),

//                                                   /// اسم العملة
//                                                   SizedBox(width: 8.w),

//                                                   /// صورة العملة
//                                                   // Image.asset(
//                                                   //   isUsdt
//                                                   //       ? AppImages.usdtcont
//                                                   //       : AppImages.usdc,
//                                                   //   height: 30.h,
//                                                   //   width: 30.h,
//                                                   // ),
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),

//                                       // CustomPaint(
//                                       //   painter: _CustomBorderPainter(
//                                       //     leftGap: 0,
//                                       //     rightGap: 70.w,
//                                       //   ),
//                                       //   child: Container(
//                                       //     width: 170.w,
//                                       //     height: 45.h,
//                                       //     child: Row(
//                                       //       children: [
//                                       //         Padding(
//                                       //           padding: EdgeInsets.symmetric(
//                                       //             horizontal: 8.w,
//                                       //           ),
//                                       //           child: Image.asset(
//                                       //             AppImages.trkyicon,
//                                       //             height: 15.h,
//                                       //             width: 15.w,
//                                       //           ),
//                                       //         ),
//                                       //         SizedBox(width: 20.w),
//                                       //         Text(
//                                       //           AppTranslations.getText(
//                                       //             context,
//                                       //             'turkey',
//                                       //           ),
//                                       //           style: GoogleFonts.cairo(
//                                       //             fontSize: 20.sp,
//                                       //             fontWeight: FontWeight.w600,
//                                       //             color: Color(0xFFB9A779),
//                                       //           ),
//                                       //         ),
//                                       //         SizedBox(width: 20.w),
//                                       //         Image.asset(
//                                       //           AppImages.trky,
//                                       //           height: 25.h,
//                                       //           width: 25.h,
//                                       //         ),
//                                       //       ],
//                                       //     ),
//                                       //   ),
//                                       // ),
//                                       Expanded(
//                                         child: CompositedTransformTarget(
//                                           link: _areaLayerLink,
//                                           child: BlocBuilder<AreasCubit, AreasState>(
//                                             builder: (context, state) {
//                                               String title =
//                                                   AppTranslations.getText(
//                                                     context,
//                                                     'Choose a region',
//                                                   );

//                                               if (state is AreasSuccess &&
//                                                   state.selected != null) {
//                                                 title = state.selected!.name;
//                                               }

//                                               return CustomPaint(
//                                                 painter: _CustomBorderPainter(
//                                                   leftGap: 0,
//                                                   rightGap: 0,
//                                                 ),
//                                                 child: Container(
//                                                   height: 45.h,
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: 8.w,
//                                                   ),
//                                                   child: Row(
//                                                     children: [
//                                                       GestureDetector(
//                                                         onTap: () async {
//                                                           _removeAreasOverlay();
//                                                           final cityState =
//                                                               context
//                                                                   .read<
//                                                                     CitiesCubit
//                                                                   >()
//                                                                   .state;

//                                                           if (cityState
//                                                                   is! CitiesSuccess ||
//                                                               cityState
//                                                                       .selected ==
//                                                                   null)
//                                                             return;

//                                                           final cityId =
//                                                               cityState
//                                                                   .selected!
//                                                                   .id;

//                                                           await context
//                                                               .read<
//                                                                 AreasCubit
//                                                               >()
//                                                               .fetchAreas(
//                                                                 cityId,
//                                                               );

//                                                           final areaState =
//                                                               context
//                                                                   .read<
//                                                                     AreasCubit
//                                                                   >()
//                                                                   .state;

//                                                           if (areaState
//                                                                   is AreasSuccess &&
//                                                               areaState
//                                                                   .areas
//                                                                   .isNotEmpty) {
//                                                             _openAreasDropdown(
//                                                               context,
//                                                               areaState,
//                                                             );
//                                                           }
//                                                         },
//                                                         child: Image.asset(
//                                                           AppImages.trkyicon,
//                                                           height: 15.h,
//                                                         ),
//                                                       ),

//                                                       SizedBox(width: 35.w),

//                                                       Expanded(
//                                                         child: Text(
//                                                           title,
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style:
//                                                               GoogleFonts.cairo(
//                                                                 fontSize: 16.sp,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 color:
//                                                                     const Color(
//                                                                       0xFFB9A779,
//                                                                     ),
//                                                               ),
//                                                         ),
//                                                       ),
//                                                       Image.asset(
//                                                         AppImages.ahtermantka,
//                                                         height: 20.h,
//                                                       ),

//                                                       /// ⬇️ السهم
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 15.h),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 20.w,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       /// -------- Choose City --------
//                                       Expanded(
//                                         child: CompositedTransformTarget(
//                                           link: _cityLayerLink,
//                                           child: BlocBuilder<CitiesCubit, CitiesState>(
//                                             builder: (context, state) {
//                                               String title =
//                                                   AppTranslations.getText(
//                                                     context,
//                                                     'Choose a city',
//                                                   );

//                                               if (state is CitiesSuccess &&
//                                                   state.selected != null) {
//                                                 title = state.selected!.name;
//                                               }

//                                               return CustomPaint(
//                                                 painter: _CustomBorderPainter(
//                                                   leftGap: 0,
//                                                   rightGap: 0,
//                                                 ),
//                                                 child: Container(
//                                                   height: 45.h,
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: 8.w,
//                                                   ),
//                                                   child: Row(
//                                                     children: [
//                                                       GestureDetector(
//                                                         onTap: () async {
//                                                           _removeCitiesOverlay(); // 🔥 دايمًا أول شي

//                                                           final countryState =
//                                                               context
//                                                                   .read<
//                                                                     CountriesCubit
//                                                                   >()
//                                                                   .state;

//                                                           if (countryState
//                                                               is! CountriesSuccess)
//                                                             return;

//                                                           final countryId =
//                                                               countryState
//                                                                   .selected
//                                                                   .id;

//                                                           /// طلب المدن
//                                                           await context
//                                                               .read<
//                                                                 CitiesCubit
//                                                               >()
//                                                               .fetchCities(
//                                                                 countryId,
//                                                               );

//                                                           final cityState =
//                                                               context
//                                                                   .read<
//                                                                     CitiesCubit
//                                                                   >()
//                                                                   .state;

//                                                           if (cityState
//                                                                   is CitiesSuccess &&
//                                                               cityState
//                                                                   .cities
//                                                                   .isNotEmpty) {
//                                                             _openCitiesDropdown(
//                                                               context,
//                                                               cityState,
//                                                             );
//                                                           }
//                                                         },
//                                                         child: Image.asset(
//                                                           AppImages.trkyicon,
//                                                           height: 15.h,
//                                                         ),
//                                                       ),

//                                                       SizedBox(width: 35.w),

//                                                       Expanded(
//                                                         child: Text(
//                                                           title,
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style:
//                                                               GoogleFonts.cairo(
//                                                                 fontSize: 16.sp,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 color:
//                                                                     const Color(
//                                                                       0xFFB9A779,
//                                                                     ),
//                                                               ),
//                                                         ),
//                                                       ),
//                                                       Image.asset(
//                                                         AppImages.ahtermadena,
//                                                         height: 20.h,
//                                                       ),

//                                                       /// ⬇️ السهم
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ),

//                                       // SizedBox(width: 8.w),

//                                       /// -------- Choose Country --------
//                                       CompositedTransformTarget(
//                                         link: _layerLink,
//                                         child:
//                                             BlocBuilder<
//                                               CountriesCubit,
//                                               CountriesState
//                                             >(
//                                               builder: (context, state) {
//                                                 /// أول مرة
//                                                 if (state is CountriesInitial) {
//                                                   return _countryBox(
//                                                     title:
//                                                         AppTranslations.getText(
//                                                           context,
//                                                           'Choose country',
//                                                         ),
//                                                     flag: '🌍',
//                                                     onArrowTap: () {
//                                                       context
//                                                           .read<
//                                                             CountriesCubit
//                                                           >()
//                                                           .fetchCountries();
//                                                       context
//                                                           .read<CitiesCubit>()
//                                                           .reset();
//                                                       //   _removeCitiesOverlay();
//                                                     },
//                                                   );
//                                                 }

//                                                 /// تحميل
//                                                 if (state is CountriesLoading) {
//                                                   return const SizedBox(
//                                                     height: 45,
//                                                     child: Center(
//                                                       child:
//                                                           CircularProgressIndicator(),
//                                                     ),
//                                                   );
//                                                 }

//                                                 /// خطأ
//                                                 if (state is CountriesFailure) {
//                                                   return Text(state.error);
//                                                 }

//                                                 /// نجاح
//                                                 if (state is CountriesSuccess) {
//                                                   final selected =
//                                                       state.selected;

//                                                   return _countryBox(
//                                                     title: Country.parse(
//                                                       selected.code,
//                                                     ).name,
//                                                     flag: Country.parse(
//                                                       selected.code,
//                                                     ).flagEmoji,
//                                                     onArrowTap: () {
//                                                       _showCountriesDropdown(
//                                                         context,
//                                                         state,
//                                                       );
//                                                       context
//                                                           .read<CitiesCubit>()
//                                                           .reset();
//                                                     },
//                                                   );
//                                                 }

//                                                 return const SizedBox();
//                                               },
//                                             ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 SizedBox(height: 15.h),
//                                 // Padding(
//                                 //   padding: EdgeInsets.symmetric(
//                                 //     horizontal: 64.w,
//                                 //   ),
//                                 //   child: CompositedTransformTarget(
//                                 //     link: _areaLayerLink,
//                                 //     child: BlocBuilder<AreasCubit, AreasState>(
//                                 //       builder: (context, state) {
//                                 //         String title = AppTranslations.getText(
//                                 //           context,
//                                 //           'Choose a region',
//                                 //         );

//                                 //         if (state is AreasSuccess &&
//                                 //             state.selected != null) {
//                                 //           title = state.selected!.name;
//                                 //         }

//                                 //         return CustomPaint(
//                                 //           painter: _CustomBorderPainter(
//                                 //             leftGap: 0,
//                                 //             rightGap: 0,
//                                 //           ),
//                                 //           child: Container(
//                                 //             height: 45.h,
//                                 //             padding: EdgeInsets.symmetric(
//                                 //               horizontal: 8.w,
//                                 //             ),
//                                 //             child: Row(
//                                 //               children: [
//                                 //                 Image.asset(
//                                 //                   AppImages.trkyicon,
//                                 //                   height: 15.h,
//                                 //                 ),
//                                 //                 SizedBox(width: 8.w),

//                                 //                 Expanded(
//                                 //                   child: Text(
//                                 //                     title,
//                                 //                     overflow:
//                                 //                         TextOverflow.ellipsis,
//                                 //                     style: GoogleFonts.cairo(
//                                 //                       fontSize: 14.sp,
//                                 //                       fontWeight:
//                                 //                           FontWeight.w600,
//                                 //                       color: const Color(
//                                 //                         0xFFB9A779,
//                                 //                       ),
//                                 //                     ),
//                                 //                   ),
//                                 //                 ),

//                                 //                 /// ⬇️ السهم
//                                 //                 GestureDetector(
//                                 //                   onTap: () async {
//                                 //                     _removeAreasOverlay();
//                                 //                     final cityState = context
//                                 //                         .read<CitiesCubit>()
//                                 //                         .state;

//                                 //                     if (cityState
//                                 //                             is! CitiesSuccess ||
//                                 //                         cityState.selected ==
//                                 //                             null)
//                                 //                       return;

//                                 //                     final cityId =
//                                 //                         cityState.selected!.id;

//                                 //                     await context
//                                 //                         .read<AreasCubit>()
//                                 //                         .fetchAreas(cityId);

//                                 //                     final areaState = context
//                                 //                         .read<AreasCubit>()
//                                 //                         .state;

//                                 //                     if (areaState
//                                 //                             is AreasSuccess &&
//                                 //                         areaState
//                                 //                             .areas
//                                 //                             .isNotEmpty) {
//                                 //                       _openAreasDropdown(
//                                 //                         context,
//                                 //                         areaState,
//                                 //                       );
//                                 //                     }
//                                 //                   },
//                                 //                   child: Image.asset(
//                                 //                     AppImages.ahtermantka,
//                                 //                     height: 20.h,
//                                 //                   ),
//                                 //                 ),
//                                 //               ],
//                                 //             ),
//                                 //           ),
//                                 //         );
//                                 //       },
//                                 //     ),
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10.h),
//                       Text(
//                         AppTranslations.getText(context, 'Conversion methods'),
//                         style: GoogleFonts.cairo(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF000000),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
//                         builder: (context, state) {
//                           if (state is PaymentMethodsLoading) {
//                             return const CircularProgressIndicator();
//                           }

//                           if (state is PaymentMethodsFailure) {
//                             return Text(state.error);
//                           }

//                           if (state is PaymentMethodsSuccess) {
//                             return GridView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               padding: EdgeInsets.symmetric(horizontal: 20.w),
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     mainAxisSpacing: 12,
//                                     crossAxisSpacing: 12,
//                                     childAspectRatio: 3.1,
//                                   ),
//                               itemCount: state.methods.length,
//                               itemBuilder: (context, index) {
//                                 final m = state.methods[index];

//                                 return Trkalthoel(
//                                   image: m.logoPath,
//                                   namer: m.name,
//                                   selected: state.selected?.id == m.id,
//                                   onTap: () {
//                                     print("lllllllllllll${state.selected?.id}");
//                                     context
//                                         .read<PaymentMethodsCubit>()
//                                         .selectMethod(m);
//                                   },
//                                 );
//                               },
//                             );
//                           }

//                           return const SizedBox();
//                         },
//                       ),

//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.center,
//                       //   children: [
//                       //     Trkalthoe3(
//                       //       image: AppImages.tslembled,
//                       //       namer: AppTranslations.getText(
//                       //         context,
//                       //         'transfer_option_hand_to_hand',
//                       //       ),
//                       //     ),
//                       //     Trkalthoel(
//                       //       image: AppImages.alfoad,
//                       //       namer: AppTranslations.getText(
//                       //         context,
//                       //         'transfer_option_al_fouad',
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                       SizedBox(height: 20.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // SizedBox(width: 6.w),
//                           Trsletastkbl(
//                             text1: AppTranslations.getText(
//                               context,
//                               'receiver_gets',
//                             ),
//                             text2: 'SYP',
//                             text3: '0.00',
//                           ),
//                           Image.asset(
//                             AppImages.trsltstkbl1,
//                             height: 15.h,
//                             width: 15.w,
//                           ),
//                           Trsletastkbl(
//                             text1: AppTranslations.getText(context, 'you_send'),
//                             text2: 'USDT',
//                             text3: '0.00',
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20.0.w,
//                           vertical: 20.h,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               height: 54.h,
//                               width: 165.w,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topRight: Radius.circular(isArabic ? 0 : 8),
//                                   bottomRight: Radius.circular(
//                                     isArabic ? 0 : 8,
//                                   ),
//                                   topLeft: Radius.circular(isArabic ? 8 : 0),
//                                   bottomLeft: Radius.circular(isArabic ? 8 : 0),
//                                 ),

//                                 border: Border.all(color: Color(0xFF6B1F2A)),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                    //   context.read<TransfersCubit>().allData.first.transfers.first.
//                                     'USDT 0',
//                                     style: GoogleFonts.cairo(
//                                       fontSize: 15.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: Color(0xFF565656),
//                                     ),
//                                   ),
//                                   Text(
//                                     AppTranslations.getText(
//                                       context,
//                                       'transfer_label',
//                                     ),
//                                     style: GoogleFonts.cairo(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: Color(0xFF000000),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               height: 54.h,
//                               width: 165.w,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(isArabic ? 0 : 8),
//                                   bottomLeft: Radius.circular(isArabic ? 0 : 8),
//                                   topRight: Radius.circular(isArabic ? 8 : 0),
//                                   bottomRight: Radius.circular(
//                                     isArabic ? 8 : 0,
//                                   ),
//                                 ),
//                                 border: Border.all(color: Color(0xFF6B1F2A)),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     'USDT 0',
//                                     style: GoogleFonts.cairo(
//                                       fontSize: 15.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: Color(0xFF565656),
//                                     ),
//                                   ),
//                                   Text(
//                                     AppTranslations.getText(
//                                       context,
//                                       'fees_label',
//                                     ),
//                                     style: GoogleFonts.cairo(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: Color(0xFF000000),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // SizedBox(width: 30.w),
//                           Text(
//                             'usdt',
//                             style: GoogleFonts.cairo(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF565656),
//                             ),
//                           ),
//                           SizedBox(width: 180.w),
//                           Text(
//                             AppTranslations.getText(context, 'total_amount'),
//                             style: GoogleFonts.cairo(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF000000),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20.h),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => Senderinformation(),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           height: 60.h,
//                           width: 245.w,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             color: const Color(0xFF6B1F2A),
//                           ),
//                           child: Center(
//                             child: Text(
//                               AppTranslations.getText(
//                                 context,
//                                 'send_transfer_cta',
//                               ),
//                               style: GoogleFonts.cairo(
//                                 fontSize: 20.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           //   bottomNavigationBar: BottomNavigationBar(
//           //     currentIndex: _currentIndex,
//           //     onTap: (index) {
//           //       setState(() {
//           //         _currentIndex = index;
//           //       });
//           //     },
//           //     type: BottomNavigationBarType.fixed,
//           //     backgroundColor: const Color(0xFF00443A),
//           //     selectedItemColor: const Color(0xFFB9A779),
//           //     unselectedItemColor: Colors.white,
//           //     iconSize: 24.sp,
//           //     selectedFontSize: 12.sp,
//           //     unselectedFontSize: 12.sp,
//           //     items: const [
//           //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية',),
//           //       BottomNavigationBarItem(
//           //         icon: Icon(Icons.swap_horiz),
//           //         label: ' الطلبات',
//           //       ),
//           //     //  BottomNavigationBarItem(, label: 'العملاء',),
//           //       BottomNavigationBarItem(
//           //         icon: Icon(Icons.settings),
//           //         label: 'الإعدادات',
//           //       ),
//           //     ],
//           //   ),
//           // ),
//         ),
//       ),
//     );
//   }
// }

// class _CustomBorderPainter extends CustomPainter {
//   final double leftGap;
//   final double rightGap;
//   _CustomBorderPainter({this.leftGap = 40, this.rightGap = 0});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFFD2B887)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;

//     final path = Path();
//     path.moveTo(size.width - rightGap, 0);
//     path.lineTo(leftGap, 0);
//     path.moveTo(0, 0);
//     path.lineTo(0, size.height);
//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, 0);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant _CustomBorderPainter oldDelegate) =>
//       leftGap != oldDelegate.leftGap || rightGap != oldDelegate.rightGap;
// }
