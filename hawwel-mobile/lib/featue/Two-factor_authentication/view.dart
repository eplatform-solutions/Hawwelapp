import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/Two-factor_authentication/data/cubit/cubit.dart';
import 'package:usdt/featue/Two-factor_authentication/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bar2.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  static int _savedSelectedOption = 3;
  late int _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = _savedSelectedOption;
  }

  List<String> _mapSelectionToMethods() {
    switch (_selectedOption) {
      case 0:
        return ['mobile-phone'];
      case 1:
        return ['email'];
      case 2:
        return ['mobile-phone', 'email'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final options = [
      _Option(
        icon: Icons.phone_android_rounded,
        label: AppTranslations.getText(context, 'phone_number1'),
        subtitle: isArabic
            ? 'استقبال رمز التحقق عبر رسالة نصية'
            : 'Receive OTP via SMS',
      ),
      _Option(
        icon: Icons.email_outlined,
        label: AppTranslations.getText(context, 'Email'),
        subtitle: isArabic
            ? 'استقبال رمز التحقق عبر البريد الإلكتروني'
            : 'Receive OTP via email',
      ),
      _Option(
        icon: Icons.devices_rounded,
        label: AppTranslations.getText(context, 'Phone number or email'),
        subtitle: isArabic
            ? 'استخدام كلا الطريقتين معاً'
            : 'Use both methods together',
      ),
      _Option(
        icon: Icons.lock_open_rounded,
        label: AppTranslations.getText(context, 'Deactivate'),
        subtitle: isArabic
            ? 'إيقاف المصادقة الثنائية'
            : 'Turn off two-factor authentication',
        isDeactivate: true,
      ),
    ];

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: BlocConsumer<Change2FACubit, Change2FAState>(
          listener: (context, state) {
            if (state is Change2FASuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  content: CustomSnackBar2(
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    backgroundColor: branding.success,
                    message: state.message,
                    imagePath: AppImages.doneimage,
                  ),
                ),
              );
            } else if (state is Change2FAError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  content: CustomSnackBar(
                    backgroundColor: branding.iconPrimary,
                    message: state.message,
                    imagePath: AppImages.eerorrimage,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
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
                      child: Column(
                        children: [
                          // Back row
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 38.r,
                                  height: 38.r,
                                  decoration: BoxDecoration(
                                    color: branding.buttonText
                                        .withValues(alpha: 0.18),
                                    borderRadius:
                                        BorderRadius.circular(12.r),
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
                            width: 68.r,
                            height: 68.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: branding.buttonText
                                  .withValues(alpha: 0.15),
                              border: Border.all(
                                color: branding.buttonText
                                    .withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.security_rounded,
                              size: 30,
                              color: branding.buttonText,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          Text(
                            AppTranslations.getText(
                              context,
                              'Do you want to activate the service via phone number or email?',
                            ),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: branding.buttonText
                                  .withValues(alpha: 0.85),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Options list ───────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...List.generate(options.length, (i) {
                          final opt = options[i];
                          final isSelected = _selectedOption == i;
                          final isDeactivate = opt.isDeactivate;

                          final activeColor = isDeactivate
                              ? branding.error
                              : branding.iconPrimary;

                          return GestureDetector(
                            onTap: () => setState(() {
                              _selectedOption = i;
                              _savedSelectedOption = i;
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeInOut,
                              margin: EdgeInsets.only(bottom: 12.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? activeColor.withValues(alpha: 0.08)
                                    : branding.inputBorder
                                        .withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected
                                      ? activeColor.withValues(alpha: 0.5)
                                      : branding.hintText
                                          .withValues(alpha: 0.12),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Icon container
                                  Container(
                                    width: 44.r,
                                    height: 44.r,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(12.r),
                                      color: isSelected
                                          ? activeColor
                                              .withValues(alpha: 0.12)
                                          : branding.hintText
                                              .withValues(alpha: 0.07),
                                    ),
                                    child: Icon(
                                      opt.icon,
                                      size: 20,
                                      color: isSelected
                                          ? activeColor
                                          : branding.hintText,
                                    ),
                                  ),

                                  SizedBox(width: 14.w),

                                  // Texts
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          opt.label,
                                          style: GoogleFonts.cairo(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected
                                                ? activeColor
                                                : branding.primaryText,
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        Text(
                                          opt.subtitle,
                                          style: GoogleFonts.cairo(
                                            fontSize: 11.sp,
                                            color: branding.secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Radio dot
                                  AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    width: 22.r,
                                    height: 22.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? activeColor
                                            : branding.hintText
                                                .withValues(alpha: 0.4),
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? activeColor
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? Icon(Icons.check_rounded,
                                            size: 12,
                                            color: Colors.white)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        SizedBox(height: 8.h),

                        // ── Submit button ────────────────────────────────
                        GestureDetector(
                          onTap: state is Change2FALoading
                              ? null
                              : () {
                                  final enabled = _selectedOption != 3;
                                  final methods = _mapSelectionToMethods();
                                  context.read<Change2FACubit>().change2FA(
                                        enabled: enabled,
                                        methods: methods,
                                      );
                                },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: state is Change2FALoading
                                  ? null
                                  : branding.buildHeaderGradient(),
                              color: state is Change2FALoading
                                  ? branding.hintText.withValues(alpha: 0.4)
                                  : null,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: state is Change2FALoading
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: branding.iconPrimary
                                            .withValues(alpha: 0.28),
                                        blurRadius: 14,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                            ),
                            child: Container(
                              height: 52.h,
                              alignment: Alignment.center,
                              child: state is Change2FALoading
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
                                        Icon(Icons.check_circle_outline_rounded,
                                            color: branding.buttonText,
                                            size: 20),
                                        SizedBox(width: 8.w),
                                        Text(
                                          AppTranslations.getText(
                                              context, 'next'),
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

// ── Option model ─────────────────────────────────────────────────────────────
class _Option {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isDeactivate;

  const _Option({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.isDeactivate = false,
  });
}