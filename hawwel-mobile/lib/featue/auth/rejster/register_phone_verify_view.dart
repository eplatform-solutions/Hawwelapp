import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/falidator.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/style.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/login/widjt/textfildlogin.dart';
import 'package:usdt/featue/auth/otp/widjt/top_screen.dart';
import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubut.dart';
import 'package:usdt/featue/bootom_navigator.dart';

/// شاشة إدخال رمز التحقق المرسل للجوال بعد الضغط على «سجل الآن» في التسجيل.
class RegisterPhoneVerifyView extends StatefulWidget {
  const RegisterPhoneVerifyView({super.key});

  @override
  State<RegisterPhoneVerifyView> createState() =>
      _RegisterPhoneVerifyViewState();
}

class _RegisterPhoneVerifyViewState extends State<RegisterPhoneVerifyView> {
  final _formKey = GlobalKey<FormState>();
  bool _resendLocked = false;
  int _secondsRemaining = 60;
  Timer? _timer;

  void _startResendCooldown() {
    setState(() {
      _resendLocked = true;
      _secondsRemaining = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        t.cancel();
        setState(() => _resendLocked = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startResendCooldown();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final cubit = context.read<RegisterCubit>();

    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listenWhen: (prev, curr) {
            if (curr is RegisterOTPSent) return prev is RegisterOTPLoading;
            return true;
          },
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
            if (state is RegisterError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  content: CustomSnackBar(
                    backgroundColor: branding.error,
                    message: state.error,
                    imagePath: AppImages.eerorrimage,
                  ),
                ),
              );
            }
            if (state is RegisterOTPError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  content: CustomSnackBar(
                    backgroundColor: branding.error,
                    message: state.error,
                    imagePath: AppImages.eerorrimage,
                  ),
                ),
              );
            }
            if (state is RegisterOTPSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  content: CustomSnackBar(
                    backgroundColor: branding.success,
                    message: AppTranslations.getTextStatic(
                      context,
                      'otp_sent_success',
                    ),
                    imagePath: AppImages.doneimage,
                  ),
                ),
              );
              _startResendCooldown();
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  GradientHeader2(
                    title: AppTranslations.getText(
                      context,
                      'confirm_mobile_title',
                    ),
                    topLeftImage: AppImages.backleft,
                    v: 100,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppTranslations.getText(
                              context,
                              'confirm_mobile_subtitle',
                            ),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: branding.secondaryText,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            cubit.phonee.text,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.cairo(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.primaryText,
                            ),
                          ),
                          SizedBox(height: 28.h),
                          TextFieldCustom(
                            validator: (value) =>
                                valedatotp(value, context),
                            controller: cubit.otpphone,
                            hintText: AppTranslations.getText(
                              context,
                              'enter_otp',
                            ),
                            type: TextInputType.number,
                            hintStyle: AppStyle.meduim16grey,
                          ),
                          SizedBox(height: 20.h),
                          if (_resendLocked)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: branding.primaryText,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  isArabic
                                      ? '${AppTranslations.getText(context, 'Resend after')}$_secondsRemaining${AppTranslations.getText(context, 'seconds')}'
                                      : '$_secondsRemaining ${AppTranslations.getText(context, 'seconds')}',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: branding.secondaryText,
                                  ),
                                ),
                              ],
                            )
                          else
                            GestureDetector(
                              onTap: state is RegisterOTPLoading
                                  ? null
                                  : () async {
                                      await cubit.sendOtpphone();
                                    },
                              child: Text(
                                AppTranslations.getText(context, 'otp'),
                                style: GoogleFonts.cairo(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: branding.buttonBg,
                                ),
                              ),
                            ),
                          SizedBox(height: 36.h),
                          GestureDetector(
                            onTap: state is RegisterLoading
                                ? null
                                : () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    cubit.register();
                                  },
                            child: Container(
                              height: 60.h,
                              width: 245.w,
                              decoration: branding.buildButtonDecoration(
                                radius: 30,
                              ),
                              child: state is RegisterLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        AppTranslations.getText(
                                          context,
                                          'confirm_registration',
                                        ),
                                        style: GoogleFonts.cairo(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
