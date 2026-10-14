import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/bootom_navigator.dart';

class Paymantdon extends StatefulWidget {
  const Paymantdon({super.key});

  @override
  State<Paymantdon> createState() => _PaymantdonState();
}

class _PaymantdonState extends State<Paymantdon> {
  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;

    return SafeArea(
      child: Directionality(
        textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 54.h),
                    child: Text(
                      AppTranslations.getText(context, 'payment'),
                      style: GoogleFonts.cairo(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: branding.primaryText,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  AppTranslations.getText(context, 'payment_completed'),
                  style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: branding.secondaryText,
                  ),
                ),
                SizedBox(height: 30.h),
                Image.asset(
                  AppImages.cheackpaymnt,
                  height: 150.h,
                  width: 100.w,
                ),
                SizedBox(height: 30.h),
                Text(
                  AppTranslations.getText(context, 'you_paid'),
                  style: GoogleFonts.cairo(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: branding.secondaryText,
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 125.w),
                  child: Row(
                    children: [
                      Image.asset(AppImages.usdt, height: 25.h, width: 25.w),
                      Text(
                        '1 USDC',
                        style: GoogleFonts.cairo(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 64.w),
                  child: Row(
                    mainAxisAlignment: isArabic
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.end,
                    children: [
                      Text(
                        AppTranslations.getText(context, 'beneficiary'),
                        style: GoogleFonts.cairo(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  height: 100.h,
                  width: 250.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: branding.primaryText),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),

                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            'ahmad@gmail.com',
                            style: GoogleFonts.cairo(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.primaryText,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                            '102346752',
                            style: GoogleFonts.cairo(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 55.w),
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..scale(isArabic ? 1.0 : -1.0, -1.0),
                          child: Image.asset(
                            AppImages.paymntnext,
                            height: 20.h,
                            width: 20.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    //رقم صفحة Spendmouny بالـ list,
                    // TODO: تنفيذ التسجيل
                  },
                  child: Container(
                    height: 58.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: branding.buttonBg,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: const Color(0xFFB9A779).withOpacity(0.5),
                      //     spreadRadius: 1,
                      //     blurRadius: 8,
                      //     offset: const Offset(0, 3),
                      //   ),
                      // ],
                    ),
                    child: Center(
                      child: Text(
                        AppTranslations.getText(context, 'next'),
                        style: GoogleFonts.cairo(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: branding.buttonText,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
