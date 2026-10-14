import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:hawwel/featue/spend_mouny/widjt/spenf_text_fild.dart';

class Spendmouny extends StatefulWidget {
  const Spendmouny({super.key});

  @override
  State<Spendmouny> createState() => _SpendmounyState();
}

class _SpendmounyState extends State<Spendmouny> {
  String selectedCurrency = 'USDT';
  bool showDropdown = false;
  final List<String> currencies = ['USDT', 'USDC'];
  TextEditingController yourController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final selectedDisplayCurrency = SendCurrencyHelper.displayLabelForSymbol(
      selectedCurrency,
      isArabic: isArabic,
    );
    final alternateCurrency = selectedCurrency == 'USDT' ? 'USDC' : 'USDT';
    final alternateDisplayCurrency = SendCurrencyHelper.displayLabelForSymbol(
      alternateCurrency,
      isArabic: isArabic,
    );

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.badge,
        resizeToAvoidBottomInset:
            true, // ✅ خلي الصفحة تتأقلم مع الكيبورد وتسكرول
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: branding.badge,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 100.0.w,
                  vertical: 70.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppTranslations.getText(context, 'deposit_money'),
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: branding.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🔹 المحتوى القابل للسكرول
            Positioned(
              top: 140.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 800.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      AppTranslations.getText(context, 'select_currency'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                        color: branding.primaryText,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 8.0,
                            color: branding.accent,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35.h),
                    Container(
                      height: 75.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: branding.accent,
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 15.w),
                          SendCurrencyHelper.buildCoinIcon(
                            symbol: selectedCurrency,
                            height: 40.h,
                            width: 40.w,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                selectedDisplayCurrency,
                                style: GoogleFonts.cairo(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: branding.primaryText,
                                ),
                              ),
                              Text(
                                alternateDisplayCurrency,
                                style: GoogleFonts.cairo(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: branding.hintText,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showDropdown = !showDropdown;
                              });
                            },
                            child: Image.asset(
                              AppImages.iconcountry,
                              height: 20.h,
                              width: 20.w,
                            ),
                          ),
                          SizedBox(width: 15.w),
                        ],
                      ),
                    ),
                    if (showDropdown)
                      Container(
                        width: 300.w,
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: branding.accent.withValues(alpha: 0.6),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: currencies.map((currency) {
                            final displayLabel =
                                SendCurrencyHelper.displayLabelForSymbol(
                              currency,
                              isArabic: isArabic,
                            );
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCurrency = currency;
                                  showDropdown = false;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Text(
                                  displayLabel,
                                  style: GoogleFonts.cairo(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: selectedCurrency == currency
                                        ? branding.primaryText
                                        : branding.hintText,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Row(
                        // mainAxisAlignment: isArabic
                        //     ? MainAxisAlignment.end
                        //     : MainAxisAlignment.end,
                        children: [
                          Text(
                            AppTranslations.getText(context, "select_network"),
                            style: GoogleFonts.cairo(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 46.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: branding.iconPrimary,
                              ),
                              color: branding.hintText,
                            ),
                            child: Center(
                              child: Text(
                                'Polygon',
                                style: GoogleFonts.cairo(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: branding.primaryText,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Container(
                            height: 46.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: branding.iconPrimary,
                              ),
                              color: branding.inputBorder,
                            ),
                            child: Center(
                              child: Text(
                                'BEP20',
                                style: GoogleFonts.cairo(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: branding.primaryText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Row(
                        // mainAxisAlignment: isArabic
                        //     ? MainAxisAlignment.end
                        //     : MainAxisAlignment.end,
                        children: [
                          //  SizedBox(width: 270.w),
                          Text(
                            AppTranslations.getText(context, 'payment_instructions'),
                            style: GoogleFonts.cairo(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.0.w,
                        vertical: 16.h,
                      ),
                      child: TextFieldCustomspeand(
                        controller: yourController,
                        hintText: '',
                        readOnly: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
