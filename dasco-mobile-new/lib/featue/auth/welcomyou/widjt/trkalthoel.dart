import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/app_branding.dart';

List<String> paymentLogoUrlCandidates(String imagePath) {
  final trimmed = imagePath.trim();
  if (trimmed.isEmpty) return const [];
  final dashboardBase = ApiService.dashboardBaseURL.replaceAll(
    RegExp(r'/$'),
    '',
  );

  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    final normalized = Uri.tryParse(trimmed);
    if (normalized != null &&
        normalized.path.startsWith('/assets/images/payment_methods/')) {
      final fromDashboard = '$dashboardBase${normalized.path}';
      return [fromDashboard];
    }
    return [trimmed];
  }
  final clean = trimmed.replaceFirst(RegExp(r'^/+'), '');
  if (clean.startsWith('assets/images/payment_methods/')) {
    return ['$dashboardBase/$clean'];
  }
  return [ApiService.resolveAssetUrl(trimmed)];
}

Widget _paymentLogoWithFallback({
  required List<String> urls,
  required Color fallbackColor,
  required double fallbackSize,
  BoxFit fit = BoxFit.contain,
}) {
  if (urls.isEmpty) {
    return Icon(
      Icons.account_balance_wallet_rounded,
      size: fallbackSize,
      color: fallbackColor,
    );
  }

  Widget buildAt(int index) {
    if (index >= urls.length) {
      return Icon(
        Icons.account_balance_wallet_rounded,
        size: fallbackSize,
        color: fallbackColor,
      );
    }
    return Image.network(
      urls[index],
      fit: fit,
      errorBuilder: (_, __, ___) => buildAt(index + 1),
      frameBuilder: (_, child, frame, _) {
        if (frame == null) {
          return Icon(
            Icons.account_balance_wallet_rounded,
            size: fallbackSize,
            color: fallbackColor,
          );
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: child,
        );
      },
    );
  }

  return buildAt(0);
}

class RoundedLogoImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final double radius;
  final BoxFit fit;
  final Color fallbackColor;
  final double fallbackSize;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const RoundedLogoImage({
    super.key,
    required this.imagePath,
    required this.fallbackColor,
    required this.fallbackSize,
    this.width = 48,
    this.height = 48,
    this.radius = 14,
    this.fit = BoxFit.contain,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrls = paymentLogoUrlCandidates(imagePath);
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: DecoratedBox(
          decoration: BoxDecoration(color: backgroundColor),
          child: Padding(
            padding: padding,
            child: Center(
              child: _paymentLogoWithFallback(
                urls: imageUrls,
                fallbackColor: fallbackColor,
                fallbackSize: fallbackSize,
                fit: fit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Trkalthoel extends StatelessWidget {
  final String image;
  final String namer;
  final bool selected;
  final VoidCallback onTap;

  const Trkalthoel({
    super.key,
    required this.image,
    required this.namer,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: selected
              ? branding.accent.withValues(alpha: 0.1)
              : branding.cardBg,
          border: Border.all(
            color: selected
                ? branding.accent
                : branding.accent.withValues(alpha: 0.18),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? branding.accent.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: selected ? 14 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          child: Row(
            children: [
              // ── Logo from API ──────────────────────────────────────
              RoundedLogoImage(
                imagePath: image,
                width: 46.w,
                height: 46.h,
                radius: 14.r,
                fit: BoxFit.contain,
                fallbackColor: branding.accent.withValues(alpha: 0.5),
                fallbackSize: 26.sp,
              ),

              SizedBox(width: 9.w),

              // ── Name ──────────────────────────────────────────────
              Expanded(
                child: Text(
                  namer,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: selected ? branding.accent : branding.primaryText,
                    height: 1.25,
                  ),
                ),
              ),

              // ── Selected check ────────────────────────────────────
              if (selected)
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: Container(
                    width: 18.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: branding.buildHeaderGradient(),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 11.sp,
                      color: branding.buttonText,
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

// ── Legacy variants ──────────────────────────────────────────────────────────

Widget buildRowItem({
  required String namer,
  required String image,
  Color? color,
}) {
  final branding = appBrandingNotifier.value;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      SizedBox(width: 10.w),
      Expanded(
        child: Text(
          namer,
          maxLines: 1,
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cairo(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: branding.primaryText,
          ),
        ),
      ),
      SizedBox(width: 10.w),
      RoundedLogoImage(
        imagePath: image,
        width: 44.w,
        height: 44.h,
        radius: 14.r,
        fit: BoxFit.contain,
        fallbackColor: branding.hintText,
        fallbackSize: 25.sp,
      ),
      SizedBox(width: 12.w),
    ],
  );
}

class Trkalthoel2 extends StatelessWidget {
  final String image;
  final String namer;
  const Trkalthoel2({super.key, required this.image, required this.namer});

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11.0.w, vertical: 8.h),
      child: Container(
        height: 46.h,
        width: 160.w,
        decoration: BoxDecoration(
          color: branding.link,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: branding.iconPrimary),
        ),
        child: buildRowItem(namer: namer, image: image),
      ),
    );
  }
}

class Trkalthoe3 extends StatelessWidget {
  final String image;
  final String namer;
  const Trkalthoe3({super.key, required this.image, required this.namer});

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.h),
      child: Container(
        height: 46.h,
        width: 160.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: branding.iconPrimary),
        ),
        child: buildRowItem(namer: namer, image: image),
      ),
    );
  }
}

class Trkalthoel4 extends StatelessWidget {
  final String image;
  final String namer;
  const Trkalthoel4({super.key, required this.image, required this.namer});

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 8.h),
      child: Container(
        height: 46.h,
        width: 160.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: branding.iconPrimary),
        ),
        child: buildRowItem(namer: namer, image: image),
      ),
    );
  }
}
