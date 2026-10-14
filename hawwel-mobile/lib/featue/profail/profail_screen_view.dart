// lib/featue/profail/profail_screen_view.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/localization/lang_cubit.dart';
import 'package:usdt/constans/token.dart';
import 'package:usdt/featue/Two-factor_authentication/data/repo/repo_implmntion.dart';
import 'package:usdt/featue/Two-factor_authentication/view.dart';
import 'package:usdt/featue/auth/forgeat_password/forget_password_view.dart';
import 'package:usdt/featue/auth/login/login_screen_view.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/resst_passwrd/rest_password_n_.dart';
import 'package:usdt/featue/bootom_navigator.dart';
import 'package:usdt/featue/idintity_veryfation/idinty_verv.dart';
import 'package:usdt/featue/profail/block.dart';
import 'package:usdt/featue/profail/data/cubit/cubit.dart';
import 'package:usdt/featue/profail/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/profail/data/cubit_image/cubi.dart';
import 'package:usdt/featue/profail/data/cubit_image/cubit_stat.dart';
import 'package:usdt/featue/profail/edit_information.dart';
import 'package:usdt/featue/technical_support/technicle_support.dart';
import 'package:usdt/constans/api_servise.dart';

class Profail extends StatefulWidget {
  final VoidCallback onViewTransactions;
  const Profail({super.key, required this.onViewTransactions});

  @override
  State<Profail> createState() => _ProfailState();
}

class _ProfailState extends State<Profail> {
  @override
  void initState() {
    super.initState();
    context.read<Userinfogcubit>().fetchUserInfo();
  }

  String buildImageUrlFromApiPath(String apiPath) {
    if (apiPath.isEmpty) return '';
    if (apiPath.startsWith('http')) return apiPath;
    final base = ApiService.baseURL;
    if (apiPath.startsWith('/')) return '$base$apiPath';
    return '$base/$apiPath';
  }

  Future<File?> _compressImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = p.join(
      dir.absolute.path,
      "temp_${DateTime.now().millisecondsSinceEpoch}.jpg",
    );
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 1080,
      minHeight: 1080,
      keepExif: true,
    );
    return result != null ? File(result.path) : null;
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final File originalFile = File(picked.path);
      final File? compressedFile = await _compressImage(originalFile);
      if (compressedFile == null) return;

      final double compressedMB = await compressedFile.length() / (1024 * 1024);
      if (compressedMB > 5) {
        if (!mounted) return;
        _showErrorSnackBar(
          context,
          'الصورة لا تزال كبيرة جداً (${compressedMB.toStringAsFixed(2)} MB)',
        );
        return;
      }

      if (!mounted) return;
      await context.read<ChangeImageCubit>().updateImage(compressedFile.path);
      if (!mounted) return;
      await context.read<Userinfogcubit>().fetchUserInfo();
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(context, 'حدث خطأ أثناء المعالجة');
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ══════════════════════════════════════════════════
              // Header gradient + avatar
              // ══════════════════════════════════════════════════
              _buildHeader(context, branding, isArabic),

              // ══════════════════════════════════════════════════
              // Body content
              // ══════════════════════════════════════════════════
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // ── KYC Level card ────────────────────────
                    _buildKycCard(context, branding, isArabic),

                    SizedBox(height: 14.h),

                    // ── View transactions ──────────────────────
                    _buildViewTransactionsBtn(context, branding, isArabic),

                    SizedBox(height: 20.h),

                    // ── Settings list ──────────────────────────
                    _buildSettingsCard(context, branding, isArabic),

                    SizedBox(height: 28.h),

                    // ── Logout ─────────────────────────────────
                    _buildLogoutButton(context, branding, isArabic),

                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, dynamic branding, bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        gradient: branding.buildHeaderGradient(),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: branding.badge.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          child: Column(
            children: [
              // Top bar
              Row(
                children: [
                  Text(
                    AppTranslations.getText(context, 'profile'),
                    style: GoogleFonts.cairo(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: branding.buttonText,
                    ),
                  ),
                  const Spacer(),
                  // Edit button
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Editinformation()),
                    ),
                    child: Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        color: branding.buttonText.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.edit_rounded,
                        color: branding.buttonText,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Avatar
              Stack(
                alignment: Alignment.center,
                children: [
                  BlocBuilder<Userinfogcubit, UserinfoState>(
                    builder: (context, userState) =>
                        BlocBuilder<ChangeImageCubit, ChangeImageState>(
                          builder: (context, imgState) {
                            String? localImage;
                            if (imgState is ChangeImageSuccess) {
                              localImage = imgState.imagePath;
                            }
                            String? apiImage;
                            if (userState is UserinfoSuccessState) {
                              apiImage = userState.user.imagePath;
                            }

                            ImageProvider? imageProvider;
                            if (localImage != null &&
                                localImage.isNotEmpty &&
                                File(localImage).existsSync()) {
                              imageProvider = FileImage(File(localImage));
                            } else if (apiImage != null &&
                                apiImage.isNotEmpty) {
                              final finalUrl = apiImage.startsWith('http')
                                  ? apiImage
                                  : buildImageUrlFromApiPath(apiImage);
                              imageProvider = NetworkImage(finalUrl);
                            }

                            return Container(
                              width: 100.r,
                              height: 100.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: branding.buttonText.withValues(
                                  alpha: 0.2,
                                ),
                                border: Border.all(
                                  color: branding.buttonText.withValues(
                                    alpha: 0.6,
                                  ),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.18),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: imageProvider != null
                                    ? Image(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _AvatarFallback(branding: branding),
                                      )
                                    : _AvatarFallback(branding: branding),
                              ),
                            );
                          },
                        ),
                  ),
                  // Camera badge
                  Positioned(
                    bottom: 0,
                    right: isArabic ? null : 0,
                    left: isArabic ? 0 : null,
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Container(
                        width: 30.r,
                        height: 30.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: branding.screenBg,
                          border: Border.all(
                            color: branding.badge.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 14,
                          color: branding.iconPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.h),

              // User name + info
              BlocBuilder<Userinfogcubit, UserinfoState>(
                builder: (context, state) {
                  if (state is UserinfoLoadingState) {
                    return Column(
                      children: [
                        _shimmerBox(160.w, 18.h, branding),
                        SizedBox(height: 8.h),
                        _shimmerBox(120.w, 13.h, branding),
                      ],
                    );
                  }
                  if (state is UserinfoSuccessState) {
                    final user = state.user;
                    return Column(
                      children: [
                        Text(
                          '${user.nickname} ${user.name}',
                          style: GoogleFonts.cairo(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: branding.buttonText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_iphone_rounded,
                              size: 13,
                              color: branding.buttonText.withValues(
                                alpha: 0.75,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              user.mobilePhone,
                              textDirection: TextDirection.ltr,
                              style: GoogleFonts.cairo(
                                fontSize: 13.sp,
                                color: branding.buttonText.withValues(
                                  alpha: 0.75,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        // Info pills row
                        _buildInfoPillsRow(context, branding, isArabic, user),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Info pills (email + account number)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildInfoPillsRow(
    BuildContext context,
    dynamic branding,
    bool isArabic,
    dynamic user,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Email pill
        Container(
          constraints: BoxConstraints(maxWidth: 160.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: branding.buttonText.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.mail_rounded,
                size: 12,
                color: branding.buttonText.withValues(alpha: 0.8),
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  user.email,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: branding.buttonText.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        // Account number pill with copy
        GestureDetector(
          onTap: () async {
            final msg = AppTranslations.getTextStatic(
              context,
              'copied_to_clipboard',
            );
            await Clipboard.setData(
              ClipboardData(text: user.accountNumber.toString()),
            );
            if (!mounted) return;
            _showSuccessSnackBar(this.context, msg);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: branding.buttonText.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.badge_outlined,
                  size: 12,
                  color: branding.buttonText.withValues(alpha: 0.8),
                ),
                SizedBox(width: 5.w),
                Text(
                  '#${user.accountNumber}',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: branding.buttonText.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 5.w),
                Icon(
                  Icons.copy_rounded,
                  size: 11,
                  color: branding.buttonText.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // KYC Card
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildKycCard(BuildContext context, dynamic branding, bool isArabic) {
    return GestureDetector(
      onTap: () => _handleKycTap(context, branding),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: branding.cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: branding.cardBorder.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: branding.badge.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                gradient: branding.buildHeaderGradient(),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.getText(context, 'level'),
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      color: branding.hintText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  BlocBuilder<Userinfogcubit, UserinfoState>(
                    builder: (context, state) {
                      if (state is UserinfoSuccessState) {
                        final kycStatus = state.user.kyc?.status ?? '';
                        final label = _kycLabel(context, kycStatus);
                        final color = _kycColor(kycStatus, branding);
                        return Row(
                          children: [
                            Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              label,
                              style: GoogleFonts.cairo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ],
                        );
                      }
                      return _shimmerBox(100.w, 14.h, branding);
                    },
                  ),
                ],
              ),
            ),
            Icon(
              isArabic
                  ? Icons.arrow_back_ios_new_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: 14,
              color: branding.hintText.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // View Transactions Button
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildViewTransactionsBtn(
    BuildContext context,
    dynamic branding,
    bool isArabic,
  ) {
    return GestureDetector(
      onTap: widget.onViewTransactions,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: branding.buildHeaderGradient(),
          boxShadow: [
            BoxShadow(
              color: branding.badge.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: branding.buttonText,
              size: 18,
            ),
            SizedBox(width: 10.w),
            Text(
              AppTranslations.getText(context, 'view_transactions'),
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: branding.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Settings Card
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSettingsCard(
    BuildContext context,
    dynamic branding,
    bool isArabic,
  ) {
    final items = [
      _SettingItem(
        icon: Icons.lock_reset_rounded,
        label: AppTranslations.getText(context, 'change_password'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Restpassword()),
        ),
      ),
      _SettingItem(
        icon: Icons.security_rounded,
        label: AppTranslations.getText(context, 'enable_two_factor'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ActivationScreen()),
        ),
      ),
      _SettingItem(
        icon: Icons.headset_mic_rounded,
        label: AppTranslations.getText(context, 'technical_support'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TechniclSupport()),
        ),
      ),
      _SettingItem(
        icon: Icons.language_rounded,
        label: AppTranslations.getText(context, 'Change language'),
        onTap: () => context.read<LanguageCubit>().toggleLanguage(),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: branding.cardBorder.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: branding.badge.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(20) : Radius.zero,
                  bottom: isLast ? const Radius.circular(20) : Radius.zero,
                ),
                onTap: item.onTap,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 15.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38.r,
                        height: 38.r,
                        decoration: BoxDecoration(
                          color: branding.iconPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: Icon(
                          item.icon,
                          color: branding.iconPrimary,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          item.label,
                          style: GoogleFonts.cairo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: branding.primaryText,
                          ),
                        ),
                      ),
                      Icon(
                        isArabic
                            ? Icons.arrow_back_ios_new_rounded
                            : Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: branding.hintText.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 70.w,
                  endIndent: 18.w,
                  color: branding.cardBorder.withValues(alpha: 0.4),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Logout Button
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildLogoutButton(
    BuildContext context,
    dynamic branding,
    bool isArabic,
  ) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context, branding, isArabic),
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: branding.error.withValues(alpha: 0.4)),
          color: branding.error.withValues(alpha: 0.06),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: branding.error, size: 18),
            SizedBox(width: 10.w),
            Text(
              AppTranslations.getText(context, 'logout'),
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: branding.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Logout Dialog
  // ─────────────────────────────────────────────────────────────────────────
  void _showLogoutDialog(
    BuildContext context,
    dynamic branding,
    bool isArabic,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => AlertDialog(
        backgroundColor: branding.screenBg,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        contentPadding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 18.h),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62.r,
              height: 62.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: branding.error.withValues(alpha: 0.1),
                border: Border.all(
                  color: branding.error.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: branding.error,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              AppTranslations.getText(context, 'log out?'),
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: branding.primaryText,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppTranslations.getText(
                context,
                'Are you sure you want to log out?',
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: branding.secondaryText,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(dialogContext),
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: branding.hintText.withValues(alpha: 0.4),
                        ),
                        color: branding.inputBorder.withValues(alpha: 0.5),
                      ),
                      child: Center(
                        child: Text(
                          AppTranslations.getText(context, "cancel"),
                          style: GoogleFonts.cairo(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.hintText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(dialogContext);
                      Functions().logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const Loginview()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        color: branding.error,
                      ),
                      child: Center(
                        child: Text(
                          AppTranslations.getText(context, "confirm"),
                          style: GoogleFonts.cairo(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // KYC tap handler
  // ─────────────────────────────────────────────────────────────────────────
  void _handleKycTap(BuildContext context, dynamic branding) {
    final state = context.read<Userinfogcubit>().state;
    if (state is! UserinfoSuccessState) return;

    final kyc = state.user.kyc;
    final status = kyc?.status ?? '';

    if (kyc == null || status == '') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => idintyview()));
      return;
    }

    if (status == 'rejected' || status == 'blocked') {
      final reason = kyc.blockingReason ?? 'لم يتم إرسال سبب';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KycStatusPage(status: status, reason: reason),
        ),
      );
      return;
    }

    if (status == 'under-review') {
      _showErrorSnackBar(
        context,
        AppTranslations.getTextStatic(
          context,
          'verification_request_under_review',
        ),
      );
      return;
    }

    if (status == 'verified') {
      _showErrorSnackBar(
        context,
        AppTranslations.getTextStatic(context, 'kyc_verified_message'),
      );
      return;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────
  String _kycLabel(BuildContext context, String status) {
    switch (status) {
      case 'verified':
        return AppTranslations.getText(context, 'verified');
      case 'under-review':
        return AppTranslations.getText(context, 'under-review');
      case 'rejected':
        return AppTranslations.getText(context, 'rejected');
      case 'blocked':
        return AppTranslations.getText(context, 'blocked');
      default:
        return AppTranslations.getText(context, 'undefined');
    }
  }

  Color _kycColor(String status, dynamic branding) {
    switch (status) {
      case 'verified':
        return branding.success;
      case 'under-review':
        return const Color(0xFFFFA726);
      case 'rejected':
      case 'blocked':
        return branding.error;
      default:
        return branding.hintText;
    }
  }

  Widget _shimmerBox(double w, double h, dynamic branding) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: branding.buttonText.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final branding = appBrandingNotifier.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content: CustomSnackBar(
          backgroundColor: branding.iconPrimary,
          message: message,
          imagePath: AppImages.eerorrimage,
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    final branding = appBrandingNotifier.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content: CustomSnackBar(
          backgroundColor: branding.success,
          message: message,
          imagePath: AppImages.doneimage,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Setting Item model
// ═══════════════════════════════════════════════════════════════════════════
class _SettingItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// Avatar fallback
// ═══════════════════════════════════════════════════════════════════════════
class _AvatarFallback extends StatelessWidget {
  final dynamic branding;
  const _AvatarFallback({required this.branding});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: branding.buttonText.withValues(alpha: 0.15),
      child: Icon(
        Icons.person_rounded,
        size: 52,
        color: branding.buttonText.withValues(alpha: 0.8),
      ),
    );
  }
}
