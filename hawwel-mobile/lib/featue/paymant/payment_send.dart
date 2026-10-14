import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/paymant/improve_paymant.dart';

class Paymentsend extends StatefulWidget {
  const Paymentsend({super.key});

  @override
  State<Paymentsend> createState() => _PaymentsendState();
}

class _PaymentsendState extends State<Paymentsend> {
  bool _isEditing = false;
  String _amount = '';

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 80.h),
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
              AppTranslations.getText(context, 'enter_amount_to_send'),
              style: GoogleFonts.cairo(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: branding.secondaryText,
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              AppTranslations.getText(context, 'sending'),
              style: GoogleFonts.cairo(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: branding.badge,
              ),
            ),
            SizedBox(height: 30.h),
            Container(
              height: 45.h,
              width: 140.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: branding.badge,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.usdt, height: 20.h, width: 20.w),
                  SizedBox(width: 8.w),
                  Text(
                    'USDC',
                    style: GoogleFonts.cairo(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Image.asset(
                    AppImages.cercl,
                    height: 16.h,
                    width: 16.w,
                    color: branding.primaryText,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),

            // 🟢 نفس تصميمك القديم مع تصحيح overflow
            Container(
              height: 150.h,
              width: 300.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [branding.accent, branding.link],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: branding.cardBg,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                              child: _isEditing
                                  ? TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _amount = value;
                                        });
                                      },
                                      onSubmitted: (_) {
                                        setState(() {
                                          _isEditing = false;
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: '',
                                        border: InputBorder.none,
                                      ),
                                      style: GoogleFonts.cairo(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      autofocus: true,
                                    )
                                  : Row(
                                      children: [
                                        // ✅ Expanded + FittedBox لمنع الخطأ بالعرض
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  _amount.isEmpty
                                                      ? '0'
                                                      : _amount,
                                                  style: GoogleFonts.cairo(
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: branding.primaryText,
                                                  ),
                                                ),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  'USDC',
                                                  style: GoogleFonts.cairo(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: branding.primaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Image.asset(
                                          'asset/Vector (53).png',
                                          height: 20.h,
                                          width: 20.w,
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.swap_vert,
                                  size: 16.sp,
                                  color: branding.link,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '\$${_amount.isEmpty ? "0" : _amount}',
                                  style: GoogleFonts.cairo(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: branding.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 280.h),

            GestureDetector(
              onTap: () {
                if (_amount.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Improvepament()),
                  );
                }
              },
              child: Container(
                height: 58.h,
                width: 300.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: branding.buttonBg,
                ),
                child: Center(
                  child: Text(
                    AppTranslations.getText(context, 'next'),
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
    );
  }
}
