import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/app_branding.dart';

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
    final imageUrl = '${ApiService.baseURL}/$image';

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
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              // ── Logo from API ──────────────────────────────────────
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(6.r),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                          color: branding.accent,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 20.sp,
                    color: branding.accent.withValues(alpha: 0.5),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              // ── Name ──────────────────────────────────────────────
              Expanded(
                child: Text(
                  namer,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: selected ? branding.accent : branding.primaryText,
                    height: 1.35,
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

Widget buildRowItem({required String namer, required String image, Color? color}) {
  final branding = appBrandingNotifier.value;
  final imageUrl = '${ApiService.baseURL}/$image';
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
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          imageUrl,
          height: 30.h,
          width: 45.w,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.account_balance_wallet, size: 25.sp, color: branding.hintText),
        ),
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