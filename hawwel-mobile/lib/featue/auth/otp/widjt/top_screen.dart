import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';

class GradientHeader2 extends StatelessWidget {
  final String title; // النص الديناميكي
  final String? topLeftImage;

  final double v; // الصورة الاختيارية

  const GradientHeader2({
    super.key,
    required this.v,

    required this.title,
    this.topLeftImage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;
    final Decoration headerDecoration;
    if (branding.themeMode == 'solid') {
      headerDecoration = BoxDecoration(
        color: branding.solidBackgroundColorValue,
        borderRadius: BorderRadius.circular(20),
      );
    } else if (branding.themeMode == 'image' &&
        branding.backgroundImageUrl.isNotEmpty) {
      headerDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(branding.backgroundImageUrl),
          fit: BoxFit.cover,
        ),
      );
    } else {
      headerDecoration = BoxDecoration(
        gradient: branding.buildHeaderGradient(),
        borderRadius: BorderRadius.circular(20),
      );
    }

    return Stack(
      children: [
        // Applies selected global identity mode (solid/gradient/image).
        Container(
          width: 380.w,
          height: 260.h,
          decoration: headerDecoration,
        ),

        if (topLeftImage != null)
          Positioned(
            top: 50.h,
            left: 5.w,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                topLeftImage!,
                height: 30.h,
                width: 30.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        Positioned(
          // top: 120.h,
          // right: 170.w,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: v.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    color: branding.textColorValue,
                    fontWeight: FontWeight.w700,
                    fontSize: isArabic ? 18.sp : 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
