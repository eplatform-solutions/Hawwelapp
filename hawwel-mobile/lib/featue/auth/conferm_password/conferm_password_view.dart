import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/falidator.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/auth/conferm_password/data/cubit/conferm_cubit.dart';
import 'package:usdt/featue/auth/conferm_password/data/cubit/conferm_cubit_stat.dart';
import 'package:usdt/featue/auth/login/login_screen_view.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/login/widjt/textfildlogin.dart';

class Conferampassword extends StatefulWidget {
  const Conferampassword(
      {super.key, required this.otp, required this.session});

  final String otp;
  final String session;

  @override
  State<Conferampassword> createState() => _ConferampasswordState();
}

class _ConferampasswordState extends State<Conferampassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool _newVisible = false;
  bool _confirmVisible = false;

  @override
  void dispose() {
    _newPass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  void _snack(Color bg, String msg, String img) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content:
            CustomSnackBar(backgroundColor: bg, message: msg, imagePath: img),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: BlocConsumer<ConfermCubit, ConfermState>(
          listener: (context, state) {
            if (state is ConfermSuccess) {
              _snack(branding.success, state.massage, AppImages.doneimage);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Loginview()),
              );
              context.read<ConfermCubit>().password.clear();
            } else if (state is ConfermFailure) {
              _snack(branding.buttonBg, state.error, AppImages.eerorrimage);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  // ── Gradient Header ────────────────────────────────────
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
                        padding:
                            EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 38.r,
                                height: 38.r,
                                decoration: BoxDecoration(
                                  color: branding.buttonText
                                      .withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  isArabic
                                      ? Icons.arrow_forward_ios_rounded
                                      : Icons.arrow_back_ios_new_rounded,
                                  color: branding.buttonText,
                                  size: 18,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                AppTranslations.getText(
                                    context, 'new_password_title'),
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
                      ),
                    ),
                  ),

                  // ── Body ──────────────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Icon ──────────────────────────────────────
                          Center(
                            child: Container(
                              width: 80.r,
                              height: 80.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    branding.iconPrimary
                                        .withValues(alpha: 0.14),
                                    branding.badge.withValues(alpha: 0.08),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: branding.iconPrimary
                                      .withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.lock_open_rounded,
                                size: 34,
                                color: branding.iconPrimary,
                              ),
                            ),
                          ),

                          SizedBox(height: 14.h),

                          Center(
                            child: Text(
                              AppTranslations.getText(
                                  context, 'new_password'),
                              style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: branding.secondaryText,
                              ),
                            ),
                          ),

                          SizedBox(height: 28.h),

                          // ── Two-step indicator ─────────────────────────
                          _StepIndicator(branding: branding, isArabic: isArabic),

                          SizedBox(height: 28.h),

                          // ── New password ───────────────────────────────
                          _Label(
                            text: AppTranslations.getText(
                                context, 'enter_new_password'),
                            branding: branding,
                          ),
                          SizedBox(height: 8.h),
                          TextFieldCustom(
                            validator: (v) => validatePassword(v, context),
                            controller: _newPass,
                            obscureText: !_newVisible,
                            type: TextInputType.visiblePassword,
                            hintText: AppTranslations.getText(
                                context, 'password_required'),
                            prefixIcon: IconButton(
                              icon: Icon(
                                _newVisible
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: branding.hintText,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _newVisible = !_newVisible),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // ── Confirm password ───────────────────────────
                          _Label(
                            text: AppTranslations.getText(
                                context, 'confirm_password'),
                            branding: branding,
                          ),
                          SizedBox(height: 8.h),
                          TextFieldCustom(
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return AppTranslations.getText(
                                    context, 'password_required');
                              }
                              if (v != _newPass.text) {
                                return isArabic
                                    ? 'كلمتا المرور غير متطابقتين'
                                    : 'Passwords do not match';
                              }
                              return null;
                            },
                            controller: _confirmPass,
                            obscureText: !_confirmVisible,
                            type: TextInputType.visiblePassword,
                            hintText: AppTranslations.getText(
                                context, 'password'),
                            prefixIcon: IconButton(
                              icon: Icon(
                                _confirmVisible
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: branding.hintText,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _confirmVisible = !_confirmVisible),
                            ),
                          ),

                          SizedBox(height: 36.h),

                          // ── Submit button ──────────────────────────────
                          GestureDetector(
                            onTap: state is ConfermLoading
                                ? null
                                : () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    context.read<ConfermCubit>().confermCubit(
                                          confermpassword: _newPass.text,
                                          session: widget.session,
                                          otp: widget.otp,
                                        );
                                  },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: state is ConfermLoading
                                    ? null
                                    : branding.buildHeaderGradient(),
                                color: state is ConfermLoading
                                    ? branding.hintText.withValues(alpha: 0.4)
                                    : null,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: state is ConfermLoading
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
                                child: state is ConfermLoading
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
                                          Icon(Icons.check_rounded,
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
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Step indicator ───────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final dynamic branding;
  final bool isArabic;
  const _StepIndicator({required this.branding, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Step(
          number: '1',
          label: isArabic ? 'التحقق' : 'Verify',
          done: true,
          branding: branding,
        ),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                branding.iconPrimary,
                branding.iconPrimary.withValues(alpha: 0.3),
              ]),
            ),
          ),
        ),
        _Step(
          number: '2',
          label: isArabic ? 'كلمة المرور' : 'New password',
          done: false,
          branding: branding,
          active: true,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String label;
  final bool done;
  final bool active;
  final dynamic branding;

  const _Step({
    required this.number,
    required this.label,
    required this.done,
    required this.branding,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = done || active ? branding.iconPrimary : branding.hintText;
    return Column(
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
                ? branding.iconPrimary
                : active
                    ? branding.iconPrimary.withValues(alpha: 0.15)
                    : branding.inputBorder,
            border: Border.all(color: color, width: 1.5),
          ),
          child: Center(
            child: done
                ? Icon(Icons.check_rounded, color: branding.buttonText, size: 16)
                : Text(
                    number,
                    style: GoogleFonts.cairo(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Field label ──────────────────────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  final dynamic branding;
  const _Label({required this.text, required this.branding});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: branding.primaryText,
      ),
    );
  }
}