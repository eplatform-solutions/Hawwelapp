import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hawwel/constans/country_defaults_helper.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/digit_utils.dart';
import 'package:hawwel/constans/falidator.dart';
import 'package:hawwel/constans/localization/app_locale.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/style.dart';
import 'package:hawwel/constans/widgets/password_requirements_hint.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/login/widjt/textfildlogin.dart';
import 'package:hawwel/featue/auth/otp/widjt/top_screen.dart';
import 'package:hawwel/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
import 'package:hawwel/featue/auth/rejster/data/cubit/regster_cubut.dart';
import 'package:hawwel/featue/auth/rejster/register_phone_verify_view.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';

class Regsterview extends StatefulWidget {
  const Regsterview({super.key});

  @override
  State<Regsterview> createState() => _RegsterviewState();
}

class _RegsterviewState extends State<Regsterview> {
  bool _viewpassword = true;
  bool _viewpassword1 = true;
  bool _registerConsent = false;
  final _formKey = GlobalKey<FormState>();

  Country selectedCountry = Country(
    phoneCode: '49',
    countryCode: 'DE',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Germany',
    example: '15123456789',
    displayName: 'Germany',
    displayNameNoCountryCode: 'Germany',
    e164Key: '',
  );

  void _onRegisterPhoneChanged(String value) {
    final cubit = context.read<RegisterCubit>();
    final normalized = normalizePhoneLikeInput(value);
    if (normalized != value) {
      cubit.phonee.value = TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: normalized.length),
      );
    }
  }

  /// يحدّث رمز الدولة في الطلب ومنتقي الهاتف (قائمة كاملة من country_picker، بلا قيد من لوحة التحكم).
  void _applySignupCountry(Country c) {
    setState(() {
      selectedCountry = c;
    });
    context.read<RegisterCubit>().country.text = c.countryCode;
    context.read<CitiesCubit>().reset();
  }

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          content: CustomSnackBar(
            backgroundColor: appBrandingNotifier.value.error,
            message: 'Unable to open link',
            imagePath: AppImages.eerorrimage,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<RegisterCubit>().lastName.clear();
    context.read<RegisterCubit>().firstName.clear();
    context.read<RegisterCubit>().email.clear();
    context.read<RegisterCubit>().password.clear();
    context.read<RegisterCubit>().confirmPassword.clear();
    context.read<RegisterCubit>().otpEmail.clear();
    context.read<RegisterCubit>().otpphone.clear();
    context.read<RegisterCubit>().phonee.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RegisterCubit>().country.text = selectedCountry.countryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: BlocListener<RegisterCubit, RegisterState>(
            listenWhen: (previous, current) =>
                ModalRoute.of(context)?.isCurrent ?? true,
            listener: (context, state) {
              if (state is RegisterOTPSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,

                    content: CustomSnackBar(
                      backgroundColor: branding.success,
                      message: AppTranslations.getTextStatic(
                        context,
                        "otp_sent_success",
                      ),
                      imagePath: AppImages.doneimage,
                    ),
                  ),
                );
              }

              if (state is RegisterOTPError) {
                final message =
                    AppLocaleHelper.isPhoneAlreadyRegisteredMessage(state.error)
                    ? AppTranslations.getText(
                        context,
                        'phone_already_registered',
                      )
                    : state.error;
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

              if (state is RegisterError) {
                final message =
                    AppLocaleHelper.isPhoneAlreadyRegisteredMessage(state.error)
                    ? AppTranslations.getText(
                        context,
                        'phone_already_registered',
                      )
                    : state.error;
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
                    // Text(state.message)
                  ),
                );
              }
            },
            child: BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                return buildRegisterUI(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRegisterUI(BuildContext context, RegisterState state) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GradientHeader2(
            title: AppTranslations.getText(context, 'create_account'),
            v: 78,
            headerHeight: 180,
            useModernBackButton: true,
            topLeftImage: AppImages.iconback,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldCustom(
                          validator: (value) =>
                              validateFullName(value, context),
                          controller: isArabic
                              ? context.read<RegisterCubit>().firstName
                              : context.read<RegisterCubit>().lastName,
                          hintText: AppTranslations.getText(
                            context,
                            isArabic ? 'name_hint' : 'surname_hint',
                          ),
                          type: TextInputType.name,
                          hintStyle: AppStyle.meduim16grey,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: TextFieldCustom(
                          validator: (value) =>
                              validateFullName(value, context),
                          controller: isArabic
                              ? context.read<RegisterCubit>().lastName
                              : context.read<RegisterCubit>().firstName,
                          hintText: AppTranslations.getText(
                            context,
                            isArabic ? 'surname_hint' : 'name_hint',
                          ),
                          type: TextInputType.text,
                          hintStyle: AppStyle.meduim16grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextFieldCustom(
                  //         validator: (value) =>
                  //             validatePhoneNumber(value, context),
                  //         controller: context.read<RegisterCubit>().phonee,
                  //         hintText: AppTranslations.getText(
                  //           context,
                  //           'enter phone',
                  //         ),
                  //         type: TextInputType.number,
                  //         hintStyle: AppStyle.meduim16grey,
                  //         prefixIcon: GestureDetector(
                  //           onTap: isphoneResendClicked
                  //               ? null
                  //               : () async {
                  //                   final c = context.read<RegisterCubit>();

                  //                   final old = c.phonee.text;
                  //                   final isValid =
                  //                       await validatePhoneWithCountry(
                  //                         phone: old,
                  //                         countryCode:
                  //                             selectedCountry.countryCode,
                  //                       );

                  //                   if (!isValid) {
                  //                     ScaffoldMessenger.of(
                  //                       context,
                  //                     ).showSnackBar(
                  //                       SnackBar(
                  //                         backgroundColor: Colors.transparent,
                  //                         elevation: 0,
                  //                         behavior: SnackBarBehavior.floating,
                  //                         margin: EdgeInsets.zero,
                  //                         padding: EdgeInsets.zero,
                  //                         content: CustomSnackBar(
                  //                           backgroundColor: Color(0xFF6B1F2A),
                  //                           message:
                  //                               AppTranslations.getTextStatic(
                  //                                 context,
                  //                                 'mobile_number_invalid',
                  //                               ),
                  //                           imagePath: AppImages.eerorrimage,
                  //                         ),
                  //                       ),
                  //                     );
                  //                     return; // وقف الإرسال
                  //                   }
                  //                   c.phonee.text =
                  //                       '+${selectedCountry.phoneCode}${old.replaceAll(RegExp(r'\\D'), '').replaceFirst(RegExp(r'^0'), '')}';

                  //                   await c.sendOtpphone(); // أو c.register();

                  //                   c.phonee.text = old;
                  //                 },
                  //           child: Padding(
                  //             padding: EdgeInsets.symmetric(
                  //               horizontal: 16.w,
                  //               vertical: 0.h,
                  //             ),
                  //             child: isphoneResendClicked
                  //                 ? Row(
                  //                     mainAxisSize: MainAxisSize.min,
                  //                     children: [
                  //                       const Icon(
                  //                         Icons.access_time,
                  //                         size: 16,
                  //                         color: Colors.black,
                  //                       ),
                  //                       SizedBox(width: 4.w),
                  //                       Text(
                  //                         isArabic
                  //                             ? '${AppTranslations.getText(context, 'Resend after')}$phoneSecondsRemaining${AppTranslations.getText(context, 'seconds')}  '
                  //                             : '${AppTranslations.getText(context, 'Resend after')}${AppTranslations.getText(context, 'seconds')} $phoneSecondsRemaining  ',
                  //                         style: GoogleFonts.cairo(
                  //                           fontSize: 12.sp,
                  //                           fontWeight: FontWeight.w600,
                  //                           color: const Color(0xFF565656),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   )
                  //                 : Padding(
                  //                     padding: EdgeInsets.symmetric(
                  //                       horizontal: 20.w,
                  //                       vertical: 17.h,
                  //                     ),
                  //                     child: Text(
                  //                       AppTranslations.getText(context, 'otp'),
                  //                       style: GoogleFonts.cairo(
                  //                         fontSize: isArabic ? 11.sp : 13.sp,
                  //                         fontWeight: FontWeight.w600,
                  //                         color: const Color(0xFF565656),
                  //                       ),
                  //                     ),
                  //                   ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),

                  //     SizedBox(width: 8.w),
                  //     GestureDetector(
                  //       onTap: () {
                  //         _showCustomPicker(context);
                  //         // showCountryPicker(
                  //         //   context: context,
                  //         //   showPhoneCode: true,
                  //         //   onSelect: (Country country) {
                  //         //     setState(() {
                  //         //       selectedCountry = country;
                  //         //     });
                  //         //   },
                  //         // );
                  //       },
                  //       child: Container(
                  //         height: 55.h,
                  //         width: 85.w,
                  //         decoration: BoxDecoration(
                  //           color: const Color(0xFFE9E9E9),
                  //           border: Border.all(color: const Color(0xFF6B1F2A)),
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               selectedCountry.flagEmoji,
                  //               style: const TextStyle(fontSize: 15),
                  //             ),
                  //             const SizedBox(width: 4),
                  //             Text(
                  //               textDirection: TextDirection.ltr,
                  //               '+${selectedCountry.phoneCode}',
                  //               style: const TextStyle(fontSize: 12),
                  //             ),
                  //             const Icon(Icons.arrow_drop_down),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: isArabic
                          ? [
                              GestureDetector(
                                onTap: () => _showWorldCountryPicker(context),
                                child: Container(
                                  width: 85.w,
                                  decoration: BoxDecoration(
                                    color: branding.inputBorder,
                                    border: Border.all(
                                      color: branding.iconPrimary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CountryDefaultsHelper.countryFlag(
                                          selectedCountry.countryCode,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '+${selectedCountry.phoneCode}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.ltr,
                                        ),
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextFieldCustom(
                                  validator: (value) =>
                                      validatePhoneNumber(value, context),
                                  controller: context
                                      .read<RegisterCubit>()
                                      .phonee,
                                  hintText: AppTranslations.getText(
                                    context,
                                    'enter phone',
                                  ),
                                  type: TextInputType.number,
                                  hintStyle: AppStyle.meduim16grey,
                                  onChanged: _onRegisterPhoneChanged,
                                ),
                              ),
                            ]
                          : [
                              Expanded(
                                child: TextFieldCustom(
                                  validator: (value) =>
                                      validatePhoneNumber(value, context),
                                  controller: context
                                      .read<RegisterCubit>()
                                      .phonee,
                                  hintText: AppTranslations.getText(
                                    context,
                                    'enter phone',
                                  ),
                                  type: TextInputType.number,
                                  hintStyle: AppStyle.meduim16grey,
                                  onChanged: _onRegisterPhoneChanged,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () => _showWorldCountryPicker(context),
                                child: Container(
                                  width: 85.w,
                                  decoration: BoxDecoration(
                                    color: branding.inputBorder,
                                    border: Border.all(
                                      color: branding.iconPrimary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CountryDefaultsHelper.countryFlag(
                                          selectedCountry.countryCode,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '+${selectedCountry.phoneCode}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textDirection: TextDirection.ltr,
                                        ),
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                    ),
                  ),
                  SizedBox(height: 15.h),

                  TextFieldCustom(
                    validator: (value) => validatePassword(value, context),
                    controller: context.read<RegisterCubit>().password,
                    hintText: AppTranslations.getText(context, 'password'),
                    type: TextInputType.visiblePassword,
                    prefixIcon: IconButton(
                      icon: Icon(
                        _viewpassword ? Icons.visibility_off : Icons.visibility,
                        color: branding.hintText,
                      ),
                      onPressed: () {
                        setState(() {
                          _viewpassword = !_viewpassword;
                        });
                      },
                    ),
                    hintStyle: AppStyle.meduim16grey,
                    obscureText: _viewpassword,
                  ),
                  const PasswordRequirementsHint(),
                  SizedBox(height: 15.h),

                  TextFieldCustom(
                    validator: (value) => validatePassword(value, context),
                    controller: context.read<RegisterCubit>().confirmPassword,
                    hintText: AppTranslations.getText(
                      context,
                      'confirm_password',
                    ),
                    type: TextInputType.visiblePassword,
                    hintStyle: AppStyle.meduim16grey,
                    prefixIcon: IconButton(
                      icon: Icon(
                        _viewpassword1
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: branding.hintText,
                      ),
                      onPressed: () {
                        setState(() {
                          _viewpassword1 = !_viewpassword1;
                        });
                      },
                    ),
                    obscureText: _viewpassword1,
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: branding.cardBg,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: _registerConsent
                            ? branding.accent.withValues(alpha: 0.45)
                            : branding.hintText.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -2),
                          child: Checkbox(
                            value: _registerConsent,
                            onChanged: (value) {
                              setState(() => _registerConsent = value ?? false);
                            },
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic
                                    ? 'أوافق على الشروط والأحكام وسياسة الخصوصية، وأفهم أن بياناتي ستُستخدم لإنشاء الحساب والتحقق وتقديم خدمات طلبات التحويل الرقمية.'
                                    : 'I agree to the Terms and Privacy Policy and understand that my data will be used to create my account, verify my identity, and provide digital transfer request services.',
                                style: GoogleFonts.cairo(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: branding.secondaryText,
                                  height: 1.45,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Wrap(
                                spacing: 12.w,
                                runSpacing: 6.h,
                                children: [
                                  GestureDetector(
                                    onTap: () => _openExternalUrl(
                                      'https://hawwelapp.com/terms',
                                    ),
                                    child: Text(
                                      isArabic ? 'الشروط والأحكام' : 'Terms',
                                      style: GoogleFonts.cairo(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: branding.accent,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _openExternalUrl(
                                      'https://hawwelapp.com/privacy',
                                    ),
                                    child: Text(
                                      isArabic
                                          ? 'سياسة الخصوصية'
                                          : 'Privacy Policy',
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  GestureDetector(
                    onTap: () async {
                      final cubit = context.read<RegisterCubit>();
                      if (cubit.confirmPassword.text != cubit.password.text) {
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
                                "password_mismatch",
                              ),
                              imagePath: AppImages.eerorrimage,
                            ),
                          ),
                        );
                        return;
                      }
                      if (!_formKey.currentState!.validate()) {
                        setState(() {
                          cubit.password.clear();
                          cubit.confirmPassword.clear();
                        });
                        return;
                      }
                      if (!_registerConsent) {
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
                              message: isArabic
                                  ? 'يرجى الموافقة على الشروط والخصوصية للمتابعة.'
                                  : 'Please agree to Terms and Privacy Policy to continue.',
                              imagePath: AppImages.eerorrimage,
                            ),
                          ),
                        );
                        return;
                      }

                      final raw = normalizePhoneLikeInput(
                        cubit.phonee.text,
                      ).trim();
                      cubit.phonee.value = TextEditingValue(
                        text: raw,
                        selection: TextSelection.collapsed(offset: raw.length),
                      );
                      final isValid = await validatePhoneWithCountry(
                        phone: raw,
                        countryCode: selectedCountry.countryCode,
                      );
                      if (!isValid) {
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
                                'mobile_number_invalid',
                              ),
                              imagePath: AppImages.eerorrimage,
                            ),
                          ),
                        );
                        return;
                      }

                      cubit.otpphone.clear();

                      final fullPhone = buildPhoneNumberWithCountryCode(
                        phone: raw,
                        phoneCode: selectedCountry.phoneCode,
                      );
                      final ok = await cubit.requestMobileOtpForSignup(
                        mobilePhone: fullPhone,
                      );
                      if (!context.mounted) return;
                      if (ok) {
                        await Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const RegisterPhoneVerifyView(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 60.h,
                      width: 245.w,
                      decoration: branding.buildButtonDecoration(radius: 30),
                      child:
                          state is RegisterLoading ||
                              state is RegisterOTPLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Center(
                              child: Text(
                                AppTranslations.getText(
                                  context,
                                  'register_now',
                                ),
                                style: GoogleFonts.cairo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppTranslations.getText(
                          context,
                          'already_have_account',
                        ),
                        style: GoogleFonts.cairo(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: branding.hintText,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          AppTranslations.getText(context, 'login_now'),
                          style: GoogleFonts.cairo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: branding.buttonBg,
                          ),
                        ),
                      ),
                    ],
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

  /// قائمة كل الدول (CountryService) — نفس مصدر منتقي الهاتف، لا تعتمد على لوحة التحكم.
  void _showWorldCountryPicker(BuildContext context) {
    final branding = appBrandingNotifier.value;
    // جلب القائمة الأساسية
    final List<Country> allCountries = CountryService().getAll();
    // قائمة للفلترة داخل الـ BottomSheet
    List<Country> filteredCountries = List.from(allCountries);
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
                  // موازن السحب العلوي
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // حقل البحث
                  TextField(
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    decoration: InputDecoration(
                      hintText: AppTranslations.getText(
                        context,
                        "search_country",
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (val) {
                      setInternalState(() {
                        filteredCountries = allCountries.where((country) {
                          // جلب الاسم المترجم للبحث فيه
                          final String localizedName =
                              CountryDefaultsHelper.localizedCountryName(
                                context,
                                country.countryCode,
                                fallback: country.name,
                              );

                          final searchLower = val.toLowerCase();
                          return localizedName.toLowerCase().contains(
                                searchLower,
                              ) ||
                              country.name.toLowerCase().contains(
                                searchLower,
                              ) ||
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
                            CountryDefaultsHelper.localizedCountryName(
                              context,
                              country.countryCode,
                              fallback: country.name,
                            );

                        return ListTile(
                          leading: CountryDefaultsHelper.countryFlag(
                            country.countryCode,
                            size: 24,
                          ),
                          title: Text(
                            displayCountryName,
                            style: GoogleFonts.cairo(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Text(
                            "+${country.phoneCode}",
                            textDirection: TextDirection
                                .ltr, // لضمان ظهور الزائد بجانب الرقم
                            style: GoogleFonts.cairo(
                              color: branding.secondaryText,
                            ),
                          ),
                          onTap: () {
                            if (!mounted) return;
                            _applySignupCountry(country);
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
