import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/app_branding.dart';

class TransactionItem extends StatelessWidget {
  final String amount;
  final String currency;
  final String usdAmount;
  final String actionText;
  final String iconPath;
  final Color? amountColor;
  final bool isChecked;
  final String imagePath;

  const TransactionItem({
    super.key,
    required this.amount,
    required this.currency,
    required this.usdAmount,
    required this.actionText,
    required this.iconPath,
    required this.imagePath,
    this.amountColor,
    this.isChecked = true,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final effectiveAmountColor = amountColor ?? branding.iconPrimary;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
        
          Row(
            children: [
             
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        amount,
                        style: GoogleFonts.cairo(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: effectiveAmountColor,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        currency,
                        style: GoogleFonts.cairo(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.primaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        usdAmount,
                        style: GoogleFonts.cairo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.primaryText,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      if (isChecked)
                        Image.asset(AppImages.check, height: 18.h, width: 18.w),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // النص والأيقونة على اليمين
              Text(
                actionText,
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: branding.primaryText,
                ),
              ),
              SizedBox(width: 10.w),

              // الكونتينر الرمادي
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 42.h,
                    width: 42.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: branding.divider,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(iconPath),
                    ),
                  ),

                  // 🪙 صورة العملة فوق الكونتينر الرمادي
                  Positioned(
                    top: 30.h,
                    right: -5.w,
                    child: Image.asset(imagePath, height: 28.h, width: 28.w),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
