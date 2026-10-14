import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';

/// بطاقة "أنت ترسل" — قيمة ثابتة للعرض فقط
class Trsletastkbl2 extends StatelessWidget {
  final String text1; // label  e.g. "أنت ترسل"
  final String text2; // symbol e.g. "USDT"
  final String text3; // amount e.g. "120.00"

  const Trsletastkbl2({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;

    return Container(
      width: 148.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: branding.cardBg,
        border: Border.all(color: branding.accent.withOpacity(0.2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label row
          Row(
            children: [
              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: branding.accent,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  text1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: branding.secondaryText,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Amount + symbol
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  text3.isEmpty ? '0.00' : text3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: branding.primaryText,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  text2,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: branding.accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}