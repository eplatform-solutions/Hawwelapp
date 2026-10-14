// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/featue/paymant/payment_send.dart';

class wallateview extends StatefulWidget {
  const wallateview({super.key});

  @override
  State<wallateview> createState() => _wallateviewState();
}

class _wallateviewState extends State<wallateview> {
  TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: branding.badge,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 140.0.w,
                  vertical: 60.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.getText(context, 'payment_instructions'),
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: branding.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 120.h, // <-- هنا بتتحكم بالبعد من الأعلى
              left: 0,
              right: 0,
              child: Container(
                height: 800.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0.w,
                    vertical: 0.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          AppTranslations.getText(context, 'total_balance'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: branding.primaryText,
                            // استخدم خط عربي جميل إن أحببت
                            shadows: [
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 16.0,
                                color: branding.accent,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          '1500 USDT',
                          style: GoogleFonts.cairo(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.iconPrimary,
                          ),
                        ),
                        SizedBox(height: 80.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // HomeScreen.homeKey.currentState?.goToPage(
                                  //   4,
                                  // ); // رقم صفحة Spendmouny بالـ list,
                                },
                                child: Container(
                                  height: 46.h,
                                  width: 140.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: branding.iconPrimary,
                                    ),
                                    color: branding.screenBg,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppTranslations.getText(
                                        context,
                                        'increase_balance',
                                      ),
                                      style: GoogleFonts.cairo(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                        color: branding.primaryText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30.w),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Paymentsend(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 46.h,
                                  width: 140.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: branding.iconPrimary,
                                    ),
                                    color: branding.hintText,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppTranslations.getText(
                                        context,
                                        'send_money',
                                      ),
                                      style: GoogleFonts.cairo(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: branding.primaryText,
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
          ],
        ),
      ),
    );
  }
}
