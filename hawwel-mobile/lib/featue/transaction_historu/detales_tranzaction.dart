import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/localization/lang_cubit.dart';
import 'package:usdt/constans/app_branding.dart';

class Detalestranzation extends StatelessWidget {
  final String currency;
  final double amount;
  final bool isReceived; // ✅ true = استلام، false = إرسال

  const Detalestranzation({
    super.key,
    required this.currency,
    required this.amount,
    required this.isReceived,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    // ✅ إعدادات حسب نوع العملية
    final bool isNegative = !isReceived;
    final Color amountColor = isReceived
        ? branding.link
        : branding.iconPrimary;
    final String sign = isReceived ? '+' : '-';
    final String statusText = isReceived
        ? AppTranslations.getText(context, 'Received')
        : AppTranslations.getText(context, 'It was sent');
    final String fromToText = isReceived
        ? AppTranslations.getText(context, 'Receipt from')
        : AppTranslations.getText(context, 'Send to');
    final String iconPath = isReceived ? AppImages.ricive : AppImages.send;
    final bool isArabic =
        context.watch<LanguageCubit>().state == Language.arabic;
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: Column(
          children: [
            SizedBox(height: 60.h),
            // 🔹 العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  currency == 'USDC' ? AppImages.usdc : AppImages.usdt,
                  height: 30.h,
                  width: 30.w,
                ),
                SizedBox(width: 6.w),
                Text(
                  '$currency Coin',
                  style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: branding.secondaryText,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

       
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$sign${amount.toStringAsFixed(1)} ',
                  style: GoogleFonts.cairo(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  currency,
                  style: GoogleFonts.cairo(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: branding.primaryText,
                  ),
                ),
              ],
            ),

            // 🔹 الحالة (تم إرساله / تم استلامه)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.check,
                  color: branding.badge,
                  height: 20.h,
                  width: 20.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  statusText,
                  style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: branding.badge,
                  ),
                ),
              ],
            ),

            SizedBox(height: 100.h),

            // 🔹 البريد والاتجاه
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ahmad@gmail.com ',
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: branding.secondaryText,
                    ),
                  ),
                  SizedBox(width: 60.w),
                  Text(
                    fromToText,
                    style: GoogleFonts.cairo(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: branding.primaryText,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 100.h),

            // 🔹 زر الحفظ
            Row(
              children: [
                
                Container(
                  height: 60.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: branding.badge,
                  ),
                  child: Center(
                    child: Text(
                      AppTranslations.getText(context, 'Saving information'),
                      style: GoogleFonts.cairo(
                        color: branding.buttonText,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.h),

            // 🔹 فاصل
            Container(
              height: 2.h,
              width: double.infinity,
              color: branding.primaryText,
            ),

            // 🔹 تفاصيل الوقت
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 0.w),
                  Text(
                    '2025/11/06 16:50:05',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: branding.primaryText,
                    ),
                  ),
                  SizedBox(width: 90.w),
                  Text(
                    AppTranslations.getText(context, 'Created'),
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: branding.primaryText,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 الطلب المرجعي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '2025110613441219864294',
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: branding.primaryText,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Text(
                    AppTranslations.getText(context, 'Reference request'),
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: branding.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  
