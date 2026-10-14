import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:usdt/constans/app_branding.dart';

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
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.w),
        child: Container(
          height: 45.h,
          width: 320.w,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14.r),

            boxShadow: [
              BoxShadow(
                color: branding.primaryText.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isArabic
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        imagePath,
                        height: 20.h,
                        width: 20.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        textDirection: textDirection,
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: branding.primaryText,
                        ),
                      ),
                      //SizedBox(width: 10.w),
                      // Image.asset(
                      //   imagePath,
                      //   height: 20.h,
                      //   width: 20.w,
                      //   fit: BoxFit.contain,
                      // ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10.w),
                      Image.asset(
                        imagePath,
                        height: 20.h,
                        width: 20.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        textDirection: textDirection,
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: branding.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
