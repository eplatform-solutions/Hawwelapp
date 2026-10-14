import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/technical_support/technicle_support.dart';

class statepademor extends StatelessWidget {
  const statepademor({
    super.key,
    required this.exstaamount,
    required this.symbol,
  });
  final String exstaamount;
  final String symbol;
  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [branding.link, branding.success, branding.success],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Image.asset("asset/Ellipse 5 (2).png"),
            Positioned(
              top: 250.h,
              right: 0.w,
              left: 10.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: isArabic ? 8.w : 0),
                    child: Text(
                      AppTranslations.getText(
                        context,
                        "you’ve sent an extra amount of the transfer amount.",
                      ),
                      style: GoogleFonts.cairo(
                        fontSize: isArabic ? 18.sp : 18.sp,
                        color: branding.buttonText,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      AppTranslations.getText(
                        context,
                        "extra amount of the transfer balance.",
                      ),
                      style: GoogleFonts.cairo(
                        fontSize: isArabic ? 18.sp : 18.sp,
                        color: branding.buttonText,
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Container(
                    width: 150.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 6),
                          blurRadius: 12,
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          branding.link,
                          branding.success,
                          branding.success,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "$exstaamount  $symbol",
                        style: GoogleFonts.cairo(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: branding.buttonText,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 50.h),
                  // Text(
                  //   "في حال أردت استرداد الرصيد الزائد ",
                  //   style: GoogleFonts.cairo(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
            ),
            Positioned(
              top: 500.h,
              right: 18.w,
              left: 18.w,
              child: Text(
                AppTranslations.getText(
                  context,
                  "if you want to take back the balance",
                ),
                style: GoogleFonts.cairo(
                  fontSize: isArabic ? 20.sp : 18.sp,
                  fontWeight: FontWeight.w600,
                  color: branding.buttonText,
                ),
              ),
            ),
            Positioned(
              top: 540.h,
              right: 20.w,
              left: 20.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TechniclSupport()),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.getText(
                        context,
                        "Please contact technical support.",
                      ),
                      style: GoogleFonts.cairo(
                        fontSize: isArabic ? 16.sp : 16.sp,
                        fontWeight: FontWeight.w600,
                        color: branding.iconPrimary,
                      ),
                    ),
                    Container(
                      height: 1.5,
                      width: isArabic ? 200.w : 230.w,
                      color: branding.iconPrimary,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 600.h,
              right: 18.w,
              left: 18.w,
              child: Row(
                children: [
                  Image.asset(
                    "asset/image 11 (1).png",
                    height: 20.h,
                    width: 20.w,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    AppTranslations.getText(
                      context,
                      "The balance cannot be refunded if it is",
                    ),
                    style: GoogleFonts.cairo(
                      fontSize: isArabic ? 18.sp : 16.sp,
                      fontWeight: FontWeight.w600,
                      color: branding.buttonText,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 630.h,
              right: 48.w,
              left: 48.w,
              child: Text(
                AppTranslations.getText(context, "Balance less than 1"),
                style: GoogleFonts.cairo(
                  fontSize: isArabic ? 18.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: branding.buttonText,
                ),
              ),
            ),
            // Positioned(top: 600.h, child: Image.asset("asset.image 11.png")),
          ],
        ),
      ),
    );
  }
}
