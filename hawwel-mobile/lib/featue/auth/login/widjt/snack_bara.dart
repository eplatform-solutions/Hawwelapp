import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawwel/constans/app_branding.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;
  final String imagePath;

  final Color backgroundColor;
  final TextDirection? textDirection;
  const CustomSnackBar({
    super.key,
    this.textDirection,
    required this.message,
    required this.imagePath,

    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: branding.primaryText.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 20.h,
                width: 20.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  message,
                  textDirection: textDirection,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: branding.primaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
