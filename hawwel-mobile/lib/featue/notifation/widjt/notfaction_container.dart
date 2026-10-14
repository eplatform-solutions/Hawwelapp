import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final Color? color;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    this.color,
    this.onTap,
  });

  // icon + background based on status color
  _StatusStyle _resolveStyle(AppBrandingConfig branding) {
    final c = color ?? branding.divider;
    final isGreen = c == branding.gradientEndColorValue;
    final isRed = c == branding.iconPrimary;

    if (isGreen) {
      return _StatusStyle(
        icon: Icons.check_circle_rounded,
        iconColor: const Color(0xFF22C55E),
        bgColor: const Color(0xFF22C55E).withValues(alpha: 0.1),
        accentColor: const Color(0xFF22C55E),
      );
    } else if (isRed) {
      return _StatusStyle(
        icon: Icons.cancel_rounded,
        iconColor: const Color(0xFFEF4444),
        bgColor: const Color(0xFFEF4444).withValues(alpha: 0.1),
        accentColor: const Color(0xFFEF4444),
      );
    } else {
      return _StatusStyle(
        icon: Icons.info_rounded,
        iconColor: const Color(0xFFF59E0B),
        bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
        accentColor: const Color(0xFFF59E0B),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final style = _resolveStyle(branding);
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
                  color: style.accentColor.withValues(alpha: 0.2),
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
                        color: style.accentColor,
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
                          color: style.bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          style.icon,
                          color: style.iconColor,
                          size: 22.sp,
                        ),
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
                            Text(
                              title,
                              style: GoogleFonts.cairo(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: branding.primaryText,
                                height: 1.3,
                              ),
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

class _StatusStyle {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color accentColor;
  const _StatusStyle({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.accentColor,
  });
}