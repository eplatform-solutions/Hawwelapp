import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/colors.dart';
import 'package:usdt/constans/localization/lang_cubit.dart';

class TextFieldCustompayment extends StatefulWidget {
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

  const TextFieldCustompayment({
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
  });

  @override
  State<TextFieldCustompayment> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustompayment> {
  final GlobalKey<FormFieldState> _textFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state;
    final isArabic = language == Language.arabic;
    final branding = appBrandingNotifier.value;
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: branding.inputBg,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayColor.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextFormField(
        key: _textFieldKey,
        validator: widget.validator,
        maxLength: widget.maxLength,
        controller: widget.controller,
        keyboardType: widget.type,
        obscureText: widget.obscureText,
        cursorColor: AppColors.primaryColor,
        cursorErrorColor: AppColors.redColor,
        readOnly: widget.readOnly,
        onChanged: widget.onChanged,

        // ✅ اتجاه النص ديناميكي بناءً على اللغة
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,

        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon, // ✅ تبقى الأيقونة على اليسار
          suffixIcon: widget.suffix,
          counterText: '', // لإخفاء عداد الأحرف

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          hintText: widget.hintText,

          border: buildOutlineInputBorder(),
          focusedBorder: buildOutlineInputBorder(),
          enabledBorder: buildOutlineInputBorder(),
          errorBorder: buildErrorOutlineInputBorder(),
          focusedErrorBorder: buildErrorOutlineInputBorder(),

          errorStyle: TextStyle(
            color: AppColors.redColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),

          // ✅ لو ما مرّرت hintStyle، بيعطيه ستايل افتراضي
          hintStyle: GoogleFonts.cairo(
            color: branding.hintText,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: appBrandingNotifier.value.inputBorder, width: 1),
    );
  }

  OutlineInputBorder buildErrorOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(width: 1, color: AppColors.redColor),
    );
  }
}
