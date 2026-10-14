import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/technical_support/data/cubite/cubite.dart';
import 'package:usdt/featue/technical_support/data/cubite/cubite_state.dart';
import 'package:usdt/featue/technical_support/data/model.dart';

class TechniclSupport extends StatefulWidget {
  const TechniclSupport({super.key});

  @override
  State<TechniclSupport> createState() => _TechniclSupportState();
}

class _TechniclSupportState extends State<TechniclSupport> {
  final Set<int> _expandedFaqs = {};

  @override
  void initState() {
    super.initState();
    context.read<SupportCubit>().fetchSupportContent();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final branding = appBrandingNotifier.value;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          final contact = state is SupportSuccess
              ? state.data.data?.contactInfo
              : null;
          final phones = _phonesForContact(contact);
          final String? wa = phones.isNotEmpty ? phones[0] : null;
          final String? tg = phones.length > 1 ? phones[1] : null;
          final showFabs = wa != null || tg != null;

          return Scaffold(
            backgroundColor: branding.screenBg,
            floatingActionButton: showFabs
                ? Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: _floatingChatButtons(
                      context,
                      branding,
                      whatsappRaw: wa,
                      telegramRaw: tg,
                    ),
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Column(
              children: [
                // ── Gradient Header ─────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    gradient: branding.buildHeaderGradient(),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
                      child: Center(
                        child: Text(
                          AppTranslations.getText(context, 'technical_support'),
                          style: GoogleFonts.cairo(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.buttonText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Body ────────────────────────────────────────────────
                Expanded(
                  child: _buildMainContent(
                    context,
                    state,
                    branding,
                    contact,
                    whatsappDisplay: wa,
                    telegramDisplay: tg,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<String> _phonesForContact(ContactInfoModel? contact) {
    if (contact?.mobilePhones != null && contact!.mobilePhones.isNotEmpty) {
      return contact.mobilePhones;
    }
    return const ['+963 994 000 981'];
  }

  Widget _buildMainContent(
    BuildContext context,
    SupportState state,
    AppBrandingConfig branding,
    ContactInfoModel? contact, {
    String? whatsappDisplay,
    String? telegramDisplay,
  }) {
    if (state is SupportLoading) {
      return Center(
        child: CircularProgressIndicator(color: branding.iconPrimary),
      );
    }

    if (state is SupportFailure) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: branding.iconPrimary,
            ),
            SizedBox(height: 12.h),
            Text(
              state.error,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                color: branding.secondaryText,
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () => context.read<SupportCubit>().fetchSupportContent(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: branding.buildButtonDecoration(radius: 12),
                child: Text(
                  AppTranslations.getText(context, 'retry'),
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: branding.buttonText,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is SupportSuccess) {
      final data = state.data.data;
      final faqs = data?.faqs ?? [];

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (faqs.isNotEmpty) ...[
              _sectionHeader(
                context,
                branding,
                icon: Icons.quiz_outlined,
                title: AppTranslations.getText(context, 'faq'),
              ),
              SizedBox(height: 12.h),
              ...faqs.asMap().entries.map(
                (e) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _faqCard(
                    context,
                    branding,
                    Localizations.localeOf(context).languageCode == 'ar',
                    e.key,
                    e.value,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
            _sectionHeader(
              context,
              branding,
              icon: Icons.list_alt_rounded,
              title: AppTranslations.getText(context, 'sending_instructions'),
            ),
            SizedBox(height: 12.h),
            _stepsCard(context, branding),
            SizedBox(height: 24.h),
            _contactCard(
              context,
              branding,
              contact,
              whatsappDisplay: whatsappDisplay,
              telegramDisplay: telegramDisplay,
            ),
            SizedBox(height: 88.h),
          ],
        ),
      );
    }

    return const SizedBox();
  }

  Widget _floatingChatButtons(
    BuildContext context,
    AppBrandingConfig branding, {
    required String? whatsappRaw,
    required String? telegramRaw,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (telegramRaw != null && telegramRaw.trim().isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Tooltip(
              message: AppTranslations.getText(context, 'contact_telegram'),
              child: Material(
                elevation: 6,
                shadowColor: Colors.black38,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                color: const Color(0xFF2AABEE),
                child: InkWell(
                  onTap: () => _openTelegram(telegramRaw),
                  child: SizedBox(
                    width: 56.r,
                    height: 56.r,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.telegram,
                        color: Colors.white,
                        size: 25.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (whatsappRaw != null && whatsappRaw.trim().isNotEmpty)
          Tooltip(
            message: AppTranslations.getText(context, 'contact_whatsapp'),
            child: Material(
              elevation: 6,
              shadowColor: Colors.black38,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              color: const Color(0xFF25D366),
              child: InkWell(
                onTap: () => _openWhatsApp(whatsappRaw),
                child: SizedBox(
                  width: 56.r,
                  height: 56.r,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 27.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openWhatsApp(String raw) async {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;
    final uri = Uri.parse('https://wa.me/$digits');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _openTelegram(String raw) async {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return;

    if (trimmed.startsWith('@') ||
        RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{3,}$').hasMatch(trimmed)) {
      final u = trimmed.startsWith('@') ? trimmed.substring(1) : trimmed;
      try {
        await launchUrl(
          Uri.parse('https://t.me/$u'),
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {}
      return;
    }

    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;
    try {
      await launchUrl(
        Uri.parse('https://t.me/+$digits'),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
  }

  Widget _sectionHeader(
    BuildContext context,
    AppBrandingConfig branding, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            gradient: branding.buildHeaderGradient(),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: branding.buttonText, size: 18),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: branding.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _faqCard(
    BuildContext context,
    AppBrandingConfig branding,
    bool isArabic,
    int index,
    FaqModel faq,
  ) {
    final isExpanded = _expandedFaqs.contains(index);
    final question = isArabic ? faq.questionAr : faq.questionEn;
    final answer = isArabic ? faq.answerAr : faq.answerEn;

    return GestureDetector(
      onTap: () => setState(() {
        if (isExpanded) {
          _expandedFaqs.remove(index);
        } else {
          _expandedFaqs.add(index);
        }
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
        decoration: BoxDecoration(
          color: branding.cardBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isExpanded
                ? branding.iconPrimary.withValues(alpha: 0.5)
                : branding.cardBorder.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: branding.iconPrimary.withValues(
                alpha: isExpanded ? 0.08 : 0.03,
              ),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: branding.iconPrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 15,
                      color: branding.iconPrimary,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      question,
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: branding.primaryText,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeInOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: branding.iconPrimary,
                      size: 22,
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 340),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                child: isExpanded
                    ? Column(
                        key: ValueKey<int>(index),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10.h),
                          Divider(color: branding.divider, height: 1),
                          SizedBox(height: 10.h),
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) =>
                                Opacity(opacity: value, child: child),
                            child: Text(
                              answer,
                              style: GoogleFonts.cairo(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: branding.secondaryText,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepsCard(BuildContext context, AppBrandingConfig branding) {
    final steps = [
      AppTranslations.getText(context, 'step_1_select_recipient'),
      AppTranslations.getText(context, 'step_2_enter_amount'),
      AppTranslations.getText(context, 'step_3_confirm_operation'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: branding.cardBorder.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: branding.iconPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: steps.asMap().entries.map((e) {
          final isLast = e.key == steps.length - 1;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        gradient: branding.buildHeaderGradient(),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${e.key + 1}',
                          style: GoogleFonts.cairo(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.buttonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        e.value,
                        style: GoogleFonts.cairo(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: branding.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 16.w,
                  endIndent: 16.w,
                  color: branding.divider,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _contactCard(
    BuildContext context,
    AppBrandingConfig branding,
    ContactInfoModel? contact, {
    String? whatsappDisplay,
    String? telegramDisplay,
  }) {
    final email = contact?.email;
    final showChannels =
        (whatsappDisplay != null && whatsappDisplay.trim().isNotEmpty) ||
        (telegramDisplay != null && telegramDisplay.trim().isNotEmpty);

    return Container(
      decoration: BoxDecoration(
        gradient: branding.buildHeaderGradient(),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: branding.iconPrimary.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 42.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: branding.buttonText.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: branding.buttonText.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: branding.buttonText,
                    size: 22,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppTranslations.getText(context, 'contact_us'),
                        style: GoogleFonts.cairo(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: branding.buttonText,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        AppTranslations.getText(context, 'technical_support'),
                        style: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: branding.buttonText.withValues(alpha: 0.8),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Divider(
              color: branding.buttonText.withValues(alpha: 0.18),
              height: 1,
            ),
            SizedBox(height: 14.h),

            if (email != null && email.isNotEmpty)
              _contactTile(
                context: context,
                branding: branding,
                icon: const Icon(Icons.email_outlined),
                label: AppTranslations.getText(context, 'email'),
                value: email,
                copyValue: email,
                ltrValue: true,
                onTap: () => _openEmailComposer(email),
              ),

            if (whatsappDisplay != null && whatsappDisplay.trim().isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: _contactTile(
                  context: context,
                  branding: branding,
                  icon: const FaIcon(FontAwesomeIcons.whatsapp),
                  label: AppTranslations.getText(context, 'contact_whatsapp'),
                  value: whatsappDisplay,
                  copyValue: whatsappDisplay,
                  ltrValue: true,
                  onTap: () => _openWhatsApp(whatsappDisplay),
                ),
              ),
            if (telegramDisplay != null && telegramDisplay.trim().isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: _contactTile(
                  context: context,
                  branding: branding,
                  icon: const FaIcon(FontAwesomeIcons.telegram),
                  label: AppTranslations.getText(context, 'contact_telegram'),
                  value: telegramDisplay,
                  copyValue: telegramDisplay,
                  ltrValue: true,
                  onTap: () => _openTelegram(telegramDisplay),
                ),
              ),
            if (showChannels) ...[
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: branding.buttonText.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: branding.buttonText.withValues(alpha: 0.85),
                      size: 16,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        AppTranslations.getText(
                          context,
                          'support_floating_chat_hint',
                        ),
                        style: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: branding.buttonText.withValues(alpha: 0.9),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openEmailComposer(String address) async {
    final trimmed = address.trim();
    if (trimmed.isEmpty) return;
    final uri = Uri(scheme: 'mailto', path: trimmed);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _copyToClipboard(BuildContext context, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    Clipboard.setData(ClipboardData(text: trimmed));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppTranslations.getTextStatic(context, 'copied_to_clipboard'),
          style: GoogleFonts.cairo(fontSize: 14.sp),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _contactTile({
    required BuildContext context,
    required AppBrandingConfig branding,
    required Widget icon,
    required String label,
    required String value,
    required String copyValue,
    bool ltrValue = false,
    VoidCallback? onTap,
  }) {
    final valueText = Text(
      value,
      style: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: branding.buttonText,
        height: 1.2,
        letterSpacing: 0.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    return Material(
      color: branding.buttonText.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(14.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => _copyToClipboard(context, copyValue),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: branding.buttonText.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(
                      color: branding.buttonText,
                      size: 17.sp,
                    ),
                    child: icon,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: branding.buttonText.withValues(alpha: 0.75),
                        height: 1.1,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ltrValue
                        ? Directionality(
                            textDirection: TextDirection.ltr,
                            child: valueText,
                          )
                        : valueText,
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Material(
                color: branding.buttonText.withValues(alpha: 0.16),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _copyToClipboard(context, copyValue),
                  child: Tooltip(
                    message: AppTranslations.getTextStatic(context, 'copy'),
                    child: SizedBox(
                      width: 34.r,
                      height: 34.r,
                      child: Center(
                        child: Icon(
                          Icons.copy_rounded,
                          color: branding.buttonText,
                          size: 16.sp,
                        ),
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
}
