import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/app_branding.dart';

class TransactionViaItem extends StatelessWidget {
  final String amount;
  final String currency;
  final String usdAmount;
  final String actionText;
  final String iconPath;
  final Color? amountColor;
  final bool isChecked;
  final String imagePath;
  final String brokerLogo;
  final String brokerName;

  const TransactionViaItem({
    super.key,
    required this.amount,
    required this.currency,
    required this.usdAmount,
    required this.actionText,
    required this.iconPath,
    required this.imagePath,
    required this.brokerLogo,
    required this.brokerName,
    this.amountColor,
    this.isChecked = true,
  });
  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final effectiveAmountColor = amountColor ?? branding.iconPrimary;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    if (isChecked)
                      Image.asset(AppImages.check, height: 15.h, width: 15.w),
                    Text(
                      "\$$usdAmount",
                      style: GoogleFonts.cairo(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: branding.primaryText,
                      ),
                    ),
                    // SizedBox(width: 5.w),
                    // if (isChecked)
                    //   Image.asset(AppImages.check, height: 18.h, width: 18.w),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    actionText,
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: branding.primaryText,
                    ),
                  ),
                  SizedBox(width: 6.w),
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
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(iconPath),
                        ),
                      ),
                      Positioned(
                        top: 28.h,
                        right: -5.w,
                        child: Image.asset(
                          imagePath,
                          height: 22.h,
                          width: 22.w,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.network(
                    //   getImageUrl(brokerLogo),
                    //   height: 20.h,
                    //   width: 30.w,
                    //   fit: BoxFit.contain,
                    // ),
                    if (brokerLogo.isNotEmpty)
                      Image.network(
                        ApiService.resolveAssetUrl(brokerLogo),
                        height: 20.h,
                        width: 30.w,
                        fit: BoxFit.contain,
                        // حل مشكلة الـ 404: إذا فشل التحميل لا يعرض شيئاً
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    //  SizedBox(width: 0.w),
                    Padding(
                      padding: EdgeInsets.only(
                        left: isArabic ? 0 : 55.w,
                        right: isArabic ? 40.w : 0,
                      ),
                      child: Text(
                        brokerName,
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: branding.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
