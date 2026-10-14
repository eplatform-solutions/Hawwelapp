import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';

/// Uploaded transfer photos are usually raw phone screenshots (tall, with
/// black bars). Showing them at full size swamped the details screen, so
/// they are presented as a bounded, cover-cropped card; tapping it opens a
/// zoomable viewer. The card itself carries no overlay (no caption, zoom or
/// share icons) - the section title above it already says what it is.
class TransferPhotoCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const TransferPhotoCard({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final url = ApiService.resolveAssetUrl(imagePath);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TransferPhotoViewer(imagePath: imagePath, title: title),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          height: 190.h,
          width: double.infinity,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: branding.inputBorder.withValues(alpha: 0.4),
                child: Center(
                  child: CircularProgressIndicator(color: branding.badge),
                ),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              color: branding.inputBorder.withValues(alpha: 0.4),
              alignment: Alignment.center,
              child: Text(
                AppTranslations.getText(context, 'image_load_error'),
                style: GoogleFonts.cairo(
                  color: branding.iconPrimary,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-screen, pinch-to-zoom view of one photo.
class TransferPhotoViewer extends StatelessWidget {
  final String imagePath;
  final String title;

  const TransferPhotoViewer({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: GoogleFonts.cairo(color: Colors.white, fontSize: 15.sp),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Image.network(
            ApiService.resolveAssetUrl(imagePath),
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const CircularProgressIndicator(color: Colors.white);
            },
            errorBuilder: (_, __, ___) => Text(
              AppTranslations.getText(context, 'image_load_error'),
              style: GoogleFonts.cairo(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
