import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/falidator.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/style.dart';
import 'package:hawwel/featue/paymant/review_transaction.dart';
import 'package:hawwel/featue/paymant/widgt/text_fild_payment.dart';

class Improvepament extends StatefulWidget {
  const Improvepament({super.key});

  @override
  State<Improvepament> createState() => _ImprovepamentState();
}

class _ImprovepamentState extends State<Improvepament> {
  TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;
    return SafeArea(
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,

        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 64.h),
                    child: Text(
                      AppTranslations.getText(context, 'payment'),
                      style: GoogleFonts.cairo(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: branding.primaryText,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  AppTranslations.getText(context, 'confirm_payment_details'),
                  style: GoogleFonts.cairo(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: branding.secondaryText,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 30.h,
                  ),
                  child: TextFieldCustompayment(
                    validator: (value) => validateFullName(value, context),
                    controller: username,
                    hintText: AppTranslations.getText(
                      context,
                      'phone_or_name_hint',
                    ),
                    type: TextInputType.name,
                    // maxLength: 10,
                    suffix: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        AppImages.search,
                        color: branding.hintText,
                      ),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(AppImages.paymant),
                    ),
                    hintStyle: AppStyle.meduim16grey,
                    obscureText: false,
                    readOnly: false,
                  ),
                ),
                Text(
                  AppTranslations.getText(
                    context,
                    'Enter your beneficiary information',
                  ),
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: branding.primaryText,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  AppTranslations.getText(
                    context,
                    'Write, paste for your transaction',
                  ),
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: branding.secondaryText,
                  ),
                ),
                SizedBox(height: 380.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Reviewtranzation(),
                      ),
                    );
                  },
                  child: Container(
                    height: 58.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: branding.buttonBg,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: const Color(0xFFB9A779).withOpacity(0.5),
                      //     spreadRadius: 1,
                      //     blurRadius: 8,
                      //     offset: const Offset(0, 3),
                      //   ),
                      // ],
                    ),
                    child: Center(
                      child: Text(
                        AppTranslations.getText(context, 'send'),
                        style: GoogleFonts.cairo(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: branding.buttonText,
                        ),
                      ),
                    ),
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
