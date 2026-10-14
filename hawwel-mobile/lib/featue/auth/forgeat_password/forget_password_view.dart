import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/country_defaults_helper.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/colors.dart';
import 'package:hawwel/constans/digit_utils.dart';
import 'package:hawwel/constans/feature_flags.dart';
import 'package:hawwel/constans/falidator.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/style.dart';
import 'package:hawwel/featue/auth/forgeat_password/data/cubit/cubit_forget_stat.dart';
import 'package:hawwel/featue/auth/forgeat_password/data/cubit/forget_cubit.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/auth/login/widjt/textfildlogin.dart';
import 'package:hawwel/featue/auth/otp/otp_view.dart';
import 'package:hawwel/featue/auth/otp/widjt/top_screen.dart';
import 'package:hawwel/featue/auth/rejster/regster_screen_view.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ForgetCubit>().email.clear();
  }

  String countryEmoji(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  bool isPhone = true;
  void detectInputType(String value) {
    if (!kEmailFeaturesEnabled) {
      if (!isPhone) setState(() => isPhone = true);
      return;
    }

    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      if (!isPhone) {
        setState(() => isPhone = true);
      }
      return;
    }

    final normalized = normalizeToWesternDigits(trimmed);
    final isDigit = RegExp(r'^[+0-9]').hasMatch(normalized[0]);

    if (isDigit != isPhone) {
      setState(() {
        isPhone = isDigit;
      });
    }
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
                            style: GoogleFonts.cairo(color: branding.hintText),
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
  //TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlocConsumer<ForgetCubit, ForgetState>(
          listener: (context, state) {
            if (state is ForgetpasswordSuccess) {
              final identifierValue =
                  BlocProvider.of<ForgetCubit>(context).submittedIdentifier ??
                  BlocProvider.of<ForgetCubit>(context).email.text;
              final session =
                  BlocProvider.of<ForgetCubit>(context).forgetSession ?? "";

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Otpscreen(email: identifierValue, session: session),
                ),
              );
              BlocProvider.of<ForgetCubit>(context).email.clear();
            } else if (state is ForgetpasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent, // مهم جدًا
                  elevation: 0, // مهم جدًا
                  behavior: SnackBarBehavior.floating, // مهم
                  margin: EdgeInsets.zero, // إلغاء الهوامش
                  padding: EdgeInsets.zero,

                  content: CustomSnackBar(
                    backgroundColor: branding.buttonBg,
                    message: state.error,
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
                  GradientHeader2(
                    v: 110,

                    title: AppTranslations.getText(context, 'reset_password'),
                    topLeftImage: AppImages.backleft,
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    AppTranslations.getText(
                      context,
                      'forgot_password_question',
                    ),
                    style: GoogleFonts.cairo(
                      color: branding.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: isArabic ? 16.sp : 18,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 48.w,
                      vertical: 30.h,
                    ),
                    child: IntrinsicHeight(
                      // Forced RTL so (with the field first) the dial-code
                      // box always sits on the left, matching the login screen.
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// الحقل الرئيسي
                          Expanded(
                            child: TextFieldCustom(
                              controller: BlocProvider.of<ForgetCubit>(
                                context,
                              ).email,
                              hintText: isPhone
                                  ? AppTranslations.getText(context, 'phone')
                                  : AppTranslations.getText(context, 'email'),
                              type: isPhone
                                  ? TextInputType.number
                                  : TextInputType.emailAddress,
                              hintStyle: AppStyle.meduim16grey,
                              obscureText: false,
                              readOnly: false,
                              inputFormatters: isPhone
                                  ? [
                                      const WesternDigitsTextInputFormatter(),
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9+\-\s()]'),
                                      ),
                                    ]
                                  : null,
                              validator: (value) {
                                if (isPhone) {
                                  return validatePhoneNumber(value, context);
                                }
                                return validateEmail(value, context);
                              },
                              onChanged: detectInputType,
                            ),
                          ),
                          if (isPhone) SizedBox(width: 8.w),
                          if (isPhone)
                            GestureDetector(
                              onTap: () {
                                _showCustomPicker(context);
                              },
                              child: Container(
                                width: 85.w,
                                height: 50.h,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                  ),
                  SizedBox(height: 120.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 30.w,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (!_formKey.currentState!.validate()) {
                          setState(() {
                            context.read<ForgetCubit>().email.clear();
                          });
                          return;
                        }
                        String? loginValue;
                        if (isPhone) {
                          final phone = buildPhoneNumberWithCountryCode(
                            phone: context.read<ForgetCubit>().email.text,
                            phoneCode: selectedCountry.phoneCode,
                          );
                          loginValue = phone;
                        }

                        final forgetCubit = BlocProvider.of<ForgetCubit>(
                          context,
                        );
                        forgetCubit.forgetpasswrdCubit(loginValue: loginValue);
                        // BlocProvider.of<ForgetCubit>(context).email.clear();
                      },
                      child: Container(
                        height: 60.h,
                        width: 245.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: branding.buildHeaderGradient(),
                        ),
                        child: state is ForgetpasswordLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                ),
                              )
                            : Center(
                                child: Text(
                                  AppTranslations.getText(context, 'submit'),
                                  style: GoogleFonts.cairo(
                                    fontSize: isArabic ? 16.sp : 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  //  SizedBox(height: 25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          AppTranslations.getText(context, 'dont_have_account'),
                          style: GoogleFonts.cairo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: branding.secondaryText,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Regsterview(),
                            ),
                          );
                        },
                        child: Text(
                          AppTranslations.getText(context, 'register_now'),
                          style: GoogleFonts.cairo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: branding.buttonBg,
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
    );
  }
}
