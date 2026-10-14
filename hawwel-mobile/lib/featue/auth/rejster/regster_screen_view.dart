import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/falidator.dart';
import 'package:usdt/constans/ip_country_lookup.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/style.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/login/widjt/textfildlogin.dart';
import 'package:usdt/featue/auth/otp/widjt/top_screen.dart';
import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubut.dart';
import 'package:usdt/featue/auth/rejster/register_phone_verify_view.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';

class Regsterview extends StatefulWidget {
  const Regsterview({super.key});

  @override
  State<Regsterview> createState() => _RegsterviewState();
}

class _RegsterviewState extends State<Regsterview> {
  bool _viewpassword = true;
  bool _viewpassword1 = true;
  final _formKey = GlobalKey<FormState>();

  /// إذا اختار المستخدم الدولة يدويًا قبل انتهاء طلب الـ IP لا نستبدل اختياره.
  bool _countryPinnedByUser = false;

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

  /// يحدّث رمز الدولة في الطلب ومنتقي الهاتف (قائمة كاملة من country_picker، بلا قيد من لوحة التحكم).
  void _applySignupCountry(Country c, {bool userSelected = true}) {
    if (userSelected) {
      _countryPinnedByUser = true;
    }
    setState(() {
      selectedCountry = c;
    });
    context.read<RegisterCubit>().country.text = c.countryCode;
    context.read<CitiesCubit>().reset();
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      context.read<RegisterCubit>().country.text = selectedCountry.countryCode;
      final code = await IpCountryLookup.fetchCountryIso2();
      if (!mounted || _countryPinnedByUser) return;
      final parsed = code != null ? Country.tryParse(code) : null;
      if (parsed != null) {
        _applySignupCountry(parsed, userSelected: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,

                    content: CustomSnackBar(
                      backgroundColor: branding.error,
                      message: state.error,
                      imagePath: AppImages.eerorrimage,
                    ),
                  ),
                );
              }

              if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,

                    content: CustomSnackBar(
                      backgroundColor: branding.error,
                      message: state.error,
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GradientHeader2(
            title: AppTranslations.getText(context, 'create_account'),
            v: 100,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldCustom(
                          validator: (value) =>
                              validateFullName(value, context),
                          controller: context.read<RegisterCubit>().lastName,
                          hintText: AppTranslations.getText(
                            context,
                            'surname_hint',
                          ),
                          type: TextInputType.text,
                          hintStyle: AppStyle.meduim16grey,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: TextFieldCustom(
                          validator: (value) =>
                              validateFullName(value, context),
                          controller: context.read<RegisterCubit>().firstName,
                          hintText: AppTranslations.getText(
                            context,
                            'name_hint',
                          ),
                          type: TextInputType.name,
                          hintStyle: AppStyle.meduim16grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  TextFieldCustom(
                    validator: (value) => contry(value, context),
                    controller: context.read<RegisterCubit>().country,
                    hintText: AppTranslations.getText(context, 'country_hint'),
                    readOnly: true,
                    type: TextInputType.text,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _showWorldCountryPicker(context);
                    },
                    prefixIcon: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showWorldCountryPicker(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: SizedBox(
                          width: 150.w,
                          child: Row(
                            children: [
                              Image.asset(
                                AppImages.trkyicon,
                                height: 22.h,
                                width: 22.h,
                                color: branding.secondaryText,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  CountryLocalizations.of(context)?.countryName(
                                        countryCode:
                                            selectedCountry.countryCode,
                                      ) ??
                                      selectedCountry.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.cairo(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: branding.secondaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    hintStyle: AppStyle.meduim16grey,
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
                  //             // Text(
                  //             //   countryEmoji(selectedCountry.countryCode),
                  //             //   style: const TextStyle(fontSize: 18),
                  //             // ),
                  //             selectedCountry.countryCode == "SY"
                  //                 ? Image.asset(
                  //                     "asset/syrianewsyria.png",
                  //                     width: 15.w,
                  //                     height: 15.h,
                  //                   )
                  //                 : Text(
                  //                     selectedCountry.flagEmoji,
                  //                     style: const TextStyle(fontSize: 15),
                  //                   ),
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
                      children: [
                        Expanded(
                          child: TextFieldCustom(
                            validator: (value) =>
                                validatePhoneNumber(value, context),
                            controller: context.read<RegisterCubit>().phonee,
                            hintText: AppTranslations.getText(
                              context,
                              'enter phone',
                            ),
                            type: TextInputType.number,
                            hintStyle: AppStyle.meduim16grey,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () => _showWorldCountryPicker(context),
                          child: Container(
                            width: 85.w,
                            // لاحظ حذفنا الـ height الثابت ليعمل الـ stretch
                            decoration: BoxDecoration(
                              color: branding.inputBorder,
                              border: Border.all(color: branding.buttonBg),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                selectedCountry.countryCode == "SY"
                                    ? Image.asset(
                                        "asset/syrianewsyria.png",
                                        width: 15.w,
                                        height: 15.h,
                                      )
                                    : Text(
                                        selectedCountry.flagEmoji,
                                        style: const TextStyle(fontSize: 15),
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
                                const Icon(Icons.arrow_drop_down, size: 20),
                              ],
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

                      final raw = cubit.phonee.text.trim();
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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          AppTranslations.getText(context, 'login_title'),
                          style: GoogleFonts.cairo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: branding.buttonBg,
                          ),
                        ),
                      ),
                      Text(
                        AppTranslations.getText(context, 'dont_have_account'),
                        style: GoogleFonts.cairo(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: branding.hintText,
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
