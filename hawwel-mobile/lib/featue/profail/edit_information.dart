// edit_information.dart

import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/falidator.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/style.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/login/widjt/textfildlogin.dart';
import 'package:usdt/featue/profail/data/cubit/cubit.dart';
import 'package:usdt/featue/profail/data/cubit_put/cubit.dart';
import 'package:usdt/featue/profail/data/cubit_put/cubit_stat.dart';
import 'package:usdt/featue/profail/edit_profile_otp_page.dart';

class Editinformation extends StatefulWidget {
  const Editinformation({super.key});

  @override
  State<Editinformation> createState() => _RegsterviewState();
}

class _RegsterviewState extends State<Editinformation> {
  String? emailError;
  String? emailOtpError;
  String? phoneError;
  String? phoneOtpError;
  bool isEmailResendClicked = false;
  int emailSecondsRemaining = 60;
  bool isPhoneResendClicked = false;
  int phoneSecondsRemaining = 60;
  Timer? emailTimer;
  Timer? phoneTimer;

  final _formKey = GlobalKey<FormState>();

  void startEmailTimer() {
    setState(() {
      isEmailResendClicked = true;
      emailSecondsRemaining = 60;
    });
    emailTimer?.cancel();
    emailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (emailSecondsRemaining > 0) {
        setState(() => emailSecondsRemaining--);
      } else {
        timer.cancel();
        setState(() => isEmailResendClicked = false);
      }
    });
  }

  void startphoneTimer() {
    setState(() {
      isPhoneResendClicked = true;
      phoneSecondsRemaining = 60;
    });
    phoneTimer?.cancel();
    phoneTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (phoneSecondsRemaining > 0) {
        setState(() => phoneSecondsRemaining--);
      } else {
        timer.cancel();
        setState(() => isPhoneResendClicked = false);
      }
    });
  }

  String countryEmoji(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  Country selectedCountry = Country(
    phoneCode: '966',
    countryCode: 'SA',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Saudi Arabia',
    example: '512345678',
    displayName: 'Saudi Arabia',
    displayNameNoCountryCode: 'Saudi Arabia',
    e164Key: '',
  );

  @override
  void initState() {
    super.initState();
    context.read<UpdateInfoCubit>().emailController.clear();
    context.read<UpdateInfoCubit>().emailOtpController.clear();
    context.read<UpdateInfoCubit>().phoneController.clear();
    context.read<UpdateInfoCubit>().phoneOtpController.clear();
  }

  @override
  void dispose() {
    emailTimer?.cancel();
    phoneTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
      child: LoaderOverlay(
        child: Scaffold(
          backgroundColor: branding.screenBg,
        body: BlocListener<UpdateInfoCubit, UpdateInfoState>(
          listener: (context, state) {
            if (state is RegisterchangOTPLoading) {
              context.loaderOverlay.show();
            }

            if (state is RegisterchangOTPSent) {
              context.loaderOverlay.hide();
              final cubit = context.read<UpdateInfoCubit>();
              final bool isEmailOtp = cubit.emailController.text.isNotEmpty &&
                  cubit.phoneController.text.isEmpty;
              final String sentTo = isEmailOtp
                  ? cubit.emailController.text
                  : cubit.phoneController.text;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: EditProfileOtpPage(
                      isEmailOtp: isEmailOtp,
                      sentTo: sentTo,
                      onComplete: () {
                        // OTP page has popped itself; now pop edit_information
                        context.read<Userinfogcubit>().fetchUserInfo();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              );
            }

            if (state is RegisterchangOTPError) {
              context.loaderOverlay.hide();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                content: CustomSnackBar(
                  backgroundColor: branding.iconPrimary,
                  message: state.error,
                  imagePath: AppImages.eerorrimage,
                ),
              ));
              setState(() {
                isEmailResendClicked = false;
                isPhoneResendClicked = false;
              });
            }

            if (state is UpdateInfoFailure) {
              context.loaderOverlay.hide();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                content: CustomSnackBar(
                  backgroundColor: branding.iconPrimary,
                  message: state.error,
                  imagePath: AppImages.eerorrimage,
                ),
              ));
              setState(() {
                isEmailResendClicked = false;
                isPhoneResendClicked = false;
              });
            }
          },
          child: BlocBuilder<UpdateInfoCubit, UpdateInfoState>(
            builder: (context, state) {
              return buildRegisterUI(context, state);
            },
          ),
        ),
      ),
      ),
    );
  }

  Widget buildRegisterUI(BuildContext context, UpdateInfoState state) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final cubit = context.read<UpdateInfoCubit>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Gradient Header ─────────────────────────────────────────────
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
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: branding.buttonText.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
                          color: branding.buttonText,
                          size: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppTranslations.getText(context, 'edit information'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.buttonText,
                        ),
                      ),
                    ),
                    // Balance spacer
                    Container(width: 38.w, height: 38.h),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Info hint ──────────────────────────────────────────
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: branding.iconPrimary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: branding.iconPrimary.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: branding.iconPrimary, size: 20),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            AppTranslations.getText(context, 'edit information'),
                            style: GoogleFonts.cairo(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: branding.iconPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ── Email Section ──────────────────────────────────────
                  _sectionCard(
                    branding: branding,
                    icon: Icons.email_outlined,
                    title: AppTranslations.getText(context, 'email_hint'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email field
                        TextFieldCustom(
                          validator: (value) => emailError,
                          controller: cubit.emailController,
                          hintText: AppTranslations.getText(context, 'email_hint'),
                          type: TextInputType.emailAddress,
                          prefixIcon: GestureDetector(
                            onTap: isEmailResendClicked
                                ? null
                                : () async {
                                    startEmailTimer();
                                    await cubit.sendOtpchange();
                                  },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.h),
                              child: isEmailResendClicked
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.access_time, size: 15, color: branding.iconPrimary),
                                            SizedBox(width: 3.w),
                                            Text(
                                              isArabic
                                                  ? '${AppTranslations.getText(context, 'Resend after')}$emailSecondsRemaining${AppTranslations.getText(context, 'seconds')}  '
                                                  : '${AppTranslations.getText(context, 'Resend after')}${AppTranslations.getText(context, 'seconds')} $emailSecondsRemaining  ',
                                              style: GoogleFonts.cairo(fontSize: 11.sp, fontWeight: FontWeight.w600, color: branding.secondaryText),
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: Text(
                                            AppTranslations.getText(context, 'otp'),
                                            style: GoogleFonts.cairo(fontSize: 13.sp, fontWeight: FontWeight.w600, color: branding.iconPrimary),
                                          ),
                                        ),
                            ),
                          ),
                          hintStyle: AppStyle.meduim16grey,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Phone Section ──────────────────────────────────────
                  _sectionCard(
                    branding: branding,
                    icon: Icons.phone_outlined,
                    title: AppTranslations.getText(context, 'phone_number1'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Phone field + country code
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: TextFieldCustom(
                                  validator: (value) => phoneError,
                                  controller: cubit.phoneController,
                                  hintText: AppTranslations.getText(context, 'phone_number1'),
                                  type: TextInputType.phone,
                                  prefixIcon: GestureDetector(
                                    onTap: isPhoneResendClicked
                                        ? null
                                        : () async {
                                            final cubit = context.read<UpdateInfoCubit>();
                                            setState(() { phoneError = null; });
                                            String phoneInput = cubit.phoneController.text.trim();
                                            if (phoneInput.isEmpty) {
                                              setState(() {
                                                phoneError = AppTranslations.getTextStatic(context, 'enter_phone_number');
                                              });
                                              _formKey.currentState?.validate();
                                              return;
                                            }
                                            final fullPhoneNumber = buildPhoneNumberWithCountryCode(
                                              phone: phoneInput,
                                              phoneCode: selectedCountry.phoneCode,
                                            );
                                            final isPhoneValid = await validatePhoneWithCountry(
                                              phone: fullPhoneNumber,
                                              countryCode: selectedCountry.countryCode,
                                            );
                                            if (!isPhoneValid) {
                                              setState(() {
                                                phoneError = AppTranslations.getTextStatic(context, 'mobile_number_invalid');
                                              });
                                              _formKey.currentState?.validate();
                                              return;
                                            }
                                            final oldPhoneText = cubit.phoneController.text;
                                            cubit.submittedPhone = fullPhoneNumber;
                                            startphoneTimer();
                                            await cubit.sendOtpchangephone();
                                            cubit.phoneController.text = oldPhoneText;
                                          },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.h),
                                      child: isPhoneResendClicked
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.access_time, size: 15, color: branding.iconPrimary),
                                                    SizedBox(width: 3.w),
                                                    Text(
                                                      isArabic
                                                          ? '${AppTranslations.getText(context, 'Resend after')}$phoneSecondsRemaining${AppTranslations.getText(context, 'seconds')}  '
                                                          : '${AppTranslations.getText(context, 'Resend after')}${AppTranslations.getText(context, 'seconds')} $phoneSecondsRemaining  ',
                                                      style: GoogleFonts.cairo(fontSize: 11.sp, fontWeight: FontWeight.w600, color: branding.secondaryText),
                                                    ),
                                                  ],
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                  child: Text(
                                                    AppTranslations.getText(context, 'otp'),
                                                    style: GoogleFonts.cairo(fontSize: 13.sp, fontWeight: FontWeight.w600, color: branding.iconPrimary),
                                                  ),
                                                ),
                                    ),
                                  ),
                                  hintStyle: AppStyle.meduim16grey,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              // Country code picker button
                              GestureDetector(
                                onTap: () => _showCustomPicker(context),
                                child: Container(
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                    color: branding.cardBg,
                                    border: Border.all(color: branding.iconPrimary.withValues(alpha: 0.5)),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      selectedCountry.countryCode == "SY"
                                          ? Image.asset(AppImages.syria, width: 22.w, height: 16.h)
                                          : Text(selectedCountry.flagEmoji, style: const TextStyle(fontSize: 20)),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '+${selectedCountry.phoneCode}',
                                        textDirection: TextDirection.ltr,
                                        style: GoogleFonts.cairo(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: branding.primaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // ── Submit button ──────────────────────────────────────
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        emailError = null;
                        phoneError = null;
                      });

                      final email = cubit.emailController.text.trim();
                      final phoneInput = cubit.phoneController.text.trim();

                      if (email.isEmpty && phoneInput.isEmpty) {
                        setState(() {
                          emailError = AppTranslations.getTextStatic(context, 'enter_email_or_phone');
                        });
                        _formKey.currentState!.validate();
                        return;
                      }

                      if (email.isNotEmpty) {
                        await cubit.sendOtpchange();
                      } else {
                        // phone OTP
                        final fullPhoneNumber = buildPhoneNumberWithCountryCode(
                          phone: phoneInput,
                          phoneCode: selectedCountry.phoneCode,
                        );
                        final isPhoneValid = await validatePhoneWithCountry(
                          phone: fullPhoneNumber,
                          countryCode: selectedCountry.countryCode,
                        );
                        if (!isPhoneValid) {
                          setState(() {
                            phoneError = AppTranslations.getTextStatic(context, 'mobile_number_invalid');
                          });
                          _formKey.currentState!.validate();
                          return;
                        }
                        cubit.submittedPhone = fullPhoneNumber;
                        await cubit.sendOtpchangephone();
                      }
                    },
                    child: Container(
                      height: 56.h,
                      decoration: branding.buildButtonDecoration(radius: 16),
                      child: Center(
                        child: Text(
                          AppTranslations.getText(context, 'submit'),
                          style: GoogleFonts.cairo(fontSize: 18.sp, fontWeight: FontWeight.w700, color: branding.buttonText),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required AppBrandingConfig branding,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: branding.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: branding.cardBorder.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: branding.iconPrimary.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: branding.iconPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: branding.iconPrimary, size: 17),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.w700, color: branding.primaryText),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }

  void _showCustomPicker(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final List<Country> allCountries = CountryService().getAll();
    List<Country> filteredCountries = List.from(allCountries);
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: branding.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setInternalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: branding.divider,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    decoration: InputDecoration(
                      hintText: AppTranslations.getText(context, 'search_country'),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) {
                      setInternalState(() {
                        filteredCountries = allCountries.where((country) {
                          final String localizedName =
                              CountryLocalizations.of(context)?.countryName(countryCode: country.countryCode) ?? country.name;
                          final searchLower = val.toLowerCase();
                          return localizedName.toLowerCase().contains(searchLower) ||
                              country.name.toLowerCase().contains(searchLower) ||
                              country.phoneCode.contains(searchLower);
                        }).toList();
                      });
                    },
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        final String displayCountryName =
                            CountryLocalizations.of(context)?.countryName(countryCode: country.countryCode) ?? country.name;
                        return ListTile(
                          leading: country.countryCode == "SY"
                              ? Image.asset('asset/syrianewsyria.png', width: 30.w, height: 20.h)
                              : Text(country.flagEmoji, style: const TextStyle(fontSize: 24)),
                          title: Text(displayCountryName, style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                          trailing: Text(
                            '+${country.phoneCode}',
                            textDirection: TextDirection.ltr,
                            style: GoogleFonts.cairo(color: branding.hintText),
                          ),
                          onTap: () {
                            setState(() { selectedCountry = country; });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}