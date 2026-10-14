import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final Color? color;
  final IconData? statusIcon;
  final Color? statusIconColor;
  final Color? statusIconBgColor;
  final VoidCallback? onTap;
  final bool isRead;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    this.color,
    this.statusIcon,
    this.statusIconColor,
    this.statusIconBgColor,
    this.onTap,
    this.isRead = true,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final accentColor = color ?? branding.divider;
    final icon = statusIcon ?? Icons.info_rounded;
    final iconColor = statusIconColor ?? accentColor;
    final iconBgColor =
        statusIconBgColor ?? accentColor.withValues(alpha: 0.12);
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: branding.cardBg,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Colored left accent bar ────────────────────
                    Container(
                      width: 4.w,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.r),
                          bottomLeft: Radius.circular(18.r),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // ── Status icon ────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor, size: 22.sp),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // ── Content ────────────────────────────────────
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                if (!isRead) ...[
                                  Container(
                                    width: 7.w,
                                    height: 7.w,
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                ],
                                Expanded(
                                  child: Text(
                                    title,
                                    style: GoogleFonts.cairo(
                                      fontSize: 13.sp,
                                      fontWeight: isRead
                                          ? FontWeight.w600
                                          : FontWeight.w800,
                                      color: branding.primaryText,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (body.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cairo(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: branding.secondaryText,
                                  height: 1.4,
                                ),
                              ),
                            ],
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 11.sp,
                                  color: branding.hintText,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  time,
                                  style: GoogleFonts.cairo(
                                    fontSize: 10.sp,
                                    color: branding.hintText,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // ── Chevron ────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20.sp,
                        color: branding.hintText.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
