import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/lode_file/lode_file.dart';

class idintyview extends StatefulWidget {
  const idintyview({super.key});

  @override
  State<idintyview> createState() => _idintyviewState();
}

class _idintyviewState extends State<idintyview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: Column(
          children: [
            _buildHeader(context, isArabic, branding),
            Expanded(
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 28.h,
                    ),
                    child: Column(
                      children: [
                        _ModernStepper(currentStep: 1, branding: branding),
                        SizedBox(height: 28.h),
                        _InfoCard(branding: branding, context: context),
                        SizedBox(height: 20.h),
                        _RequiredDocs(branding: branding, context: context),
                        SizedBox(height: 36.h),
                        _NextButton(branding: branding),
                        SizedBox(height: 32.h),
                      ],
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

  Widget _buildHeader(
    BuildContext context,
    bool isArabic,
    AppBrandingConfig branding,
  ) {
    return Container(
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
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
          child: Column(
            children: [
              Align(
                alignment: isArabic
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isArabic
                          ? Icons.arrow_forward_ios_rounded
                          : Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Container(
                width: 66.w,
                height: 66.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 2,
                  ),
                ),
                padding: EdgeInsets.all(14.r),
                child: Image.asset(AppImages.idinty, color: Colors.white),
              ),
              SizedBox(height: 12.h),
              Text(
                AppTranslations.getText(context, 'Identity verification'),
                style: GoogleFonts.cairo(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  AppTranslations.getText(
                    context,
                    'Not yet verified, please complete',
                  ),
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Modern stepper ────────────────────────────────────────────────────────────
class _ModernStepper extends StatelessWidget {
  final int currentStep;
  final AppBrandingConfig branding;
  const _ModernStepper({required this.currentStep, required this.branding});

  static const _keys = ['Identity Information', 'Upload Documents', 'Review'];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(3, (i) {
        final int step = i + 1;
        final bool done = step < currentStep;
        final bool active = step == currentStep;
        final Color color = (done || active)
            ? branding.accent
            : branding.divider;

        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: done
                            ? branding.accent
                            : active
                            ? Colors.white
                            : branding.screenBg,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color,
                          width: active ? 2.5 : 1.5,
                        ),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: branding.accent.withValues(
                                    alpha: 0.28,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: done
                            ? Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 15.sp,
                              )
                            : Text(
                                '$step',
                                style: GoogleFonts.cairo(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: active
                                      ? branding.accent
                                      : branding.secondaryText,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      AppTranslations.getText(context, _keys[i]),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.cairo(
                        fontSize: 10.sp,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        color: active
                            ? branding.accent
                            : branding.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < 2)
                Expanded(
                  child: Container(
                    height: 2.h,
                    margin: EdgeInsets.only(top: 17.h),
                    decoration: BoxDecoration(
                      color: done ? branding.accent : branding.divider,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final AppBrandingConfig branding;
  final BuildContext context;
  const _InfoCard({required this.branding, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: branding.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_pin_rounded,
                  color: branding.accent,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                AppTranslations.getText(context, 'Identity Information'),
                style: GoogleFonts.cairo(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: branding.primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(color: branding.divider.withValues(alpha: 0.4), height: 1),
          SizedBox(height: 12.h),
          Text(
            AppTranslations.getText(
              context,
              'Steps to complete money transfers',
            ),
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              color: branding.secondaryText,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Required documents ────────────────────────────────────────────────────────
class _RequiredDocs extends StatelessWidget {
  final AppBrandingConfig branding;
  final BuildContext context;
  const _RequiredDocs({required this.branding, required this.context});

  @override
  Widget build(BuildContext ctx) {
    final items = [
      (Icons.badge_rounded, 'National ID / Passport'),
      (Icons.face_rounded, 'Selfie with ID'),
      (Icons.home_rounded, 'Proof of address'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: branding.iconPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.checklist_rounded,
                  color: branding.iconPrimary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                AppTranslations.getText(context, 'Required Documents'),
                style: GoogleFonts.cairo(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: branding.primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: branding.accent.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.$1, color: branding.accent, size: 16.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        AppTranslations.getText(context, item.$2),
                        style: GoogleFonts.cairo(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: branding.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < items.length - 1) ...[
                  SizedBox(height: 8.h),
                  Divider(
                    color: branding.divider.withValues(alpha: 0.35),
                    height: 1,
                    indent: 46.w,
                  ),
                  SizedBox(height: 8.h),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── Next button ───────────────────────────────────────────────────────────────
class _NextButton extends StatefulWidget {
  final AppBrandingConfig branding;
  const _NextButton({required this.branding});

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _c.forward(),
        onTapUp: (_) {
          _c.reverse();
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 350),
              pageBuilder: (_, a, __) => lodedfile(),
              transitionsBuilder: (_, a, __, child) => FadeTransition(
                opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
                child: child,
              ),
            ),
          );
        },
        onTapCancel: () => _c.reverse(),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            gradient: widget.branding.buildHeaderGradient(),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: widget.branding.accent.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppTranslations.getText(context, 'next'),
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
