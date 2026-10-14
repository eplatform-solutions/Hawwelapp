import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/technical_support/technicle_support.dart';

class paidmore extends StatelessWidget {
  const paidmore({super.key, required this.paidless, required this.symbol});
  final String paidless;
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
              top: 260.h,
              right: 25.w,
              child: Text(
                AppTranslations.getText(context, "you’ve paid"),
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  color: branding.buttonText,
                ),
              ),
            ),
            Positioned(
              top: 300.h,
              right: 25.w,
              left: 25.w,
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  Container(
                    width: 150.w,
                    height: 65.h,
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
                        "$paidless $symbol",
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
              top: 480.h,
              right: 20.w,
              left: 20.w,
              child: Text(
                AppTranslations.getText(
                  context,

                  "The balance paid is insufficient2",
                ),
                style: GoogleFonts.cairo(
                  fontSize: isArabic ? 20.sp : 22.sp,
                  fontWeight: FontWeight.w600,
                  color: branding.buttonText,
                ),
              ),
            ),
            Positioned(
              top: 530.h,
              right: 20.w,
              left: isArabic ? 20.w : 20.w,
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
                        fontSize: isArabic ? 20.sp : 18.sp,
                        fontWeight: FontWeight.w600,
                        color: branding.iconPrimary,

                        decorationColor: branding.iconPrimary,
                      ),
                    ),
                    Container(width: 250, height: 2, color: branding.iconPrimary),
                  ],
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
