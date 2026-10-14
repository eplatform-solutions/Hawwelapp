import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/localization/lang_cubit.dart';
import 'package:flutter/services.dart';

class TextFieldCustomspeand extends StatefulWidget {
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

  const TextFieldCustomspeand({
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
  State<TextFieldCustomspeand> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustomspeand> {
  final GlobalKey<FormFieldState> _textFieldKey = GlobalKey<FormFieldState>();

  void _copyToClipboard() {
    if (widget.controller?.text != null && widget.controller!.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: widget.controller!.text));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppTranslations.getText(context, 'copied_to_clipboard'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final language = context.watch<LanguageCubit>().state;
    final isArabic = language == Language.arabic;
    
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        // ❌ تم إزالة الـ border من الـ Container كليًا
      ),
      child: TextFormField(
        key: _textFieldKey,
        validator: widget.validator,
        maxLength: widget.maxLength,
        controller: widget.controller,
        keyboardType: widget.type,
        obscureText: widget.obscureText,
        cursorColor: branding.iconPrimary,
        cursorErrorColor: branding.error,
        readOnly: widget.readOnly,
        onChanged: widget.onChanged,
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,

        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: IconButton(
            onPressed: _copyToClipboard,
            icon: Icon(Icons.content_copy, color: branding.hintText),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          hintText: widget.hintText,

          // ✅ الحدود الوحيدة هنا — من الـ InputDecoration
          border: buildOutlineInputBorder(),
          enabledBorder: buildOutlineInputBorder(),
          focusedBorder: buildOutlineInputBorder(),
          errorBorder: buildErrorOutlineInputBorder(),
          focusedErrorBorder: buildErrorOutlineInputBorder(),

          errorStyle: TextStyle(
            color: branding.error,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
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
    final branding = appBrandingNotifier.value;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: branding.accent, width: 1.5),
    );
  }

  OutlineInputBorder buildErrorOutlineInputBorder() {
    final branding = appBrandingNotifier.value;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(width: 1.5, color: branding.error),
    );
  }
}
