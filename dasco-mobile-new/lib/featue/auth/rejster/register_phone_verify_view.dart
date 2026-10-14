import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/digit_utils.dart';
import 'package:hawwel/constans/localization/app_locale.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/otp/widjt/top_screen.dart';
import 'package:hawwel/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
import 'package:hawwel/featue/auth/rejster/data/cubit/regster_cubut.dart';
import 'package:hawwel/featue/bootom_navigator.dart';

/// شاشة إدخال رمز التحقق المرسل للجوال بعد الضغط على «سجل الآن» في التسجيل.
class RegisterPhoneVerifyView extends StatefulWidget {
  const RegisterPhoneVerifyView({super.key});

  @override
  State<RegisterPhoneVerifyView> createState() =>
      _RegisterPhoneVerifyViewState();
}

class _RegisterPhoneVerifyViewState extends State<RegisterPhoneVerifyView> {
  bool _resendLocked = false;
  int _secondsRemaining = 60;
  Timer? _timer;

  String _normalizedPhone(RegisterCubit cubit) {
    final raw = normalizePhoneLikeInput(
      cubit.submittedMobilePhone ?? cubit.phonee.text,
    ).trim();
    if (raw.isEmpty) return '';
    return raw.startsWith('+') ? raw : '+$raw';
  }

  String _extractCountryCode(String normalizedPhone) {
    if (normalizedPhone.isEmpty) return '+966';
    final digits = normalizeAuthDigits(
      normalizedPhone,
    ).replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '+966';
    if (digits.length <= 9) return '+$digits';
    final countryCode = digits.substring(0, digits.length - 9);
    return '+$countryCode';
  }

  String _extractLocalPhone(String normalizedPhone) {
    if (normalizedPhone.isEmpty) return '';
    final digits = normalizeAuthDigits(
      normalizedPhone,
    ).replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length <= 9) return digits;
    return digits.substring(digits.length - 9);
  }

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
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listenWhen: (prev, curr) {
            if (curr is RegisterOTPSent) return prev is RegisterOTPLoading;
            return true;
          },
          listener: (context, state) async {
            if (state is RegisterSuccess) {
              final token = await Functions().getToken();
              if (!context.mounted) return;
              if (token == null || token.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    content: CustomSnackBar(
                      backgroundColor: branding.error,
                      message: AppTranslations.getTextStatic(
                        context,
                        'session_start_failed',
                      ),
                      imagePath: AppImages.eerorrimage,
                    ),
                  ),
                );
                return;
              }
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
              final message = AppLocaleHelper.isPhoneAlreadyRegisteredMessage(
                    state.error,
                  )
                  ? AppTranslations.getText(
                      context,
                      'phone_already_registered',
                    )
                  : state.error;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  content: CustomSnackBar(
                    backgroundColor: branding.error,
                    message: message,
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
            final fullPhone = _normalizedPhone(cubit);
            final countryCode = _extractCountryCode(fullPhone);
            final localPhone = _extractLocalPhone(fullPhone);
            return Form(
              child: Column(
                children: [
                  GradientHeader2(
                    title: AppTranslations.getText(
                      context,
                      'confirm_mobile_title',
                    ),
                    topLeftImage: AppImages.iconback,
                    v: 78,
                    headerHeight: 205,
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
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: branding.cardBg,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: branding.iconPrimary.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: branding.iconPrimary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    countryCode,
                                    style: GoogleFonts.cairo(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: branding.iconPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  localPhone.isNotEmpty ? localPhone : fullPhone,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.ltr,
                                  style: GoogleFonts.cairo(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: branding.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: PinCodeTextField(
                            appContext: context,
                            length: 4,
                            controller: cubit.otpphone,
                            keyboardType: TextInputType.number,
                            autoDisposeControllers: false,
                            autoDismissKeyboard: true,
                            animationType: AnimationType.fade,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            textStyle: GoogleFonts.cairo(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.primaryText,
                            ),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(14.r),
                              fieldHeight: 58.h,
                              fieldWidth: 58.w,
                              borderWidth: 1.7,
                              inactiveColor: branding.iconPrimary.withValues(
                                alpha: 0.35,
                              ),
                              selectedColor: branding.iconPrimary,
                              activeColor: branding.iconPrimary,
                              inactiveFillColor: branding.inputBorder,
                              selectedFillColor: branding.inputBorder
                                  .withValues(alpha: 0.9),
                              activeFillColor: branding.inputBorder
                                  .withValues(alpha: 0.95),
                            ),
                            enableActiveFill: true,
                            cursorColor: branding.iconPrimary,
                            animationDuration: const Duration(milliseconds: 200),
                            backgroundColor: Colors.transparent,
                            onChanged: (value) {
                              final normalized = normalizeAuthDigits(value);
                              if (normalized != value) {
                                cubit.otpphone.value = TextEditingValue(
                                  text: normalized,
                                  selection: TextSelection.collapsed(
                                    offset: normalized.length,
                                  ),
                                );
                              }
                            },
                          ),
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
                                    final otp = normalizeAuthDigits(
                                      cubit.otpphone.text,
                                    ).trim();
                                    cubit.otpphone.value = TextEditingValue(
                                      text: otp,
                                      selection: TextSelection.collapsed(
                                        offset: otp.length,
                                      ),
                                    );
                                    if (otp.length != 4) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsets.zero,
                                          content: CustomSnackBar(
                                            backgroundColor: branding.error,
                                            message: AppTranslations.getText(
                                              context,
                                              'enter_otp',
                                            ),
                                            imagePath: AppImages.eerorrimage,
                                          ),
                                        ),
                                      );
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
