import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/style.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/login/widjt/textfildlogin.dart';
import 'package:hawwel/featue/profail/data/cubit_put/cubit.dart';
import 'package:hawwel/featue/profail/data/cubit_put/cubit_stat.dart';

class EditProfileOtpPage extends StatelessWidget {
  final bool isEmailOtp;
  final String sentTo;
  final VoidCallback onComplete;

  const EditProfileOtpPage({
    super.key,
    required this.isEmailOtp,
    required this.sentTo,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final cubit = context.read<UpdateInfoCubit>();

    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: BlocListener<UpdateInfoCubit, UpdateInfoState>(
          listener: (context, state) {
            if (state is UpdateInfoSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                content: CustomSnackBar(
                  backgroundColor: branding.success,
                  message: state.message,
                  imagePath: AppImages.doneimage,
                ),
              ));
              Navigator.pop(context);
              onComplete();
            }

            if (state is UpdateInfoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                content: CustomSnackBar(
                  backgroundColor: branding.iconPrimary,
                  message: state.error,
                  imagePath: AppImages.eerorrimage,
                ),
              ));
            }

            if (state is RegisterchangOTPSent) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                content: CustomSnackBar(
                  backgroundColor: branding.success,
                  message: state.msg,
                  imagePath: AppImages.doneimage,
                ),
              ));
            }

            if (state is RegisterchangOTPError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                content: CustomSnackBar(
                  backgroundColor: branding.iconPrimary,
                  message: state.error,
                  imagePath: AppImages.eerorrimage,
                ),
              ));
            }
          },
          child: BlocBuilder<UpdateInfoCubit, UpdateInfoState>(
            builder: (context, state) {
              final isLoading = state is UpdateInfoLoading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Gradient Header ──────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      gradient: branding.buildHeaderGradient(),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
                        child: Row(
                          children: [
                            AppBackButton(),
                            Expanded(
                              child: Text(
                                AppTranslations.getText(context, 'verification_code'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: branding.buttonText,
                                ),
                              ),
                            ),
                            SizedBox(width: 38.w),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Body ────────────────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Shield icon ────────────────────────────────
                          Center(
                            child: Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                gradient: branding.buildHeaderGradient(),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: branding.iconPrimary.withValues(alpha: 0.3),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isEmailOtp
                                    ? Icons.mark_email_read_outlined
                                    : Icons.phone_android_rounded,
                                color: branding.buttonText,
                                size: 36,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // ── Title ──────────────────────────────────────
                          Text(
                            AppTranslations.getText(context, 'enter_verification_code'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.primaryText,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // ── Sent to badge ──────────────────────────────
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: branding.iconPrimary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(50.r),
                                border: Border.all(
                                  color: branding.iconPrimary.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isEmailOtp ? Icons.email_outlined : Icons.phone_outlined,
                                    size: 14,
                                    color: branding.iconPrimary,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    sentTo,
                                    style: GoogleFonts.cairo(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: branding.iconPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 36.h),

                          // ── OTP Input ──────────────────────────────────
                          TextFieldCustom(
                            controller: isEmailOtp
                                ? cubit.emailOtpController
                                : cubit.phoneOtpController,
                            hintText: AppTranslations.getText(context, 'enter_otp'),
                            type: TextInputType.number,
                            hintStyle: AppStyle.meduim16grey,
                          ),
                          SizedBox(height: 28.h),

                          // ── Submit button ──────────────────────────────
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () async {
                                    await cubit.updateUserInfo(
                                      mobilePhone:
                                          isEmailOtp ? null : cubit.submittedPhone,
                                    );
                                  },
                            child: Container(
                              height: 56.h,
                              decoration: isLoading
                                  ? BoxDecoration(
                                      color: branding.iconPrimary.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(16.r),
                                    )
                                  : branding.buildButtonDecoration(radius: 16),
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: branding.buttonText,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        AppTranslations.getText(context, 'submit'),
                                        style: GoogleFonts.cairo(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}