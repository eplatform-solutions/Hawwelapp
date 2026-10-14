import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';

class GradientHeader extends StatelessWidget {
  final String title; // النص الديناميكي
  final String? topLeftImage; // الصورة الاختيارية
  final double v;
  final double h;
  const GradientHeader({
    super.key,
    required this.v,
    required this.h,
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
          width: double.infinity,
          height: 280.h,
          decoration: headerDecoration,
        ),

        // ✅ النص في منتصف الجزء السفلي تقريبًا
        Positioned(
          // top: 120.h,
          // right:ww,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: h.w, vertical: v.h),
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

        // ✅ الصورة في الأعلى يسار (تظهر فقط عند التمرير)
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
        if (branding.logoUrl.isNotEmpty)
          Positioned(
            top: 12.h,
            right: 12.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                branding.logoUrl,
                width: 46.w,
                height: 46.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}
