import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/country_defaults_helper.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/falidator.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/style.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/featue/auth/login/login_screen_view.dart';
import 'package:hawwel/featue/Transfer_details/Transfer_details_view.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/login/widjt/textfildlogin.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit_stat.dart';

import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';

import 'package:hawwel/featue/sender_information/data/repo/cubit/cubit.dart';
import 'package:hawwel/featue/sender_information/data/repo/cubit/cubit_state.dart';

class Senderinformation extends StatefulWidget {
  const Senderinformation({super.key});

  @override
  State<Senderinformation> createState() => _SenderinformationState();
}

class _SenderinformationState extends State<Senderinformation>
    with SingleTickerProviderStateMixin {
  TextEditingController username = TextEditingController();
  TextEditingController phon = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    context.read<ReceiversDisplayCubit>().getAllReceiversDisplay();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    username.dispose();
    phon.dispose();
    super.dispose();
  }

  String countryEmoji(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  String buildFullPhoneNumber({
    required String phone,
    required Country? country,
  }) {
    if (country == null) return phone.trim();
    return buildPhoneNumberWithCountryCode(
      phone: phone,
      phoneCode: country.phoneCode,
    );
  }

  Country? selectedCountry;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final countryState = context.watch<CountriesCubit>().state;
    Country? pickerCountry;
    if (countryState is CountriesSuccess) {
      pickerCountry = Country.parse(countryState.selected.code);
    }

    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: branding.screenBg,
      body: BlocListener<ReceiversDisplayCubit, ReceiversDisplayState>(
        listener: (context, state) async {
          if (state is ReceiversDisplayFailure && state.statusCode == 401) {
            await Functions().deleteToken();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                content: CustomSnackBar(
                  backgroundColor: branding.error,
                  message: AppTranslations.getTextStatic(
                    context,
                    'session_expired_login_again',
                  ),
                  imagePath: AppImages.eerorrimage,
                ),
              ),
            );
            await Future<void>.delayed(const Duration(milliseconds: 350));
            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Loginview()),
              (_) => false,
            );
          }
        },
        child: Column(
          children: [
          // ── Header ──────────────────────────────────────────────
          _buildHeader(context, branding, isArabic),

          // ── Body ────────────────────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Section label ─────────────────────────
                        _sectionLabel(
                          context,
                          branding,
                          isArabic,
                          icon: Icons.person_outline_rounded,
                          text: AppTranslations.getText(
                            context,
                            'delivery_information',
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ── Full Name Field ────────────────────────
                        _buildInputCard(
                          branding: branding,
                          child: TextFieldCustom(
                            validator: (v) => validateFullName(v, context),
                            controller: username,
                            hintText: AppTranslations.getText(
                              context,
                              'full_name',
                            ),
                            hintStyle: AppStyle.meduim16grey,
                            prefixIcon: Icon(
                              Icons.badge_outlined,
                              color: branding.iconPrimary,
                              size: 20,
                            ),
                          ),
                        ),

                        SizedBox(height: 14.h),

                        // ── Phone Field ────────────────────────────
                        _buildInputCard(
                          branding: branding,
                          child: Row(
                            children: [
                              // Country code badge
                              Container(
                                height: 50.h,
                                width: 80.w,
                                margin: EdgeInsetsDirectional.only(
                                  end: isArabic ? 6.w : 8.w,
                                ),
                                decoration: BoxDecoration(
                                  color: branding.badge.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: branding.iconPrimary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    pickerCountry != null
                                        ? CountryDefaultsHelper.countryFlag(
                                            pickerCountry.countryCode,
                                            size: 16,
                                          )
                                        : const Text(
                                            '🌍',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      pickerCountry != null
                                          ? isArabic
                                                ? '${pickerCountry.phoneCode}+'
                                                : '+${pickerCountry.phoneCode}'
                                          : '',
                                      style: GoogleFonts.cairo(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: branding.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Phone input
                              Expanded(
                                child: TextFieldCustom(
                                  validator: (v) =>
                                      validatePhoneNumber(v, context),
                                  controller: phon,
                                  hintText: AppTranslations.getText(
                                    context,
                                    'recipient_phone',
                                  ),
                                  type: TextInputType.phone,
                                  hintStyle: AppStyle.meduim16grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Saved Receivers ────────────────────────
                        BlocBuilder<
                          ReceiversDisplayCubit,
                          ReceiversDisplayState
                        >(
                          builder: (context, state) {
                            if (state is ReceiversDisplayLoading) {
                              return Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: Center(
                                  child: SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: branding.iconPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (state is ReceiversDisplaySuccess) {
                              final String? selectedDialCode =
                                  pickerCountry != null
                                  ? '+${pickerCountry.phoneCode}'
                                  : null;

                              final filteredReceivers = selectedDialCode == null
                                  ? state.receivers
                                  : state.receivers.where((r) {
                                      final phone = r.mobilePhone.replaceAll(
                                        ' ',
                                        '',
                                      );
                                      return phone.startsWith(selectedDialCode);
                                    }).toList();

                              if (filteredReceivers.isEmpty) {
                                return const SizedBox();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24.h),
                                  _sectionLabel(
                                    context,
                                    branding,
                                    isArabic,
                                    icon: Icons.bookmarks_outlined,
                                    text: AppTranslations.getText(
                                      context,
                                      'saved_receivers',
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxHeight: 220.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: branding.inputBorder.withValues(
                                        alpha: 0.6,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: branding.iconPrimary.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: filteredReceivers.length,
                                        separatorBuilder: (_, __) => Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: branding.iconPrimary
                                              .withValues(alpha: 0.1),
                                        ),
                                        itemBuilder: (context, index) {
                                          final receiver =
                                              filteredReceivers[index];
                                          final initials = receiver.fullName
                                              .trim()
                                              .split(' ')
                                              .take(2)
                                              .map(
                                                (w) => w.isNotEmpty
                                                    ? w[0].toUpperCase()
                                                    : '',
                                              )
                                              .join();

                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                username.text =
                                                    receiver.fullName;
                                                final phone = receiver
                                                    .mobilePhone
                                                    .replaceAll(' ', '');
                                                if (pickerCountry != null &&
                                                    phone.startsWith(
                                                      '+${pickerCountry.phoneCode}',
                                                    )) {
                                                  phon.text = phone.substring(
                                                    pickerCountry
                                                            .phoneCode
                                                            .length +
                                                        1,
                                                  );
                                                } else {
                                                  phon.text = phone;
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 14.w,
                                                vertical: 12.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  // Avatar circle
                                                  Container(
                                                    width: 38.w,
                                                    height: 38.h,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: branding
                                                          .buildHeaderGradient(),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        initials,
                                                        style:
                                                            GoogleFonts.cairo(
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: branding
                                                                  .buttonText,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  // Name & phone
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          isArabic
                                                          ? CrossAxisAlignment
                                                                .end
                                                          : CrossAxisAlignment
                                                                .start,
                                                      children: [
                                                        Text(
                                                          receiver.fullName,
                                                          style:
                                                              GoogleFonts.cairo(
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: branding
                                                                    .primaryText,
                                                              ),
                                                        ),
                                                        SizedBox(height: 2.h),
                                                        Text(
                                                          receiver.mobilePhone,
                                                          style:
                                                              GoogleFonts.cairo(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: branding
                                                                    .hintText,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    isArabic
                                                        ? Icons
                                                              .arrow_back_ios_new_rounded
                                                        : Icons
                                                              .arrow_forward_ios_rounded,
                                                    size: 14,
                                                    color: branding.iconPrimary
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            if (state is ReceiversDisplayFailure) {
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  state.error,
                                  style: GoogleFonts.cairo(
                                    color: branding.error,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              );
                            }

                            return const SizedBox();
                          },
                        ),

                        SizedBox(height: 36.h),

                        // ── CTA Button ─────────────────────────────
                        _buildSendButton(
                          context,
                          branding,
                          isArabic,
                          pickerCountry,
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
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

  // ─────────────────────────────────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, dynamic branding, bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        gradient: branding.buildHeaderGradient(),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: branding.badge.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: Row(
            children: [
              // Back button
              AppBackButton(),
              Expanded(
                child: Text(
                  AppTranslations.getText(context, 'sender_data'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: isArabic ? 18.sp : 19.sp,
                    fontWeight: FontWeight.w700,
                    color: branding.buttonText,
                  ),
                ),
              ),
              // Placeholder to balance the row
              SizedBox(width: 38.w),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Section label
  // ─────────────────────────────────────────────────────────────────────────
  Widget _sectionLabel(
    BuildContext context,
    dynamic branding,
    bool isArabic, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: branding.iconPrimary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: branding.iconPrimary, size: 17),
        ),
        SizedBox(width: 10.w),
        Text(
          text,
          style: GoogleFonts.cairo(
            fontSize: isArabic ? 15.sp : 16.sp,
            fontWeight: FontWeight.w700,
            color: branding.primaryText,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Input card wrapper
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildInputCard({required dynamic branding, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: branding.screenBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: branding.badge.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: branding.iconPrimary.withValues(alpha: 0.12)),
      ),
      child: child,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Send button
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSendButton(
    BuildContext context,
    dynamic branding,
    bool isArabic,
    Country? pickerCountry,
  ) {
    return GestureDetector(
      onTap: () async {
        if (!_formKey.currentState!.validate()) return;

        final isPhoneValid = await validatePhoneWithCountry(
          phone: phon.text,
          countryCode: pickerCountry!.countryCode,
        );

        if (!context.mounted) return;

        if (!isPhoneValid) {
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
                  'mobile_number_invalid',
                ),
                imagePath: AppImages.eerorrimage,
              ),
            ),
          );
          return;
        }

        final fullPhoneNumber = buildFullPhoneNumber(
          phone: phon.text,
          country: pickerCountry,
        );

        if (!context.mounted) return;
        if (context.read<CurrencyCubit>().state.amount.isEmpty) {
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
                  'fill_all_fields',
                ),
                imagePath: AppImages.eerorrimage,
              ),
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Transferdetails(
              full_name: username.text,
              number: fullPhoneNumber,
            ),
          ),
        );
      },
      child: Container(
        height: 56.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: branding.buildHeaderGradient(),
          boxShadow: [
            BoxShadow(
              color: branding.badge.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, color: branding.buttonText, size: 18),
            SizedBox(width: 10.w),
            Text(
              AppTranslations.getText(context, 'send_amount'),
              style: GoogleFonts.cairo(
                fontSize: isArabic ? 17.sp : 18.sp,
                fontWeight: FontWeight.w700,
                color: branding.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
