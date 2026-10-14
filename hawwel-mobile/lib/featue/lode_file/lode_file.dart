import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/bootom_navigator.dart';
import 'package:usdt/featue/lode_file/data/cubit/cubit.dart';
import 'package:usdt/featue/lode_file/data/cubit/cubit_state.dart';
import 'package:file_picker/file_picker.dart';

class lodedfile extends StatefulWidget {
  const lodedfile({super.key});

  @override
  State<lodedfile> createState() => _lodedfileState();
}

class _lodedfileState extends State<lodedfile>
    with TickerProviderStateMixin {
  String? _filePath;
  String? _pickedFileName;

  late final AnimationController _headerCtrl;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;

  late final AnimationController _cardCtrl;
  late final Animation<double> _cardFade;
  late final Animation<Offset> _cardSlide;

  late final AnimationController _btnCtrl;
  late final Animation<double> _btnScale;

  late final AnimationController _successCtrl;
  late final Animation<double> _successScale;
  late final Animation<double> _successFade;
  late final Animation<double> _checkDraw;

  @override
  void initState() {
    super.initState();

    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));

    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _cardFade = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic));

    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _btnScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _btnCtrl, curve: Curves.easeOut),
    );

    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _successScale = CurvedAnimation(
      parent: _successCtrl,
      curve: Curves.elasticOut,
    );
    _successFade = CurvedAnimation(parent: _successCtrl, curve: Curves.easeOut);
    _checkDraw = CurvedAnimation(
      parent: _successCtrl,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );

    _headerCtrl.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _cardCtrl.forward();
    });
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _cardCtrl.dispose();
    _btnCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      String? path = result.files.single.path;
      String name = result.files.single.name;

      if (path != null) {
        File file = File(path);
        int originalSize = file.lengthSync();
        String extension = p.extension(path).toLowerCase();

        if (['.jpg', '.jpeg', '.png'].contains(extension)) {
          final compressedFile = await _compressImage(file);
          if (compressedFile != null) {
            path = compressedFile.path;
            int compressedSize = compressedFile.lengthSync();
            log("✅ تم الضغط بنجاح:");
            log("📏 الحجم الأصلي: ${(originalSize / 1024).toStringAsFixed(2)} KB");
            log("📉 الحجم الجديد: ${(compressedSize / 1024).toStringAsFixed(2)} KB");
            log("♻️ نسبة التوفير: ${((1 - compressedSize / originalSize) * 100).toStringAsFixed(1)}%");
          }
        } else {
          log("ℹ️ ملف PDF: لا يتم ضغطه، الحجم: ${(originalSize / 1024).toStringAsFixed(2)} KB");
        }
      }

      setState(() {
        _filePath = path;
        _pickedFileName = name;
      });
    }
  }

  Future<File?> _compressImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = p.join(dir.absolute.path, "temp_${p.basename(file.path)}");
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
      rotate: 0,
    );
    return result != null ? File(result.path) : null;
  }

  void _goToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _onSubmit() {
    final cubit = context.read<UploadKycCubit>();
    final state = cubit.state;
    final branding = appBrandingNotifier.value;

    if (_filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          content: CustomSnackBar(
            backgroundColor: branding.iconPrimary,
            message: AppTranslations.getTextStatic(context, "select_file_first"),
            imagePath: AppImages.eerorrimage,
          ),
        ),
      );
      return;
    }

    if (state is UploadKycInitial || state is UploadKycFailure) {
      cubit.uploadKyc(_filePath!);
      return;
    }

    if (state is UploadKycSuccess) {
      _goToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocListener<UploadKycCubit, UploadKycState>(
      listener: (context, state) {
        if (state is UploadKycSuccess) {
          _successCtrl.forward();
        }
      },
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: branding.screenBg,
          body: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              FadeTransition(
                opacity: _headerFade,
                child: SlideTransition(
                  position: _headerSlide,
                  child: _buildHeader(context, isArabic, branding),
                ),
              ),

              // ── Body ────────────────────────────────────────────────────
              Expanded(
                child: FadeTransition(
                  opacity: _cardFade,
                  child: SlideTransition(
                    position: _cardSlide,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 28.h,
                      ),
                      child: BlocBuilder<UploadKycCubit, UploadKycState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              _ModernStepper(
                                currentStep: state is UploadKycSuccess ? 3 : 2,
                                branding: branding,
                              ),
                              SizedBox(height: 28.h),

                              if (state is UploadKycLoading)
                                _LoadingCard(branding: branding)
                              else if (state is UploadKycSuccess)
                                _SuccessCard(
                                  branding: branding,
                                  scaleAnim: _successScale,
                                  fadeAnim: _successFade,
                                  checkDraw: _checkDraw,
                                  context: context,
                                )
                              else ...[
                                _UploadCard(
                                  branding: branding,
                                  filePath: _filePath,
                                  fileName: _pickedFileName,
                                  onTap: _pickFile,
                                  context: context,
                                ),
                                SizedBox(height: 16.h),
                                _TipsCard(branding: branding, context: context),
                              ],

                              SizedBox(height: 36.h),
                              _SubmitButton(
                                branding: branding,
                                state: state,
                                scaleCtrl: _btnCtrl,
                                scaleAnim: _btnScale,
                                onTap: _onSubmit,
                              ),
                              SizedBox(height: 32.h),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                alignment:
                    isArabic ? Alignment.centerRight : Alignment.centerLeft,
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
                child: Icon(
                  Icons.upload_file_rounded,
                  color: Colors.white,
                  size: 26.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppTranslations.getText(context, 'Upload Documents'),
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
                    'Step 2 of 3',
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

// ── Modern Stepper ────────────────────────────────────────────────────────────
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
        final Color color =
            (done || active) ? branding.accent : branding.divider;

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
                                  color:
                                      branding.accent.withValues(alpha: 0.28),
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
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w400,
                        color:
                            active ? branding.accent : branding.secondaryText,
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

// ── Upload Card ───────────────────────────────────────────────────────────────
class _UploadCard extends StatelessWidget {
  final AppBrandingConfig branding;
  final String? filePath;
  final String? fileName;
  final VoidCallback onTap;
  final BuildContext context;
  const _UploadCard({
    required this.branding,
    required this.filePath,
    required this.fileName,
    required this.onTap,
    required this.context,
  });

  bool get _isImage =>
      fileName != null &&
      (fileName!.toLowerCase().endsWith('.jpg') ||
          fileName!.toLowerCase().endsWith('.jpeg') ||
          fileName!.toLowerCase().endsWith('.png'));

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        decoration: BoxDecoration(
          color: branding.cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: filePath != null
                ? branding.accent.withValues(alpha: 0.5)
                : branding.divider.withValues(alpha: 0.6),
            width: filePath != null ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(24.r),
        child: filePath == null
            ? _EmptyState(branding: branding, context: context)
            : _FilledState(
                branding: branding,
                filePath: filePath!,
                fileName: fileName!,
                isImage: _isImage,
                context: context,
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppBrandingConfig branding;
  final BuildContext context;
  const _EmptyState({required this.branding, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            color: branding.accent.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cloud_upload_outlined,
            color: branding.accent,
            size: 32.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          AppTranslations.getText(context, 'Tap to upload document'),
          style: GoogleFonts.cairo(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: branding.primaryText,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          AppTranslations.getText(context, 'PDF, JPG, PNG supported'),
          style: GoogleFonts.cairo(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: branding.secondaryText,
          ),
        ),
        SizedBox(height: 18.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: branding.buildHeaderGradient(),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_file_rounded, color: Colors.white, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                AppTranslations.getText(context, 'Choose File'),
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilledState extends StatelessWidget {
  final AppBrandingConfig branding;
  final String filePath;
  final String fileName;
  final bool isImage;
  final BuildContext context;
  const _FilledState({
    required this.branding,
    required this.filePath,
    required this.fileName,
    required this.isImage,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        if (isImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              File(filePath),
              height: 160.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: branding.accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.picture_as_pdf_rounded,
              color: branding.accent,
              size: 32.sp,
            ),
          ),
        SizedBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: branding.accent,
              size: 18.sp,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                fileName,
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: branding.primaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          AppTranslations.getText(context, 'Tap to change file'),
          style: GoogleFonts.cairo(
            fontSize: 11.sp,
            color: branding.secondaryText,
          ),
        ),
      ],
    );
  }
}

// ── Tips Card ─────────────────────────────────────────────────────────────────
class _TipsCard extends StatelessWidget {
  final AppBrandingConfig branding;
  final BuildContext context;
  const _TipsCard({required this.branding, required this.context});

  @override
  Widget build(BuildContext ctx) {
    final tips = [
      (Icons.wb_sunny_outlined, 'Good lighting is important'),
      (Icons.crop_free_rounded, 'Make sure the full document is visible'),
      (Icons.high_quality_rounded, 'Use a high-quality image'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: branding.iconPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.tips_and_updates_rounded,
                  color: branding.iconPrimary,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                AppTranslations.getText(context, 'Upload Tips'),
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: branding.primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ...tips.asMap().entries.map((e) {
            final i = e.key;
            final tip = e.value;
            return Column(
              children: [
                Row(
                  children: [
                    Icon(tip.$1, color: branding.accent, size: 16.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        AppTranslations.getText(context, tip.$2),
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: branding.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < tips.length - 1) ...[
                  SizedBox(height: 8.h),
                  Divider(
                    color: branding.divider.withValues(alpha: 0.35),
                    height: 1,
                    indent: 26.w,
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

// ── Loading Card ──────────────────────────────────────────────────────────────
class _LoadingCard extends StatefulWidget {
  final AppBrandingConfig branding;
  const _LoadingCard({required this.branding});

  @override
  State<_LoadingCard> createState() => _LoadingCardState();
}

class _LoadingCardState extends State<_LoadingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.branding.cardBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Transform.rotate(
              angle: _ctrl.value * 2 * math.pi,
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      widget.branding.accent.withValues(alpha: 0.0),
                      widget.branding.accent,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: widget.branding.cardBg,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            AppTranslations.getText(context, 'loading_now'),
            style: GoogleFonts.cairo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: widget.branding.primaryText,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppTranslations.getText(context, 'Please wait a moment'),
            style: GoogleFonts.cairo(
              fontSize: 12.sp,
              color: widget.branding.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Success Card ──────────────────────────────────────────────────────────────
class _SuccessCard extends StatelessWidget {
  final AppBrandingConfig branding;
  final Animation<double> scaleAnim;
  final Animation<double> fadeAnim;
  final Animation<double> checkDraw;
  final BuildContext context;
  const _SuccessCard({
    required this.branding,
    required this.scaleAnim,
    required this.fadeAnim,
    required this.checkDraw,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return FadeTransition(
      opacity: fadeAnim,
      child: Container(
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
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
        child: Column(
          children: [
            ScaleTransition(
              scale: scaleAnim,
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  gradient: branding.buildHeaderGradient(),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: branding.accent.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: checkDraw,
                  builder: (_, __) => CustomPaint(
                    painter: _CheckPainter(progress: checkDraw.value),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              AppTranslations.getText(context, 'Loaded'),
              style: GoogleFonts.cairo(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: branding.primaryText,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppTranslations.getText(
                  context, 'Documents uploaded successfully'),
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                color: branding.secondaryText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;
  const _CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final p1 = Offset(cx - 14, cy);
    final p2 = Offset(cx - 4, cy + 10);
    final p3 = Offset(cx + 14, cy - 10);

    final totalLen =
        (p2 - p1).distance + (p3 - p2).distance;
    final drawn = progress * totalLen;

    final seg1 = (p2 - p1).distance;

    if (drawn <= seg1) {
      final t = drawn / seg1;
      canvas.drawLine(p1, Offset.lerp(p1, p2, t)!, paint);
    } else {
      canvas.drawLine(p1, p2, paint);
      final t = (drawn - seg1) / (p3 - p2).distance;
      canvas.drawLine(p2, Offset.lerp(p2, p3, t.clamp(0, 1))!, paint);
    }
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress;
}

// ── Submit Button ─────────────────────────────────────────────────────────────
class _SubmitButton extends StatelessWidget {
  final AppBrandingConfig branding;
  final UploadKycState state;
  final AnimationController scaleCtrl;
  final Animation<double> scaleAnim;
  final VoidCallback onTap;
  const _SubmitButton({
    required this.branding,
    required this.state,
    required this.scaleCtrl,
    required this.scaleAnim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = state is UploadKycSuccess;
    final bool isLoading = state is UploadKycLoading;

    return ScaleTransition(
      scale: scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => scaleCtrl.forward(),
        onTapUp: (_) {
          scaleCtrl.reverse();
          HapticFeedback.mediumImpact();
          onTap();
        },
        onTapCancel: () => scaleCtrl.reverse(),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            gradient: isLoading
                ? LinearGradient(
                    colors: [branding.divider, branding.divider],
                  )
                : branding.buildHeaderGradient(),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: isLoading
                ? []
                : [
                    BoxShadow(
                      color: branding.accent.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              else ...[
                Text(
                  AppTranslations.getText(
                    context,
                    isSuccess ? 'go_to_home' : 'next',
                  ),
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  isSuccess
                      ? Icons.home_rounded
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}