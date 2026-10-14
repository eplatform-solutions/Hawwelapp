// ignore_for_file: camel_case_types

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/bootom_navigator.dart';
import 'package:hawwel/featue/lode_file/data/cubit/cubit.dart';
import 'package:hawwel/featue/lode_file/data/cubit/cubit_state.dart';
import 'package:hawwel/featue/lode_file/widjt/id_camera_capture_screen.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit.dart';
import 'package:file_picker/file_picker.dart';

// Server-side limit for a KYC document; enforced here too so a user is not
// sent through a long upload only to get a rejection.
const int _kMaxKycFileBytes = 5 * 1024 * 1024;

class lodedfile extends StatefulWidget {
  const lodedfile({super.key});

  @override
  State<lodedfile> createState() => _lodedfileState();
}

class _lodedfileState extends State<lodedfile>
    with TickerProviderStateMixin {
  String? _firstFilePath;
  String? _firstPickedFileName;
  String? _secondFilePath;
  String? _secondPickedFileName;
  bool _kycConsent = false;

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

    // The cubit is app-scoped, so a previous submission's Success state
    // would otherwise still be showing when the screen is reopened (e.g.
    // after a rejection) and swallow the new upload as "already done".
    final uploadCubit = context.read<UploadKycCubit>();
    if (uploadCubit.state is! UploadKycLoading) {
      uploadCubit.reset();
    }

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

  Future<void> _showSourcePicker({required bool isSecond}) async {
    final branding = appBrandingNotifier.value;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: branding.cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: branding.divider,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 18.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isArabic ? 'اختر مصدر الصورة' : 'Choose image source',
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: branding.primaryText,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _SourceOptionTile(
                branding: branding,
                icon: Icons.camera_alt_rounded,
                label: isArabic ? 'التقاط صورة بالكاميرا' : 'Take a photo',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _runPicker(() => _pickFromCamera(isSecond: isSecond));
                },
              ),
              SizedBox(height: 10.h),
              _SourceOptionTile(
                branding: branding,
                icon: Icons.photo_library_rounded,
                label: isArabic ? 'اختيار من المعرض' : 'Choose from gallery',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _runPicker(() => _pickFromGallery(isSecond: isSecond));
                },
              ),
              SizedBox(height: 10.h),
              _SourceOptionTile(
                branding: branding,
                icon: Icons.attach_file_rounded,
                label: isArabic ? 'اختيار ملف (PDF)' : 'Choose a file (PDF)',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _runPicker(() => _pickFromFiles(isSecond: isSecond));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Picker plugins throw PlatformException for denied permissions, a killed
  // picker activity, or an unreadable file - each of those used to bring the
  // whole app down instead of showing a message.
  Future<void> _runPicker(Future<void> Function() picker) async {
    try {
      await picker();
    } catch (_) {
      if (!mounted) return;
      _showUploadCardError(
        isArabic: Localizations.localeOf(context).languageCode == 'ar',
      );
    }
  }

  Future<void> _pickFromCamera({required bool isSecond}) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    if (!mounted) return;

    if (status.isPermanentlyDenied) {
      _showCameraPermissionDialog(isArabic: isArabic);
      return;
    }
    if (!status.isGranted) {
      _showSnack(
        isArabic
            ? 'لم يتم منح إذن الكاميرا. يمكنك اختيار الصورة من المعرض بدلاً من ذلك.'
            : 'Camera permission was not granted. You can pick the photo from the gallery instead.',
      );
      return;
    }

    final File? shot = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (_) => IdCameraCaptureScreen(
          guideTitle: isSecond
              ? (isArabic ? 'الوجه الخلفي للمستند' : 'Document back side')
              : (isArabic ? 'الوجه الأمامي للمستند' : 'Document front side'),
        ),
        fullscreenDialog: true,
      ),
    );
    if (shot == null || !mounted) return;
    await _handlePickedImage(shot, isSecond: isSecond);
  }

  void _showCameraPermissionDialog({required bool isArabic}) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isArabic ? 'إذن الكاميرا مطلوب' : 'Camera permission needed'),
        content: Text(
          isArabic
              ? 'يرجى تفعيل إذن الكاميرا من إعدادات الجهاز لتتمكن من تصوير مستنداتك.'
              : 'Please enable camera access from device settings to photograph your documents.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              openAppSettings();
            },
            child: Text(isArabic ? 'فتح الإعدادات' : 'Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromGallery({required bool isSecond}) async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked == null) return;
    await _handlePickedImage(File(picked.path), isSecond: isSecond);
  }

  Future<void> _handlePickedImage(File file, {required bool isSecond}) async {
    final compressedFile = await _compressImage(file);
    if (compressedFile == null) {
      if (!mounted) return;
      _showUploadCardError(
        isArabic: Localizations.localeOf(context).languageCode == 'ar',
      );
      return;
    }
    _setStoredFile(
      compressedFile.path,
      p.basename(compressedFile.path),
      isSecond: isSecond,
    );
  }

  // يستبدل مسار الملف المخزَّن لهذه الخانة، ويحذف الملف المؤقت السابق (إن وُجد)
  // بعد الاستبدال حتى لا تتراكم نسخ سابقة من مستندات هوية حساسة على الجهاز.
  void _setStoredFile(String path, String name, {required bool isSecond}) {
    if (!mounted) return;
    final previousPath = isSecond ? _secondFilePath : _firstFilePath;
    setState(() {
      if (isSecond) {
        _secondFilePath = path;
        _secondPickedFileName = name;
      } else {
        _firstFilePath = path;
        _firstPickedFileName = name;
      }
    });
    if (previousPath != null && previousPath != path) {
      _deleteFileQuietly(previousPath);
    }
  }

  Future<void> _deleteFileQuietly(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // تجاهل أي فشل في حذف الملف المؤقت — ليس حرجًا لتجربة المستخدم.
    }
  }

  Future<void> _pickFromFiles({required bool isSecond}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'heic', 'heif'],
    );

    if (result != null && result.files.isNotEmpty) {
      String? path = result.files.single.path;
      String name = result.files.single.name;

      if (path != null) {
        File file = File(path);
        String extension = p.extension(path).toLowerCase();

        // Normalize every non-PDF document to a real JPEG, regardless of the
        // source extension (camera captures on many phones default to
        // HEIC/HEIF, which the backend does not accept).
        if (extension != '.pdf') {
          final compressedFile = await _compressImage(file);
          if (compressedFile == null) {
            if (!mounted) return;
            _showUploadCardError(
              isArabic: Localizations.localeOf(context).languageCode == 'ar',
            );
            return;
          }
          path = compressedFile.path;
          name = p.basename(compressedFile.path);
        } else {
          // PDFs are sent as-is (no compression), so check the server's
          // size limit before the upload instead of after it.
          final size = await file.length();
          if (!mounted) return;
          if (size > _kMaxKycFileBytes) {
            _showSnack(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'حجم الملف أكبر من 5 ميغابايت. يرجى اختيار ملف أصغر.'
                  : 'The file is larger than 5 MB. Please choose a smaller file.',
            );
            return;
          }
        }
      }

      if (path != null) {
        _setStoredFile(path, name, isSecond: isSecond);
      }
    }
  }

  void _showUploadCardError({required bool isArabic}) {
    _showSnack(
      isArabic
          ? 'تعذّرت معالجة هذه الصورة. الرجاء اختيار صورة أخرى بصيغة JPG أو PNG.'
          : 'Could not process this image. Please choose another JPG or PNG photo.',
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    final branding = appBrandingNotifier.value;
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

  Future<File?> _compressImage(File file) async {
    try {
      final dir = await path_provider.getTemporaryDirectory();
      final baseName = p.basenameWithoutExtension(file.path);
      final targetPath = p.join(dir.absolute.path, "temp_$baseName.jpg");
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 800,
        minHeight: 800,
        rotate: 0,
        format: CompressFormat.jpeg,
      );
      return result != null ? File(result.path) : null;
    } catch (_) {
      return null;
    }
  }

  // Replace the whole stack: pushing Home on top left the KYC wizard
  // screens underneath, reachable again with the system back button.
  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      final branding = appBrandingNotifier.value;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          content: CustomSnackBar(
            backgroundColor: branding.error,
            message: 'Unable to open link',
            imagePath: AppImages.eerorrimage,
          ),
        ),
      );
    }
  }

  void _onSubmit() {
    final cubit = context.read<UploadKycCubit>();
    final state = cubit.state;
    final branding = appBrandingNotifier.value;

    if (_firstFilePath == null || _secondFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          content: CustomSnackBar(
            backgroundColor: branding.iconPrimary,
            message: AppTranslations.getTextStatic(
              context,
              _firstFilePath == null
                  ? "select_first_kyc_image"
                  : "select_second_kyc_image",
            ),
            imagePath: AppImages.eerorrimage,
          ),
        ),
      );
      return;
    }
    if (!_kycConsent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          content: CustomSnackBar(
            backgroundColor: branding.error,
            message: Localizations.localeOf(context).languageCode == 'ar'
                ? 'يرجى الموافقة على إفصاح KYC قبل رفع المستند.'
                : 'Please accept the KYC disclosure before uploading.',
            imagePath: AppImages.eerorrimage,
          ),
        ),
      );
      return;
    }

    if (state is UploadKycInitial || state is UploadKycFailure) {
      cubit.uploadKyc(_firstFilePath!, _secondFilePath!);
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
          // المستندات رُفعت بنجاح؛ لا حاجة للاحتفاظ بنسخها المؤقتة الحساسة على الجهاز.
          final first = _firstFilePath;
          final second = _secondFilePath;
          if (first != null) _deleteFileQuietly(first);
          if (second != null) _deleteFileQuietly(second);
          // Profile / home gates read the cached user; refresh it so the
          // badge flips to "under review" without a manual pull-to-refresh.
          context.read<Userinfogcubit>().fetchUserInfo();
        } else if (state is UploadKycFailure) {
          final branding = appBrandingNotifier.value;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              duration: const Duration(seconds: 5),
              content: CustomSnackBar(
                backgroundColor: branding.error,
                message: state.error,
                imagePath: AppImages.eerorrimage,
              ),
            ),
          );
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
                                Text(
                                  AppTranslations.getTextStatic(
                                    context,
                                    'kyc_first_image_label',
                                  ),
                                  style: GoogleFonts.cairo(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: branding.primaryText,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                _UploadCard(
                                  branding: branding,
                                  filePath: _firstFilePath,
                                  fileName: _firstPickedFileName,
                                  onTap: () => _showSourcePicker(isSecond: false),
                                  context: context,
                                ),
                                SizedBox(height: 18.h),
                                Text(
                                  AppTranslations.getTextStatic(
                                    context,
                                    'kyc_second_image_label',
                                  ),
                                  style: GoogleFonts.cairo(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: branding.primaryText,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                _UploadCard(
                                  branding: branding,
                                  filePath: _secondFilePath,
                                  fileName: _secondPickedFileName,
                                  onTap: () => _showSourcePicker(isSecond: true),
                                  context: context,
                                ),
                                SizedBox(height: 16.h),
                                _TipsCard(branding: branding, context: context),
                                SizedBox(height: 16.h),
                                _KycDisclosureCard(
                                  branding: branding,
                                  context: context,
                                  consent: _kycConsent,
                                  onConsentChanged: (value) {
                                    setState(() {
                                      _kycConsent = value ?? false;
                                    });
                                  },
                                  onOpenPrivacy: () => _openExternalUrl(
                                    'https://hawwelapp.com/privacy',
                                  ),
                                  onOpenAmlKyc: () => _openExternalUrl(
                                    'https://hawwelapp.com/aml-kyc',
                                  ),
                                ),
                                if (state is UploadKycFailure) ...[
                                  SizedBox(height: 16.h),
                                  _FailureBanner(
                                    branding: branding,
                                    message: state.error,
                                  ),
                                ],
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
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppBackButton(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppTranslations.getText(context, 'Upload Documents'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
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
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.all(8.r),
                child: Icon(
                  Icons.upload_file_rounded,
                  color: Colors.white,
                  size: 18.sp,
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
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.r),
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

// ── Source option tile (used inside the camera/gallery/file picker sheet) ─────
class _SourceOptionTile extends StatelessWidget {
  final AppBrandingConfig branding;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SourceOptionTile({
    required this.branding,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: branding.screenBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: branding.divider.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: branding.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: branding.accent, size: 19.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: branding.primaryText,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: branding.secondaryText,
              size: 20.sp,
            ),
          ],
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
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: branding.accent.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cloud_upload_outlined,
            color: branding.accent,
            size: 22.sp,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTranslations.getText(context, 'Tap to upload document'),
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: branding.primaryText,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                AppTranslations.getText(context, 'PDF, JPG, PNG supported'),
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: branding.secondaryText,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            gradient: branding.buildHeaderGradient(),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 20.sp),
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
    return Row(
      children: [
        if (isImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              File(filePath),
              height: 52.w,
              width: 52.w,
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: branding.accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.picture_as_pdf_rounded,
              color: branding.accent,
              size: 24.sp,
            ),
          ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: branding.accent,
                    size: 16.sp,
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
              SizedBox(height: 4.h),
              Text(
                AppTranslations.getText(context, 'Tap to change file'),
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  color: branding.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KycDisclosureCard extends StatelessWidget {
  final AppBrandingConfig branding;
  final BuildContext context;
  final bool consent;
  final ValueChanged<bool?> onConsentChanged;
  final VoidCallback onOpenPrivacy;
  final VoidCallback onOpenAmlKyc;

  const _KycDisclosureCard({
    required this.branding,
    required this.context,
    required this.consent,
    required this.onConsentChanged,
    required this.onOpenPrivacy,
    required this.onOpenAmlKyc,
  });

  @override
  Widget build(BuildContext ctx) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: consent
              ? branding.accent.withValues(alpha: 0.45)
              : branding.hintText.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(0, -2),
                child: Checkbox(
                  value: consent,
                  onChanged: onConsentChanged,
                ),
              ),
              Expanded(
                child: Text(
                  isArabic
                      ? 'يجمع Hawwel App مستندي التحقق لمعالجة طلب KYC، منع الاحتيال، فحوصات الامتثال، وحماية الحساب. قد نحتفظ بسجلات التحقق حسب المتطلبات القانونية أو الامتثالية. يتطلب الرفع الحالي صورتين للمستند (الوجه الأمامي والخلفي)، وقد نطلب مستندات إضافية لاحقًا.'
                      : 'Hawwel App collects verification documents to process KYC checks, prevent fraud, perform compliance reviews, and protect your account. Verification records may be retained where required for legal, compliance, security, or fraud-prevention purposes. The current upload requires two document images (front and back), and additional documents may be requested later.',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: branding.secondaryText,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 6.h,
            children: [
              GestureDetector(
                onTap: onOpenPrivacy,
                child: Text(
                  isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: branding.accent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onOpenAmlKyc,
                child: Text(
                  isArabic ? 'سياسة AML/KYC' : 'AML/KYC Policy',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: branding.accent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Failure Banner ────────────────────────────────────────────────────────────
class _FailureBanner extends StatelessWidget {
  final AppBrandingConfig branding;
  final String message;
  const _FailureBanner({required this.branding, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: branding.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: branding.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: branding.error, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: branding.error,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
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