// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/digit_utils.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
import 'package:hawwel/featue/auth/rejster/data/cubit/regster_cubut.dart';
import 'package:hawwel/featue/bootom_navigator.dart';

class OtpTwofactorauthentication extends StatefulWidget {
  final String email;
  final String session;

  const OtpTwofactorauthentication({
    super.key,
    required this.email,
    required this.session,
  });

  @override
  State<OtpTwofactorauthentication> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<OtpTwofactorauthentication> {
  bool isResendClicked = false;
  int secondsRemaining = 60;
  Timer? timer;
  final TextEditingController otpfactor = TextEditingController();

  @override
  void dispose() {
    otpfactor.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      isResendClicked = true;
      secondsRemaining = 60;
    });
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
      } else {
        t.cancel();
        setState(() => isResendClicked = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterOTPVerified) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
              );
            }
            if (state is RegisterOTPError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: branding.error.withValues(alpha: 0.9),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  content: Text(state.error,
                      style: GoogleFonts.cairo(color: Colors.white)),
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // ── Gradient Header ──────────────────────────────────────
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: branding.buildHeaderGradient(),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.r),
                      bottomRight: Radius.circular(32.r),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
                      child: Column(
                        children: [
                          // Back row
                          Row(
                            children: [
                              AppBackButton(),
                              Expanded(
                                child: Text(
                                  AppTranslations.getText(
                                      context, 'Verification'),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: branding.buttonText,
                                  ),
                                ),
                              ),
                              SizedBox(width: 38.r),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          // Shield icon
                          Container(
                            width: 72.r,
                            height: 72.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  branding.buttonText.withValues(alpha: 0.15),
                              border: Border.all(
                                color:
                                    branding.buttonText.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.verified_user_rounded,
                              size: 32,
                              color: branding.buttonText,
                            ),
                          ),

                          SizedBox(height: 14.h),

                          Text(
                            AppTranslations.getText(
                                context, 'enter_verification_code'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color:
                                  branding.buttonText.withValues(alpha: 0.9),
                            ),
                          ),

                          SizedBox(height: 6.h),

                          // Identifier pill (phone number the code went to)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color:
                                  branding.buttonText.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.sms_outlined,
                                    color: branding.buttonText
                                        .withValues(alpha: 0.8),
                                    size: 14),
                                SizedBox(width: 6.w),
                                Text(
                                  widget.email,
                                  style: GoogleFonts.cairo(
                                    fontSize: 12.sp,
                                    color: branding.buttonText
                                        .withValues(alpha: 0.85),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Body ────────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, vertical: 32.h),
                    child: Column(
                      children: [
                        // ── OTP boxes ───────────────────────────────────
                        PinCodeTextField(
                          appContext: context,
                          length: 4,
                          controller: otpfactor,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          animationType: AnimationType.scale,
                          keyboardType: TextInputType.number,
                          textStyle: GoogleFonts.cairo(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: branding.iconPrimary,
                          ),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(14.r),
                            fieldHeight: 58.h,
                            fieldWidth: 58.w,
                            borderWidth: 1.5,
                            inactiveColor:
                                branding.hintText.withValues(alpha: 0.3),
                            activeColor: branding.iconPrimary,
                            selectedColor: branding.iconPrimary,
                            activeFillColor: branding.iconPrimary
                                .withValues(alpha: 0.06),
                            inactiveFillColor:
                                branding.inputBorder.withValues(alpha: 0.5),
                            selectedFillColor: branding.iconPrimary
                                .withValues(alpha: 0.08),
                          ),
                          animationDuration:
                              const Duration(milliseconds: 200),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: (value) {
                            final normalized = normalizeAuthDigits(value);
                            if (normalized != value) {
                              otpfactor.value = TextEditingValue(
                                text: normalized,
                                selection: TextSelection.collapsed(
                                  offset: normalized.length,
                                ),
                              );
                            }
                          },
                          onCompleted: (_) {},
                        ),

                        SizedBox(height: 24.h),

                        // ── Resend row ───────────────────────────────────
                        isResendClicked
                            ? _TimerBadge(
                                seconds: secondsRemaining,
                                branding: branding,
                                isArabic: isArabic,
                                context: context,
                              )
                            : GestureDetector(
                                onTap: () async {
                                  setState(() => isResendClicked = true);
                                  await context
                                      .read<RegisterCubit>()
                                      .sendOtpfactorauthentication(
                                          widget.email);
                                  startTimer();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(50.r),
                                    border: Border.all(
                                      color: branding.iconPrimary
                                          .withValues(alpha: 0.4),
                                    ),
                                    color: branding.iconPrimary
                                        .withValues(alpha: 0.06),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.refresh_rounded,
                                          size: 16,
                                          color: branding.iconPrimary),
                                      SizedBox(width: 6.w),
                                      Text(
                                        AppTranslations.getText(
                                            context, 'resend'),
                                        style: GoogleFonts.cairo(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: branding.iconPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                        SizedBox(height: 40.h),

                        // ── Submit button ────────────────────────────────
                        GestureDetector(
                          onTap: state is RegisterOTPLoading
                              ? null
                              : () {
                                  final normalizedOtp = normalizeAuthDigits(
                                    otpfactor.text,
                                  ).trim();
                                  otpfactor.value = TextEditingValue(
                                    text: normalizedOtp,
                                    selection: TextSelection.collapsed(
                                      offset: normalizedOtp.length,
                                    ),
                                  );
                                  context
                                      .read<RegisterCubit>()
                                      .verifyOtpAndGetSession2(
                                        otp: normalizedOtp,
                                        session: widget.session,
                                      );
                                },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: state is RegisterOTPLoading
                                  ? null
                                  : branding.buildHeaderGradient(),
                              color: state is RegisterOTPLoading
                                  ? branding.hintText.withValues(alpha: 0.4)
                                  : null,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: state is RegisterOTPLoading
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: branding.iconPrimary
                                            .withValues(alpha: 0.3),
                                        blurRadius: 14,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                            ),
                            child: Container(
                              height: 52.h,
                              alignment: Alignment.center,
                              child: state is RegisterOTPLoading
                                  ? SizedBox(
                                      width: 22.r,
                                      height: 22.r,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: branding.buttonText,
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.verified_rounded,
                                            color: branding.buttonText,
                                            size: 20),
                                        SizedBox(width: 8.w),
                                        Text(
                                          AppTranslations.getText(
                                              context, 'submit'),
                                          style: GoogleFonts.cairo(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                            color: branding.buttonText,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Timer badge ──────────────────────────────────────────────────────────────
class _TimerBadge extends StatelessWidget {
  final int seconds;
  final dynamic branding;
  final bool isArabic;
  final BuildContext context;

  const _TimerBadge({
    required this.seconds,
    required this.branding,
    required this.isArabic,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: branding.hintText.withValues(alpha: 0.08),
        border: Border.all(
            color: branding.hintText.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 15, color: branding.hintText),
          SizedBox(width: 6.w),
          Text(
            AppTranslations.getText(
              context,
              'please_resend_after_seconds',
              replacements: {'seconds': seconds.toString()},
            ),
            style: GoogleFonts.cairo(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: branding.hintText,
            ),
          ),
        ],
      ),
    );
  }
}