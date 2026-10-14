import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/featue/paymant/paymant_done.dart';

class Reviewtranzation extends StatefulWidget {
  const Reviewtranzation({super.key});

  @override
  State<Reviewtranzation> createState() => _ReviewtranzationState();
}

class _ReviewtranzationState extends State<Reviewtranzation> {
  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;

    return SafeArea(
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 44.h),
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
                  AppTranslations.getText(context, 'review_transaction'),
                  style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: branding.secondaryText,
                  ),
                ),
                SizedBox(height: 35.h),
                Text(
                  AppTranslations.getText(context, 'send'),
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
                        '  USDC',
                        style: GoogleFonts.cairo(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                Container(
                  height: 145.h,
                  width: 280.w,
                  decoration: BoxDecoration(
                    color: branding.inputBorder,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3), // لون الظل
                        spreadRadius: 2, // مدى الانتشار
                        blurRadius: 10, // درجة التمويه
                        offset: const Offset(0, 4), // موقع الظل (x,y)
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppTranslations.getText(
                            context,
                            'recipient_receives',
                          ),
                          style: GoogleFonts.cairo(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.primaryText,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          ' 1 USDC',
                          style: GoogleFonts.cairo(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.appBar,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          '\$1',
                          style: GoogleFonts.cairo(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Row(
                    // mainAxisAlignment: isArabic
                    //     ? MainAxisAlignment.end
                    //     : MainAxisAlignment.end,
                    children: [
                      Text(
                        AppTranslations.getText(context, 'beneficiary_data'),
                        style: GoogleFonts.cairo(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(width: 80.w),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.diagonal3Values(
                        isArabic ? -1.0 : 1.0,
                        1.0,
                        1.0,
                      ),
                      child: Image.asset(
                        AppImages.paymntnext,
                        height: 20.h,
                        width: 20.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 90.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Paymantdon()),
                    );
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
                        AppTranslations.getText(context, 'confirm_send'),
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
