// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:usdt/constans/colors.dart';
// import 'package:usdt/constans/localization/app_tranzaction.dart';
// import 'package:usdt/constans/localization/lang_cubit.dart';

// class TextFieldCustom extends StatefulWidget {
//   final TextEditingController? controller;
//   final bool obscureText;
//   final String hintText;
//   final Widget? prefixIcon;
//   final Widget? suffix;
//   final TextStyle? hintStyle;
//   final TextInputType? type;
//   final int? maxLength;
//   final bool readOnly;
//   final void Function(String)? onChanged;
//   final String? Function(String?)? validator;

//   const TextFieldCustom({
//     super.key,
//     required this.controller,
//     this.obscureText = false,
//     required this.hintText,
//     this.prefixIcon,
//     this.hintStyle,
//     this.type,
//     this.suffix,
//     this.validator,
//     this.maxLength,
//     this.readOnly = false,
//     this.onChanged,
//   });

//   @override
//   State<TextFieldCustom> createState() => _TextFieldCustomState();
// }

// class _TextFieldCustomState extends State<TextFieldCustom> {
//   final GlobalKey<FormFieldState> _textFieldKey = GlobalKey<FormFieldState>();

//   @override
//   Widget build(BuildContext context) {
//     final language = context.watch<LanguageCubit>().state;
//     final isArabic = language == Language.arabic;

//     final errorText = _textFieldKey.currentState?.errorText;

//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: const Color(0xFFE9E9E9),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.grayColor.withOpacity(0.3),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: TextFormField(
//         key: _textFieldKey,
//         validator: widget.validator,
//         maxLength: widget.maxLength,
//         controller: widget.controller,
//         readOnly: widget.readOnly,
//         keyboardType: widget.type,
//         obscureText: widget.obscureText,

//         cursorColor: AppColors.primaryColor,

//         /// مهم جداً حتى يعيد بناء الحقل ويظهر الخطأ
//         // onChanged: (value) {
//         //   widget.onChanged?.call(value);
//         //   setState(() {
//         //     _textFieldKey.currentState?.validate();
//         //   });
//         // },
// onChanged: widget.onChanged,

//         textAlign: isArabic ? TextAlign.right : TextAlign.left,
//         textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,

//         decoration: InputDecoration(
//           prefixIcon: widget.prefixIcon,
//           suffixIcon: widget.suffix,
//           counterText: '',
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 13,
//           ),

//
//           hintText: errorText != null
//     ? AppTranslations.getText(context, errorText)
//     : widget.hintText,

//           //errorText ?? widget.hintText,

//           hintStyle: GoogleFonts.cairo(
//             color: errorText != null ? Colors.red : Colors.grey,
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//           ),

//           border: _buildNormalBorder(),
//           focusedBorder: _buildNormalBorder(),
//           enabledBorder: _buildNormalBorder(),
//           errorBorder: _buildErrorBorder(),
//           focusedErrorBorder: _buildErrorBorder(),

//           /// إخفاء النص الأحمر تحت الحقل
//           errorStyle: const TextStyle(fontSize: 0),
//         ),
//       ),
//     );
//   }

//   OutlineInputBorder _buildNormalBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(15),
//       borderSide: const BorderSide(color: Color(0xFF6B1F2A), width: 1),
//     );
//   }

//   OutlineInputBorder _buildErrorBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(15),
//       borderSide: BorderSide(color: AppColors.redColor, width: 1),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/localization/lang_cubit.dart';

class TextFieldCustom extends StatefulWidget {
  final TextEditingController? controller;
  final bool obscureText;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final TextStyle? hintStyle;
  final TextInputType? type;
  final int? maxLength;
  final bool readOnly;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  /// يُستدعى عند الضغط على الحقل (مفيد مع [readOnly] لأن [GestureDetector] الخارجي لا يستقبل النقر).
  final VoidCallback? onTap;

  const TextFieldCustom({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    this.prefixIcon,
    this.hintStyle,
    this.type,
    this.suffix,
    this.validator,
    this.maxLength,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  final GlobalKey<FormFieldState> _textFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final language = context.watch<LanguageCubit>().state;
    final isArabic = language == Language.arabic;

    final errorText = _textFieldKey.currentState?.errorText;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: branding.inputBorder,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: branding.hintText.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextFormField(
        key: _textFieldKey,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.disabled, // ✅ مهم
        maxLength: widget.maxLength,
        controller: widget.controller,
        readOnly: widget.readOnly,
        keyboardType: widget.type,
        obscureText: widget.obscureText,
        cursorColor: branding.iconPrimary,
        onChanged: widget.onChanged,
        onTap: widget.onTap,

        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,

        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffix,
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),

          /// ✅ رسالة الخطأ بدل الـ hintText
          hintText: errorText != null
              ? AppTranslations.getText(context, errorText)
              : widget.hintText,

          hintStyle: GoogleFonts.cairo(
            color: errorText != null ? branding.error : branding.hintText,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),

          border: _buildNormalBorder(),
          focusedBorder: _buildNormalBorder(),
          enabledBorder: _buildNormalBorder(),
          errorBorder: _buildErrorBorder(),
          focusedErrorBorder: _buildErrorBorder(),

          /// ❌ إخفاء رسالة الخطأ الافتراضية تحت الحقل
          errorStyle: const TextStyle(fontSize: 0),
        ),
      ),
    );
  }

  OutlineInputBorder _buildNormalBorder() {
    final branding = appBrandingNotifier.value;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: branding.iconPrimary, width: 1),
    );
  }

  OutlineInputBorder _buildErrorBorder() {
    final branding = appBrandingNotifier.value;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: branding.error, width: 1),
    );
  }
}
