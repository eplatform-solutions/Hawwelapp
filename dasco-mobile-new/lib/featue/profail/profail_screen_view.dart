// lib/featue/profail/profail_screen_view.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:url_launcher/url_launcher.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/feature_flags.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/localization/lang_cubit.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/featue/Two-factor_authentication/view.dart';
import 'package:hawwel/featue/auth/login/login_screen_view.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/resst_passwrd/rest_password_n_.dart';
import 'package:hawwel/featue/idintity_veryfation/idinty_verv.dart';
import 'package:hawwel/featue/profail/block.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit_stat.dart';
import 'package:hawwel/featue/profail/data/cubit_image/cubi.dart';
import 'package:hawwel/featue/profail/data/cubit_image/cubit_stat.dart';
import 'package:hawwel/featue/profail/data/modal.dart';
import 'package:hawwel/featue/profail/edit_information.dart';
import 'package:hawwel/featue/technical_support/technicle_support.dart';
import 'package:hawwel/constans/api_servise.dart';

class Profail extends StatefulWidget {
  final VoidCallback onViewTransactions;
  const Profail({super.key, required this.onViewTransactions});

  @override
  State<Profail> createState() => _ProfailState();
}

class _ProfailState extends State<Profail> {
  static const String _deleteAccountRequestEndpoint = '/users/delete-request';

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
      child: BlocListener<Userinfogcubit, UserinfoState>(
        listener: (context, state) async {
          if (state is UserinfoFailureState && state.statusCode == 401) {
            final expiredMessage = AppTranslations.getTextStatic(
              context,
              'session_expired_login_again',
            );
            await Functions().deleteToken();
            if (!context.mounted) return;
            _showErrorSnackBar(context, expiredMessage);
            await Future<void>.delayed(const Duration(milliseconds: 350));
            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Loginview()),
              (_) => false,
            );
            return;
          }
          if (state is UserinfoFailureState) {
            if (!context.mounted) return;
            _showErrorSnackBar(context, state.error);
          }
        },
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
                    SizedBox(height: 16.h),

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
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
          child: Column(
            children: [
              SizedBox(
                height: 38.r,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppTranslations.getText(context, 'profile'),
                        style: GoogleFonts.cairo(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.buttonText,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: GestureDetector(
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              BlocBuilder<Userinfogcubit, UserinfoState>(
                builder: (context, state) {
                  if (state is UserinfoInitialState ||
                      state is UserinfoLoadingState) {
                    final avatarFirstInRow = !isArabic;
                    final avatar = _buildAvatarSection(
                      branding,
                      cameraOnStartSide: avatarFirstInRow,
                    );
                    final shimmer = Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(double.infinity, 18.h, branding),
                          SizedBox(height: 8.h),
                          _shimmerBox(120.w, 13.h, branding),
                        ],
                      ),
                    );
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: avatarFirstInRow
                          ? [avatar, SizedBox(width: 14.w), shimmer]
                          : [shimmer, SizedBox(width: 14.w), avatar],
                    );
                  }
                  if (state is UserinfoSuccessState) {
                    final user = state.user;
                    final displayName = _buildDisplayName(user);
                    final isNameArabic = _containsArabicScript(displayName);
                    // Under RTL, first Row child is on the right — put info first so
                    // name sits on the right and avatar on the left in Arabic.
                    final avatarFirstInRow = !isArabic;

                    final avatar = _buildAvatarSection(
                      branding,
                      cameraOnStartSide: avatarFirstInRow,
                    );
                    final info = _buildProfileInfoSection(
                      context,
                      branding,
                      user,
                      displayName,
                      isNameArabic,
                    );

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: avatarFirstInRow
                          ? [
                              avatar,
                              SizedBox(width: 14.w),
                              Expanded(child: info),
                            ]
                          : [
                              Expanded(child: info),
                              SizedBox(width: 14.w),
                              avatar,
                            ],
                    );
                  }
                  if (state is UserinfoFailureState) {
                    final avatarFirstInRow = !isArabic;
                    final avatar = _buildAvatarSection(
                      branding,
                      cameraOnStartSide: avatarFirstInRow,
                    );
                    final failureContent = Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppTranslations.getTextStatic(
                              context,
                              'session_start_failed',
                            ),
                            style: GoogleFonts.cairo(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.buttonText,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: () =>
                                context.read<Userinfogcubit>().fetchUserInfo(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: branding.buttonText.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                AppTranslations.getTextStatic(context, 'retry'),
                                style: GoogleFonts.cairo(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: branding.buttonText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: avatarFirstInRow
                          ? [avatar, SizedBox(width: 14.w), failureContent]
                          : [failureContent, SizedBox(width: 14.w), avatar],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(
    dynamic branding, {
    required bool cameraOnStartSide,
  }) {
    return Stack(
      clipBehavior: Clip.none,
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
                  } else if (apiImage != null && apiImage.isNotEmpty) {
                    final finalUrl = apiImage.startsWith('http')
                        ? apiImage
                        : buildImageUrlFromApiPath(apiImage);
                    imageProvider = NetworkImage(finalUrl);
                  }

                  return Container(
                    width: 84.r,
                    height: 84.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: branding.buttonText.withValues(alpha: 0.2),
                      border: Border.all(
                        color: branding.buttonText.withValues(alpha: 0.6),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
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
        Positioned(
          bottom: 0,
          right: cameraOnStartSide ? null : 0,
          left: cameraOnStartSide ? 0 : null,
          child: GestureDetector(
            onTap: _pickAndUploadImage,
            child: Container(
              width: 28.r,
              height: 28.r,
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
                size: 13,
                color: branding.iconPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoSection(
    BuildContext context,
    dynamic branding,
    StudentInfo user,
    String displayName,
    bool isNameArabic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          textAlign: TextAlign.start,
          textDirection:
              isNameArabic ? TextDirection.rtl : TextDirection.ltr,
          style: (isNameArabic ? GoogleFonts.cairo : GoogleFonts.inter)(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: branding.buttonText,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.phone_iphone_rounded,
              size: 13,
              color: branding.buttonText.withValues(alpha: 0.75),
            ),
            SizedBox(width: 5.w),
            Flexible(
              child: Text(
                user.mobilePhone,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  color: branding.buttonText.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        _buildInfoPillsRow(
          context,
          branding,
          user: user,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Info pills (email + account number)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildInfoPillsRow(
    BuildContext context,
    dynamic branding, {
    required StudentInfo user,
  }) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        // Email pill
        if (kEmailFeaturesEnabled)
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
      // Two-factor authentication is not offered from the app any more: the
      // email channel was retired and SMS cannot reach every market, so
      // enabling it only locked users out.
      if (kEmailFeaturesEnabled)
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
        icon: Icons.gavel_rounded,
        label: 'Legal & Privacy',
        onTap: () => _showLegalPrivacyDialog(context, branding, isArabic),
      ),
      _SettingItem(
        icon: Icons.delete_forever_rounded,
        label: isArabic ? 'حذف الحساب' : 'Delete account',
        onTap: () => _showDeleteAccountDialog(context, branding, isArabic),
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
  Future<void> _openDeleteAccountPage(BuildContext context) async {
    final uri = Uri.parse('https://hawwelapp.com/delete-account');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      _showErrorSnackBar(
        context,
        Localizations.localeOf(context).languageCode == 'ar'
            ? 'تعذر فتح صفحة حذف الحساب'
            : 'Unable to open delete account page',
      );
    }
  }

  Future<void> _openLegalUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      _showErrorSnackBar(
        context,
        Localizations.localeOf(context).languageCode == 'ar'
            ? 'تعذر فتح الرابط'
            : 'Unable to open link',
      );
    }
  }

  void _showLegalPrivacyDialog(
    BuildContext context,
    dynamic branding,
    bool isArabic,
  ) {
    final links = [
      (
        isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
        'https://hawwelapp.com/privacy',
      ),
      (
        isArabic ? 'الشروط والأحكام' : 'Terms',
        'https://hawwelapp.com/terms',
      ),
      (
        isArabic ? 'سياسة AML/KYC' : 'AML/KYC',
        'https://hawwelapp.com/aml-kyc',
      ),
      (isArabic ? 'الدعم' : 'Support', 'https://hawwelapp.com/support'),
      (isArabic ? 'تواصل معنا' : 'Contact', 'https://hawwelapp.com/contact'),
      (
        isArabic ? 'حذف الحساب' : 'Delete Account',
        'https://hawwelapp.com/delete-account',
      ),
    ];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: branding.screenBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Legal & Privacy',
          style: GoogleFonts.cairo(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: branding.primaryText,
          ),
        ),
        content: SizedBox(
          width: 320.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: links
                .map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item.$1,
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: branding.primaryText,
                      ),
                    ),
                    trailing: Icon(
                      isArabic
                          ? Icons.arrow_back_ios_new_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: branding.hintText,
                    ),
                    onTap: () {
                      Navigator.pop(dialogContext);
                      _openLegalUrl(context, item.$2);
                    },
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppTranslations.getText(context, 'cancel'),
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: branding.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _submitDeleteAccountRequest() async {
    try {
      final api = ApiService(dio: Dio());
      final response = await api.postdata(
        endpoint: _deleteAccountRequestEndpoint,
        data: const <String, dynamic>{},
        needtoken: true,
      );
      final payload = response.data;
      if (payload is! Map<String, dynamic> || payload['error'] == true) {
        return false;
      }
      final data = payload['data'];
      final alreadyPending =
          data is Map && data['alreadyPending'] == true;
      if (!mounted) return true;
      _showSuccessSnackBar(
        context,
        AppTranslations.getTextStatic(
          context,
          alreadyPending
              ? 'delete_account_request_already_pending'
              : 'delete_account_request_received',
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  void _showDeleteAccountDialog(
    BuildContext context,
    dynamic branding,
    bool isArabic,
  ) {
    var isSubmitting = false;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                  Icons.delete_forever_rounded,
                  color: branding.error,
                  size: 28.sp,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                isArabic ? 'حذف الحساب' : 'Delete account',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: branding.primaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                isArabic
                    ? 'يمكنك طلب حذف حسابك وبياناتك الشخصية. قد نحتفظ ببعض السجلات لأسباب قانونية أو امتثالية أو أمنية أو لمنع الاحتيال أو النزاعات. حذف التطبيق من الهاتف لا يعني حذف الحساب.'
                    : 'You can request deletion of your account and personal data. Some records may be retained for legal, compliance, security, fraud-prevention, or dispute reasons. Deleting the app does not delete your account.',
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
                      onTap: isSubmitting
                          ? null
                          : () => Navigator.pop(dialogContext),
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
                      onTap: isSubmitting
                          ? null
                          : () async {
                              setDialogState(() => isSubmitting = true);
                              final submitted = await _submitDeleteAccountRequest();
                              if (!dialogContext.mounted) return;
                              if (submitted) {
                                Navigator.pop(dialogContext);
                                return;
                              }
                              setDialogState(() => isSubmitting = false);
                              if (!mounted) return;
                              _showErrorSnackBar(
                                context,
                                AppTranslations.getTextStatic(
                                  context,
                                  'delete_account_request_failed',
                                ),
                              );
                            },
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          color: branding.error.withValues(
                            alpha: isSubmitting ? 0.7 : 1,
                          ),
                        ),
                        child: Center(
                          child: isSubmitting
                              ? SizedBox(
                                  width: 20.r,
                                  height: 20.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  AppTranslations.getTextStatic(
                                    context,
                                    'delete_account_submit_request',
                                  ),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    fontSize: 13.sp,
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
              SizedBox(height: 12.h),
              TextButton(
                onPressed: isSubmitting
                    ? null
                    : () {
                        Navigator.pop(dialogContext);
                        _openDeleteAccountPage(this.context);
                      },
                child: Text(
                  AppTranslations.getTextStatic(
                    context,
                    'delete_account_web_fallback',
                  ),
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: branding.accent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      final reason = (kyc.decisionReason ?? '').trim();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KycStatusPage(
            status: status,
            reason: reason.isEmpty
                ? AppTranslations.getTextStatic(context, 'kyc_no_reason')
                : reason,
          ),
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
      _showSuccessSnackBar(
        context,
        AppTranslations.getTextStatic(context, 'kyc_verified_message'),
      );
      return;
    }

    if (status == 'cancel-blocked' || status == 'remove-verified') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => idintyview()));
      return;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────
  static final RegExp _arabicScriptPattern = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]',
  );

  bool _containsArabicScript(String text) {
    return _arabicScriptPattern.hasMatch(text);
  }

  String _buildDisplayName(StudentInfo user) {
    final first = user.name.trim();
    final last = user.nickname.trim();
    if (first.isEmpty && last.isEmpty) return '';
    if (first.isEmpty) return last;
    if (last.isEmpty) return first;
    return '$first $last';
  }

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
      case 'cancel-blocked':
        return AppTranslations.getText(context, 'cancel-blocked');
      case 'remove-verified':
        return AppTranslations.getText(context, 'remove-verified');
      default:
        return AppTranslations.getText(context, 'kyc_not_verified');
    }
  }

  Color _kycColor(String status, dynamic branding) {
    switch (status) {
      case 'verified':
        return branding.success;
      case 'under-review':
        return const Color(0xFFFFA726);
      case 'cancel-blocked':
      case 'remove-verified':
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
        size: 44,
        color: branding.buttonText.withValues(alpha: 0.8),
      ),
    );
  }
}
