import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';

class Trsletastkbl3 extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final bool isEditable;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const Trsletastkbl3({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
    this.isEditable = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;

    return Container(
      width: 148.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            branding.accent.withValues(alpha: 0.18),
            branding.accent.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: branding.accent.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: branding.accent.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 5),
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
                  gradient: branding.buildHeaderGradient(),
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
                    color: branding.accent,
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
                child: isEditable
                    ? TextField(
                        controller: controller,
                        onChanged: onChanged,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: GoogleFonts.cairo(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w300,
                            color: branding.accent.withValues(alpha: 0.4),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: GoogleFonts.cairo(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: branding.accent,
                          height: 1.1,
                        ),
                      )
                    : Text(
                        text3.isEmpty ? '0.00' : text3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: branding.accent,
                          height: 1.1,
                        ),
                      ),
              ),
              SizedBox(width: 4.w),
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    gradient: branding.buildHeaderGradient(),
                  ),
                  child: Text(
                    text2,
                    style: GoogleFonts.cairo(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: branding.buttonText,
                    ),
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