import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/country_defaults_helper.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/feature_flags.dart';
import 'package:hawwel/constans/colors.dart';
import 'package:hawwel/constans/digit_utils.dart';
import 'package:hawwel/constans/falidator.dart';
import 'package:hawwel/constans/style.dart';
import 'package:hawwel/constans/localization/app_locale.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/featue/auth/forgeat_password/forget_password_view.dart';
import 'package:hawwel/featue/auth/login/data/cubit/login_cubir.dart';
import 'package:hawwel/featue/auth/login/data/cubit/login_cubit_state.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/login/widjt/textfildlogin.dart';
import 'package:hawwel/featue/auth/login/widjt/top_screen.dart';
import 'package:hawwel/featue/auth/otp/otp_Two-factor_authentication.dart';
import 'package:hawwel/featue/auth/rejster/regster_screen_view.dart';
import 'package:hawwel/featue/bootom_navigator.dart';
import 'package:hawwel/featue/first_screen/bootom_navigatot_first_screen.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final _formKey = GlobalKey<FormState>();
  bool _viewpoassword = true;
  bool isPhone = true;

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

  void detectInputType(String value) {
    // Email login is retired: the field never switches to email mode, so no
    // "Email" hint / validator / keyboard can surface while the flag is off.
    if (!kEmailFeaturesEnabled) {
      if (!isPhone) setState(() => isPhone = true);
      return;
    }
    final trimmed = normalizePhoneLikeInput(value).trim();
    if (trimmed.isEmpty) {
      if (!isPhone) {
        setState(() => isPhone = true);
      }
      return;
    }

    final isDigit = RegExp(r'^[+0-9]').hasMatch(trimmed[0]);

    if (isDigit != isPhone) {
      setState(() {
        isPhone = isDigit;
      });
    }
  }

  void _onLoginIdentifierChanged(String value) {
    final cubit = context.read<LoginCubit>();
    final normalized = normalizePhoneLikeInput(value);
    if (normalized != value) {
      cubit.email.value = TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: normalized.length),
      );
    }
    detectInputType(normalized);
  }

  String countryEmoji(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  String _resolveLoginErrorMessage(BuildContext context, String rawMessage) {
    if (AppLocaleHelper.isInvalidCredentialsMessage(rawMessage)) {
      return AppTranslations.getTextStatic(
        context,
        isPhone ? 'invalid_phone_credentials' : 'invalid_email_credentials',
      );
    }
    return rawMessage;
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    // context.read<LoginCubit>().email.clear();
    // context.read<LoginCubit>().password.clear();

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) async {
              if (state is LoginSuccess) {
                final response = state.data;

                final loginCubit = context.read<LoginCubit>();
                final identifier = loginCubit.lastLoginIdentifier.isNotEmpty
                    ? loginCubit.lastLoginIdentifier
                    : loginCubit.email.text;

                // 🔐 2FA
                if (response["status"] == "2fa_required") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OtpTwofactorauthentication(
                        session: response["session"],
                        email: identifier,
                      ),
                    ),
                  );
                  return;
                }

                loginCubit.email.clear();
                loginCubit.password.clear();

                String? userAuthToken = await Functions().getToken();
                if ((userAuthToken == null || userAuthToken.isEmpty) &&
                    response["status"] == "success") {
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
                          'session_start_failed',
                        ),
                        imagePath: AppImages.eerorrimage,
                      ),
                    ),
                  );
                  return;
                }

                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              }

              if (state is LoginFailure) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0, // مهم جدًا
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,

                    content: CustomSnackBar(
                      backgroundColor: branding.buttonBg,
                      message: _resolveLoginErrorMessage(
                        context,
                        state.errMessage,
                      ),
                      imagePath: AppImages.eerorrimage,
                    ),
                    // Text(state.message)
                  ),
                );
              }
            },

            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    GradientHeader(
                      title: AppTranslations.getText(context, 'login_title'),
                      v: 86,
                      h: 0,
                      topLeftImage: AppImages.iconback,
                      useModernBackButton: true,
                      onLeadingTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Homefirstscreen(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 50.h),

                    Text(
                      AppTranslations.getText(context, 'welcome_back'),
                      style: GoogleFonts.cairo(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: branding.primaryText,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.w,
                        vertical: 30.h,
                      ),
                      // Forced LTR so the dial-code box always sits on the
                      // left and the number on the right, in both languages.
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isPhone) ...[
                            GestureDetector(
                              onTap: () => _showCustomPicker(context),
                              child: Container(
                                height: 50.h,
                                width: 86.w,
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
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
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CountryDefaultsHelper.countryFlag(
                                        selectedCountry.countryCode,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Flexible(
                                        child: Text(
                                          '+${selectedCountry.phoneCode}',
                                          textDirection: TextDirection.ltr,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.cairo(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: branding.primaryText,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20.sp,
                                        color: branding.secondaryText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                          Expanded(
                            child: TextFieldCustom(
                              controller: context.read<LoginCubit>().email,
                              hintText: isPhone
                                  ? AppTranslations.getText(context, 'phone')
                                  : AppTranslations.getText(context, 'email'),
                              type: isPhone
                                  ? TextInputType.phone
                                  : TextInputType.emailAddress,
                              hintStyle: AppStyle.meduim16grey,
                              obscureText: false,
                              readOnly: false,
                              validator: (value) {
                                if (isPhone) {
                                  return validatePhoneNumber(value, context);
                                }
                                return validateEmail(value, context);
                              },
                              onChanged: _onLoginIdentifierChanged,
                            ),
                          ),
                        ],
                        ),
                      ),
                    ),

                    /// Password
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: TextFieldCustom(
                        // Full rules on purpose: the owner wants a typed
                        // password that is too short / missing a digit etc.
                        // to say so explicitly (the message renders under the
                        // field) instead of only a red border.
                        validator: (value) => validatePassword(value, context),
                        controller: BlocProvider.of<LoginCubit>(
                          context,
                        ).password,
                        hintText: AppTranslations.getText(context, 'password'),
                        type: TextInputType.visiblePassword,
                        prefixIcon: IconButton(
                          icon: Icon(
                            _viewpoassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: branding.hintText,
                          ),
                          onPressed: () {
                            setState(() {
                              _viewpoassword = !_viewpoassword;
                            });
                          },
                        ),

                        hintStyle: AppStyle.meduim16grey,
                        obscureText: _viewpoassword,
                        readOnly: false,
                      ),
                    ),

                    /// Forgot Password
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Forgetpassword(),
                                ),
                              );
                              context.read<LoginCubit>().email.clear();
                              context.read<LoginCubit>().password.clear();
                            },
                            child: Text(
                              AppTranslations.getText(
                                context,
                                'forgot_password',
                              ),
                              style: GoogleFonts.cairo(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: branding.secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Login Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 30.h,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          final cubit = context.read<LoginCubit>();
                          String? loginValue;

                          if (isPhone) {
                            final phone = buildPhoneNumberWithCountryCode(
                              phone: normalizePhoneLikeInput(cubit.email.text),
                              phoneCode: selectedCountry.phoneCode,
                            );
                            bool isValid = await validatePhoneWithCountry(
                              phone: phone,
                              countryCode: selectedCountry.countryCode,
                            );
                            if (!context.mounted) return;

                            if (!isValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0, // مهم جدًا
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,

                                  content: CustomSnackBar(
                                    backgroundColor: branding.buttonBg,
                                    message: AppTranslations.getTextStatic(
                                      context,
                                      'mobile_number_invalid',
                                    ),
                                    imagePath: AppImages.eerorrimage,
                                  ),
                                  // Text(state.message)
                                ),
                              );
                              return; // وقف عملية تسجيل الدخول
                            }
                            loginValue = phone;
                            // cubit.email.text =
                            //     '+${selectedCountry.phoneCode}${cubit.email.text}';
                          }

                          cubit.logincub(loginValue: loginValue);
                        },

                        child: Container(
                          height: 60.h,
                          width: 245.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: branding.buildHeaderGradient(),
                          ),
                          child: state is LoginLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    AppTranslations.getText(
                                      context,
                                      'login_button',
                                    ),
                                    style: GoogleFonts.cairo(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 25.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppTranslations.getText(context, 'dont_have_account'),
                          style: GoogleFonts.cairo(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.secondaryText,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Regsterview(),
                              ),
                            );
                            context.read<LoginCubit>().email.clear();
                            context.read<LoginCubit>().password.clear();
                          },
                          child: Text(
                            AppTranslations.getText(context, 'register_now'),
                            style: GoogleFonts.cairo(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: branding.iconPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCustomPicker(BuildContext context) {
    final branding = appBrandingNotifier.value;
    // جلب القائمة الأساسية
    final List<Country> allCountries = CountryService().getAll();
    // قائمة للفلترة داخل الـ BottomSheet
    List<Country> filteredCountries = List.from(allCountries);
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: branding.dialogBg,
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
                            setState(() => selectedCountry = country);
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
