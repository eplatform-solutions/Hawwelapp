import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/auth/conferm_password/conferm_password_view.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/auth/otp/widjt/top_screen.dart';
import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubut.dart';

class Otpscreen extends StatefulWidget {
  final String email;
  String session;

  Otpscreen({super.key, required this.email, required this.session});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  bool isResendClicked = false;
  int secondsRemaining = 60;
  Timer? timer;

  /// ✅ Controller محلي
  // final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    //otpController.dispose(); // ✅ مهم جدًا
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      isResendClicked = true;
      secondsRemaining = 60;
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          isResendClicked = false;
        });
      }
    });
  }

  String otp = '';

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            print("STATE => $state");

            if (state is RegisterOTPVerified) {
              //  final otp = otpController.text;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Conferampassword(
                    session: state.newSession,
                    otp: otp, // ✅ من المحلي
                  ),
                ),
              );
            }

            if (state is RegisterOTPError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0, // مهم جدًا
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,

                    content: CustomSnackBar(
                      backgroundColor: branding.buttonBg,
                      message: state.error ,
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
                    title: AppTranslations.getText(context, 'verification'),
                    topLeftImage: AppImages.backleft,
                    v: 120,
                  ),

                  SizedBox(height: 50.h),

                  Text(
                    AppTranslations.getText(context, 'enter_verification_code'),
                    style: GoogleFonts.cairo(
                      color: branding.primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                    ),
                  ),

                  SizedBox(height: 50.h),

                  /// ✅ OTP FIELD
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    onCompleted: (value) {
                      otp = value; // ✅ نخزن الـ OTP هنا
                    },
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    textStyle: GoogleFonts.cairo(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: branding.primaryText,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle,
                      borderRadius: BorderRadius.circular(50),
                      fieldHeight: 60.h,
                      fieldWidth: 60.w,
                      borderWidth: 1.5,
                      inactiveColor: branding.primaryText,
                      activeColor: branding.primaryText,
                      selectedColor: branding.primaryText,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    onChanged: (value) {},
                  ),

                  SizedBox(height: 20.h),

                  /// RESEND
                  isResendClicked
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Text(
                                AppTranslations.getText(context, "resend"),
                                style: GoogleFonts.cairo(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: branding.iconPrimary,
                                ),
                              ),
                              Text(
                                AppTranslations.getText(
                                  context,
                                  "please_resend_after_seconds",
                                  replacements: {
                                    "seconds": secondsRemaining.toString(),
                                  },
                                ),
                              ),
                              Icon(Icons.access_time),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            if (!isResendClicked) {
                              await context.read<RegisterCubit>().sendOtpAgain(
                                widget.email,
                              );
                              startTimer();
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
                                  // Text(state.message)
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Row(
                              children: [
                                Text(
                                  AppTranslations.getText(
                                    context,
                                    "did_not_receive_code",
                                  ),
                                  style: GoogleFonts.cairo(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: branding.secondaryText,
                                  ),
                                ),
                                Text(
                                  AppTranslations.getText(context, "resend"),
                                  style: GoogleFonts.cairo(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: branding.buttonBg,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                  SizedBox(height: 120.h),

                  /// SUBMIT
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: GestureDetector(
                      onTap: () {
                        context.read<RegisterCubit>().verifyOtpAndGetSession(
                          otp: otp, // ✅
                          session: widget.session,
                        );
                      },
                      child: Container(
                        height: 60.h,
                        width: 350.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: branding.buildHeaderGradient(),
                        ),
                        child: state is RegisterOTPLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Center(
                                child: Text(
                                  AppTranslations.getText(context, 'submit'),
                                  style: GoogleFonts.cairo(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// class _OtpscreenState extends State<Otpscreen> {
//   bool isResendClicked = false;
//   int secondsRemaining = 60;
//   Timer? timer;

//   void startTimer() {
//     setState(() {
//       isResendClicked = true;
//       secondsRemaining = 60;
//     });

//     timer?.cancel();
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (secondsRemaining > 0) {
//         setState(() {
//           secondsRemaining--;
//         });
//       } else {
//         timer.cancel();
//         setState(() {
//           isResendClicked = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

//     return Directionality(
//       textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: BlocConsumer<RegisterCubit, RegisterState>(
//           listener: (context, state) {
//             if (state is RegisterOTPVerified) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => Conferampassword(
//                     session: state.newSession,
//                     otp: BlocProvider.of<RegisterCubit>(
//                       context,
//                     ).otpEmailrest.text,
//                   ),
//                 ),
//               );
//             }

//             if (state is RegisterOTPError) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.error)));
//             }
//           },

//           builder: (context, state) {
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   GradientHeader2(
//                     title: AppTranslations.getText(context, 'verification'),
//                     topLeftImage: AppImages.backleft,
//                     v: 120,
//                   ),

//                   SizedBox(height: 50.h),

//                   Text(
//                     AppTranslations.getText(context, 'enter_verification_code'),
//                     style: GoogleFonts.cairo(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 24.sp,
//                     ),
//                   ),

//                   SizedBox(height: 50.h),

//                   /// OTP FIELD
//                   PinCodeTextField(
//                     appContext: context,
//                     length: 4,
//                     controller: BlocProvider.of<RegisterCubit>(
//                       context,
//                     ).otpEmailrest,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     animationType: AnimationType.fade,
//                     keyboardType: TextInputType.number,
//                     textStyle: GoogleFonts.cairo(
//                       fontSize: 22.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     pinTheme: PinTheme(
//                       shape: PinCodeFieldShape.circle,
//                       borderRadius: BorderRadius.circular(50),
//                       fieldHeight: 60.h,
//                       fieldWidth: 60.w,
//                       borderWidth: 1.5,
//                       inactiveColor: Colors.black,
//                       activeColor: Colors.black,
//                       selectedColor: Colors.black,
//                       activeFillColor: Colors.white,
//                       inactiveFillColor: Colors.white,
//                       selectedFillColor: Colors.white,
//                     ),
//                     animationDuration: const Duration(milliseconds: 300),
//                     backgroundColor: Colors.transparent,
//                     enableActiveFill: true,
//                     onChanged: (value) {},
//                     onCompleted: (value) {
//                       debugPrint("OTP Completed: $value");
//                     },
//                   ),

//                   SizedBox(height: 20.h),

//                   /// RESEND TIMER
//                   isResendClicked
//                       ? Text(
//                           AppTranslations.getText(
//                             context,
//                             "please_resend_after_seconds",
//                             replacements: {
//                               "seconds": secondsRemaining.toString(),
//                             },
//                           ),
//                           style: GoogleFonts.cairo(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[700],
//                           ),
//                         )
//                       : GestureDetector(
//                           onTap: () async {
//                             if (!isResendClicked) {
//                               setState(() => isResendClicked = true);

//                               await context.read<RegisterCubit>().sendOtpAgain(
//                                 widget.email,
//                               );

//                               startTimer();
//                             }
//                           },

//                           child: Text(
//                             AppTranslations.getText(context, "resend"),
//                             style: GoogleFonts.cairo(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.red[800],
//                             ),
//                           ),
//                         ),

//                   SizedBox(height: 120.h),

//                   /// SUBMIT BUTTON
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 32.w),
//                     child: GestureDetector(
//                       onTap: () {
//                         BlocProvider.of<RegisterCubit>(
//                           context,
//                         ).verifyOtpAndGetSession(
//                           otp: BlocProvider.of<RegisterCubit>(
//                             context,
//                           ).otpEmailrest.text,
//                           session: widget.session,
//                         );
//                         // BlocProvider.of<RegisterCubit>(
//                         //   context,
//                         // ).otpEmailrest.dispose();
//                       },
//                       child: Container(
//                         height: 60.h,
//                         width: 350.w,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           color: const Color(0xFF6B1F2A),
//                         ),
//                         child: state is RegisterOTPLoading
//                             ? const Center(
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : Center(
//                                 child: Text(
//                                   AppTranslations.getText(context, 'submit'),
//                                   style: GoogleFonts.cairo(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 20.h),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
