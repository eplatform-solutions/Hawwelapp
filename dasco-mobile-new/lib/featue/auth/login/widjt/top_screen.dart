import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';

class GradientHeader extends StatelessWidget {
  final String title; // النص الديناميكي
  final String? topLeftImage; // مطلوبة لإظهار زر العودة؛ تُستخدم كصورة بديلة فقط عند useModernBackButton = false
  final double v;
  final double h;
  final bool useModernBackButton;
  /// عند تمريره يُستدعى بدل [Navigator.pop] عند الضغط على زر الرجوع.
  final VoidCallback? onLeadingTap;
  const GradientHeader({
    super.key,
    required this.v,
    required this.h,
    required this.title,
    this.topLeftImage,
    this.useModernBackButton = true,
    this.onLeadingTap,
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
          height: 200.h,
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
            top: 44.h,
            left: isArabic ? null : 8.w,
            right: isArabic ? 8.w : null,
            child: useModernBackButton
                ? AppBackButton(
                    onTap: onLeadingTap,
                    color: branding.buttonText,
                  )
                : GestureDetector(
                    onTap: onLeadingTap ?? () => Navigator.maybePop(context),
                    child: Image.asset(
                      topLeftImage!,
                      height: 28.h,
                      width: 28.w,
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
