// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:usdt/constans/appr_images.dart';
// import 'package:usdt/constans/falidator.dart';
// import 'package:usdt/constans/localization/app_tranzaction.dart';
// import 'package:usdt/constans/style.dart';
// import 'package:usdt/featue/auth/login/widjt/textfildlogin.dart';
// import 'package:usdt/featue/auth/login/widjt/top_screen.dart';
// import 'package:usdt/featue/auth/otp/otp_view.dart';
// import 'package:usdt/featue/auth/otp/widjt/top_screen.dart';

// class Forgetpasswordprofail extends StatefulWidget {
//   const Forgetpasswordprofail({super.key});

//   @override
//   State<Forgetpasswordprofail> createState() => _ForgetpasswordState();
// }

// class _ForgetpasswordState extends State<Forgetpasswordprofail> {
//   TextEditingController username = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             GradientHeader2(
//               v: 110,
          
//               title: AppTranslations.getText(context, 'reset_password'),
//               topLeftImage: AppImages.backleft,
//             ),
//             SizedBox(height: 50.h),
//             Text(
//               AppTranslations.getText(context, 'forgot_password_question'),
//               style: GoogleFonts.cairo(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 22.sp,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 30.h),
//               child: TextFieldCustom(
//                 validator: (value) => validateFullName(value, context),
//                 controller: username,
//                 hintText: AppTranslations.getText(context, 'enter_email'),
//                 type: TextInputType.name,
//                 // maxLength: 10,
//                 hintStyle: AppStyle.meduim16grey,
//                 obscureText: false,
//                 readOnly: false,
//               ),
//             ),
//             SizedBox(height: 120.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 30.w),
//               child: GestureDetector(
//                 // onTap: () {
//                 //   Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(builder: (context) => Otpscreen()),
//                 //   );
//                 // },
//                 child: Container(
//                   height: 60.h,
//                   width: 350.w,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: Color(0xFF6B1F2A),
//                   ),
//                   child: Center(
//                     child: Text(
//                       AppTranslations.getText(context, 'submit'),
//                       style: GoogleFonts.cairo(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             //  SizedBox(height: 25.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'تسجيل الدخول',
//                   style: GoogleFonts.cairo(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF6B1F2A),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(
//                     'هل لديك حساب؟',
//                     style: GoogleFonts.cairo(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF565656),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
