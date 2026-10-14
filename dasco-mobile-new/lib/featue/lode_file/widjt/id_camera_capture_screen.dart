import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';

/// شاشة كاميرا مخصصة لتصوير مستندات الهوية (KYC) بإطار توجيهي بحجم البطاقة،
/// بدل الاعتماد على تطبيق الكاميرا الأصلي للنظام. تُعيد [File] للصورة بعد
/// تأكيد المستخدم، أو null عند الإلغاء أو تعذّر الوصول إلى الكاميرا.
class IdCameraCaptureScreen extends StatefulWidget {
  final String guideTitle;

  const IdCameraCaptureScreen({super.key, required this.guideTitle});

  @override
  State<IdCameraCaptureScreen> createState() => _IdCameraCaptureScreenState();
}

class _IdCameraCaptureScreenState extends State<IdCameraCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initFuture;
  bool _isCapturing = false;
  String? _capturedPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initFuture = _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (_) {
      // يبقى _controller فارغًا؛ الواجهة تعرض حالة "تعذّر الوصول" مع خيار الرجوع.
    }
  }

  // إيقاف الكاميرا فورًا عند تعليق التطبيق حتى لا يبقى مؤشر استخدامها ظاهرًا،
  // وإعادة تهيئتها عند العودة (باستثناء وجود صورة قيد المعاينة بالفعل).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller = null;
      controller.dispose();
      if (mounted) setState(() {});
    } else if (state == AppLifecycleState.resumed && _capturedPath == null) {
      setState(() => _initFuture = _initCamera());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        _isCapturing) {
      return;
    }
    setState(() => _isCapturing = true);
    try {
      final shot = await controller.takePicture();
      HapticFeedback.mediumImpact();
      if (!mounted) return;
      setState(() {
        _capturedPath = shot.path;
        _isCapturing = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _retake() => setState(() => _capturedPath = null);

  void _confirm() {
    final path = _capturedPath;
    if (path == null) return;
    Navigator.pop(context, File(path));
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _controller?.dispose();
      },
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: _capturedPath != null
                ? _buildPreview(branding, isArabic)
                : FutureBuilder<void>(
                    future: _initFuture,
                    builder: (context, snapshot) {
                      final controller = _controller;
                      if (controller == null ||
                          !controller.value.isInitialized) {
                        if (snapshot.connectionState !=
                            ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }
                        return _buildCameraUnavailable(isArabic);
                      }
                      return _buildLivePreview(controller, isArabic);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLivePreview(CameraController controller, bool isArabic) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: CameraPreview(controller)),
        const CustomPaint(size: Size.infinite, painter: _IdFramePainter()),
        Positioned(
          top: 8.h,
          left: 12.w,
          right: 12.w,
          child: Row(
            children: [
              AppBackButton(
                color: Colors.white,
                onTap: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    widget.guideTitle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 38.w),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 130.h,
          child: Text(
            isArabic
                ? 'ضع المستند داخل الإطار'
                : 'Place the document inside the frame',
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              shadows: const [Shadow(blurRadius: 6, color: Colors.black54)],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32.h,
          child: Center(
            child: GestureDetector(
              onTap: _capture,
              child: Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                padding: EdgeInsets.all(6.r),
                child: _isCapturing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(AppBrandingConfig branding, bool isArabic) {
    final path = _capturedPath!;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: Image.file(File(path), fit: BoxFit.contain)),
        Positioned(
          top: 8.h,
          left: 12.w,
          child: AppBackButton(
            color: Colors.white,
            onTap: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          left: 20.w,
          right: 20.w,
          bottom: 32.h,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _retake,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    isArabic ? 'إعادة التصوير' : 'Retake',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    backgroundColor: branding.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    isArabic ? 'استخدام الصورة' : 'Use photo',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCameraUnavailable(bool isArabic) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.no_photography_rounded,
              color: Colors.white,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              isArabic
                  ? 'تعذّر الوصول إلى الكاميرا على هذا الجهاز'
                  : 'Could not access the camera on this device',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(color: Colors.white, fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? 'رجوع' : 'Back',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// يرسم إطار توجيهي شفاف بنسبة بطاقة هوية قياسية (ISO/IEC 7810 ID-1 ≈ 1.586)
/// فوق معاينة الكاميرا الحية، بنفس أسلوب منصات التحقق من الهوية (KYC).
class _IdFramePainter extends CustomPainter {
  const _IdFramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final frameWidth = size.width * 0.86;
    final frameHeight = frameWidth / 1.586;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2 - 20),
      width: frameWidth,
      height: frameHeight,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

    final scrimPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      scrimPath,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    const cornerLen = 22.0;
    final corners = [
      [
        rect.topLeft,
        Offset(rect.left + cornerLen, rect.top),
        Offset(rect.left, rect.top + cornerLen),
      ],
      [
        rect.topRight,
        Offset(rect.right - cornerLen, rect.top),
        Offset(rect.right, rect.top + cornerLen),
      ],
      [
        rect.bottomLeft,
        Offset(rect.left + cornerLen, rect.bottom),
        Offset(rect.left, rect.bottom - cornerLen),
      ],
      [
        rect.bottomRight,
        Offset(rect.right - cornerLen, rect.bottom),
        Offset(rect.right, rect.bottom - cornerLen),
      ],
    ];
    for (final c in corners) {
      canvas.drawLine(c[0], c[1], cornerPaint);
      canvas.drawLine(c[0], c[2], cornerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _IdFramePainter oldDelegate) => false;
}
