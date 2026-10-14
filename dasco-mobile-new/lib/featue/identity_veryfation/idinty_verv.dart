// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/featue/idintity_veryfation/widgt/stepper.dart';
import 'package:hawwel/featue/lode_file/lode_file.dart';

class idintyview extends StatefulWidget {
  const idintyview({super.key});

  @override
  State<idintyview> createState() => _idintyviewState();
}

class _idintyviewState extends State<idintyview> {
  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: branding.appBar,
        body: Column(
          children: [
            SizedBox(height: 100.h),
            Container(
              height: 153.h,
              width: 330.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: branding.badge,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3), // لون الظل
                    spreadRadius: 2, // مدى الانتشار
                    blurRadius: 10, // درجة التمويه
                    offset: const Offset(0, 4), // موقع الظل (x,y)
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Container(
                      height: 55.h,
                      width: 55.w,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(AppImages.idinty),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: .0),
                        child: Text(
                          AppTranslations.getText(
                            context,
                            'Identity verification',
                          ),
                          style: GoogleFonts.cairo(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.iconPrimary,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Text(
                          AppTranslations.getText(
                            context,
                            'Not yet verified, please complete',
                          ),
                          style: GoogleFonts.cairo(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: .0),
                        child: Text(
                          AppTranslations.getText(
                            context,
                            'Steps to complete orders',
                          ),
                          style: GoogleFonts.cairo(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 45.h),
            CustomStepper(currentStep: 1),
            SizedBox(height: 110.h),
            Text(
              AppTranslations.getText(context, 'Identity Information'),
              style: GoogleFonts.cairo(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: branding.primaryText,
              ),
            ),
            SizedBox(height: 260.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => lodedfile()),
                );
              },
              child: Container(
                height: 60.h,
                width: 245.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: branding.buttonBg,
                ),
                child: Center(
                  child: Text(
                    AppTranslations.getText(context, 'next'),
                    style: GoogleFonts.cairo(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
