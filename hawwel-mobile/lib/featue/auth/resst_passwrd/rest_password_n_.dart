import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/falidator.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/login/widjt/textfildlogin.dart';
import 'package:usdt/featue/auth/resst_passwrd/cubit/cubit.dart';
import 'package:usdt/featue/auth/resst_passwrd/cubit/cubit_stat.dart';

class Restpassword extends StatefulWidget {
  const Restpassword({super.key});

  @override
  State<Restpassword> createState() => _ConferampasswordState();
}

class _ConferampasswordState extends State<Restpassword> {
  final _formKey = GlobalKey<FormState>();
  bool _oldVisible = false;
  bool _newVisible = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChangePasswordCubit>(context).oldpassword.clear();
    BlocProvider.of<ChangePasswordCubit>(context).newpassword.clear();
  }

  void _snack(Color bg, String msg, String img) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content: CustomSnackBar(
            backgroundColor: bg, message: msg, imagePath: img),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final cubit = BlocProvider.of<ChangePasswordCubit>(context);
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          _snack(branding.success, state.message, AppImages.doneimage);
        } else if (state is ChangePasswordFailure) {
          _snack(branding.buttonBg, state.error, AppImages.eerorrimage);
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: branding.screenBg,
            body: Column(
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
                      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
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
                                  context, 'change_password'),
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

                // ── Body ────────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Lock icon
                          Center(
                            child: Container(
                              width: 80.r,
                              height: 80.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    branding.iconPrimary.withValues(alpha: 0.14),
                                    branding.badge.withValues(alpha: 0.08),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color:
                                      branding.iconPrimary.withValues(alpha: 0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.lock_reset_rounded,
                                size: 34,
                                color: branding.iconPrimary,
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          Center(
                            child: Text(
                              AppTranslations.getText(
                                  context, 'new_password'),
                              style: GoogleFonts.cairo(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: branding.secondaryText,
                              ),
                            ),
                          ),

                          SizedBox(height: 28.h),

                          // ── Old password ──────────────────────────────
                          _FieldLabel(
                            text: AppTranslations.getText(
                                context, 'Enter old password'),
                            branding: branding,
                          ),
                          SizedBox(height: 8.h),
                          TextFieldCustom(
                            validator: (v) => validatePassword(v, context),
                            controller: cubit.oldpassword,
                            hintText:
                                AppTranslations.getText(context, 'password'),
                            type: TextInputType.visiblePassword,
                            obscureText: !_oldVisible,
                            prefixIcon: IconButton(
                              icon: Icon(
                                _oldVisible
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                color: branding.hintText,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _oldVisible = !_oldVisible),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // ── New password ──────────────────────────────
                          _FieldLabel(
                            text: AppTranslations.getText(
                                context, 'enter_new_password'),
                            branding: branding,
                          ),
                          SizedBox(height: 8.h),
                          TextFieldCustom(
                            controller: cubit.newpassword,
                            hintText:
                                AppTranslations.getText(context, 'password'),
                            type: TextInputType.visiblePassword,
                            obscureText: !_newVisible,
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

                          SizedBox(height: 36.h),

                          // ── Submit button ─────────────────────────────
                          GestureDetector(
                            onTap: state is ChangePasswordLoading
                                ? null
                                : () {
                                    if (!_formKey.currentState!.validate()) {
                                      setState(() {});
                                      return;
                                    }
                                    if (cubit.oldpassword.text ==
                                        cubit.newpassword.text) {
                                      _snack(
                                        branding.buttonBg,
                                        isArabic
                                            ? 'كلمة السر الجديدة يجب أن تكون مختلفة عن القديمة'
                                            : 'New password must be different from the old one',
                                        AppImages.eerorrimage,
                                      );
                                      return;
                                    }
                                    cubit.changePassword();
                                    cubit.oldpassword.clear();
                                    cubit.newpassword.clear();
                                  },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: state is ChangePasswordLoading
                                    ? null
                                    : branding.buildHeaderGradient(),
                                color: state is ChangePasswordLoading
                                    ? branding.hintText.withValues(alpha: 0.4)
                                    : null,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: state is ChangePasswordLoading
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
                                child: state is ChangePasswordLoading
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final dynamic branding;
  const _FieldLabel({required this.text, required this.branding});

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