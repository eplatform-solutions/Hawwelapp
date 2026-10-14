import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/colors.dart';
import 'package:usdt/constans/falidator.dart';
import 'package:usdt/constans/ip_country_lookup.dart';
import 'package:usdt/constans/style.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/token.dart';
import 'package:usdt/featue/auth/forgeat_password/forget_password_view.dart';
import 'package:usdt/featue/auth/login/data/cubit/login_cubir.dart';
import 'package:usdt/featue/auth/login/data/cubit/login_cubit_state.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/login/widjt/textfildlogin.dart';
import 'package:usdt/featue/auth/login/widjt/top_screen.dart';
import 'package:usdt/featue/auth/otp/otp_Two-factor_authentication.dart';
import 'package:usdt/featue/auth/rejster/regster_screen_view.dart';
import 'package:usdt/featue/bootom_navigator.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final _formKey = GlobalKey<FormState>();
  bool _viewpoassword = true;
  bool isPhone = true;
  bool _dialCountryPinnedByUser = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _dialCountryPinnedByUser) return;
      final code = await IpCountryLookup.fetchCountryIso2();
      if (!mounted || _dialCountryPinnedByUser) return;
      final parsed = code != null ? Country.tryParse(code) : null;
      if (parsed != null) {
        setState(() => selectedCountry = parsed);
      }
    });
  }

  void detectInputType(String value) {
    final trimmed = value.trim();
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

  String countryEmoji(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    // context.read<LoginCubit>().email.clear();
    // context.read<LoginCubit>().password.clear();

    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) async {
              print("🔥 State Changed: $state");

              if (state is LoginSuccess) {
                final response = state.data;

                final loginCubit = context.read<LoginCubit>();
                final email = loginCubit.email.text;

                // 🔐 2FA
                if (response["status"] == "2fa_required") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OtpTwofactorauthentication(
                        session: response["session"],
                        email: email,
                      ),
                    ),
                  );
                  return;
                }

                loginCubit.email.clear();
                loginCubit.password.clear();

                String? userAuthToken = await Functions().getToken();

                if (!kIsWeb) {
                  try {
                    String? fcmToken = await FirebaseMessaging.instance
                        .getToken();
                    if (fcmToken != null && userAuthToken != null) {
                      String dataToCopy =
                          "--- Auth Token ---\n$userAuthToken\n\n--- FCM Token ---\n$fcmToken";
                      await Clipboard.setData(ClipboardData(text: dataToCopy));
                    }
                  } catch (_) {}
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              }

              if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0, // مهم جدًا
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,

                    content: CustomSnackBar(
                      backgroundColor: branding.buttonBg,
                      message: state.errMessage,
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
                      v: 120,
                      h: 0,
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
                        horizontal: 48.w,
                        vertical: 30.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isPhone) SizedBox(width: 8.w),

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
                              onChanged: detectInputType,
                            ),
                          ),
                          //  SizedBox(width: 10.w),
                          if (isPhone)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: GestureDetector(
                                onTap: () {
                                  // showCountryPicker(
                                  //   context: context,
                                  //   showPhoneCode: true,
                                  //   onSelect: (Country country) {
                                  //     setState(() {
                                  //       selectedCountry = country;
                                  //     });
                                  //   },
                                  // );
                                  _showCustomPicker(context);
                                },
                                child: Container(
                                  height: 55.h,
                                  width: 75.w,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 0.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: branding.inputBorder,
                                    border: Border.all(
                                      color: branding.iconPrimary,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_drop_down),
                                      Text(
                                        '${selectedCountry.phoneCode}+',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      selectedCountry.countryCode == "SY"
                                          ? Image.asset(
                                              "asset/syrianewsyria.png",
                                              width: 15.w,
                                              height: 15.h,
                                            )
                                          : Text(
                                              selectedCountry.flagEmoji,
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),

                                      // Text(

                                      //   // countryEmoji(
                                      //   //   selectedCountry.countryCode,
                                      //   // ),
                                      //   style: TextStyle(fontSize: 15),
                                      // ),
                                      SizedBox(width: 3.w),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    /// Password
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: TextFieldCustom(
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
                              phone: cubit.email.text,
                              phoneCode: selectedCountry.phoneCode,
                            );
                            bool isValid = await validatePhoneWithCountry(
                              phone: phone,
                              countryCode: selectedCountry.countryCode,
                            );

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
                                    message: AppTranslations.getText(
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
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: branding.iconPrimary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            AppTranslations.getText(
                              context,
                              'dont_have_account',
                            ),
                            style: GoogleFonts.cairo(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: branding.secondaryText,
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
                              CountryLocalizations.of(context)?.countryName(
                                countryCode: country.countryCode,
                              ) ??
                              country.name;

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

                        // ✅ الحل الآمن لجلب الاسم المترجم:
                        // نستخدم CountryLocalizations.of(context) للحصول على الاسم بناءً على لغة التطبيق الحالية
                        final String displayCountryName =
                            CountryLocalizations.of(
                              context,
                            )?.countryName(countryCode: country.countryCode) ??
                            country.name;

                        return ListTile(
                          leading: country.countryCode == "SY"
                              ? Image.asset(
                                  "asset/syrianewsyria.png",
                                  width: 30.w,
                                  height: 20.h,
                                )
                              : Text(
                                  country.flagEmoji,
                                  style: const TextStyle(fontSize: 24),
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
                            setState(() {
                              _dialCountryPinnedByUser = true;
                              selectedCountry = country;
                            });
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
