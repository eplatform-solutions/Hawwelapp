import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';

// class Trsletastkbl extends StatelessWidget {
//   final String text1;
//   final String text2;
//   final String text3;
//   const Trsletastkbl({
//     super.key,
//     required this.text1,
//     required this.text2,
//     required this.text3,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       child: Container(
//         height: 101.h,
//         width: 145.w,
//         decoration: BoxDecoration(
//           border: Border.all(color: branding.cardBorder),
//           borderRadius: BorderRadius.circular(16),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFB2C0BC), Color(0xFFB4C1BD)],
//             end: Alignment.centerRight,
//             begin: Alignment.centerLeft,
//           ),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     text1,
//                     style: GoogleFonts.cairo(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF565656),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text(
//                   text2,
//                   style: GoogleFonts.cairo(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF565656),
//                   ),
//                 ),
//                 SizedBox(width: 20.w),
//                 Text(
//                   text3,
//                   style: GoogleFonts.cairo(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF565656),
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
class Trsletastkbl extends StatelessWidget {
  final String text1;
  final String text2;
  final TextEditingController controller; // للتحكم بالقيمة وعرضها
  final Function(String)? onChanged;      // للحساب العكسي عند الكتابة

  const Trsletastkbl({
    super.key,
    required this.text1,
    required this.text2,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 101.h,
        width: 145.w,
        decoration: BoxDecoration(
          border: Border.all(color: branding.cardBorder),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [branding.hintText, branding.hintText],
            end: Alignment.centerRight,
            begin: Alignment.centerLeft,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text1,
                    style: GoogleFonts.cairo(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: branding.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  text2,
                  style: GoogleFonts.cairo(fontSize: 15.sp, fontWeight: FontWeight.w600, color: branding.secondaryText),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(fontSize: 15.sp, fontWeight: FontWeight.w600, color: branding.secondaryText),
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true, hintText: "0.00"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}