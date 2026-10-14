import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/localization/lang_cubit.dart';

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
  final List<TextInputFormatter>? inputFormatters;

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
    this.inputFormatters,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  final GlobalKey<FormFieldState> _textFieldKey = GlobalKey<FormFieldState>();

  // The validation message is a translation key returned by the validator.
  // It used to be shown only by replacing the hint, which is invisible as
  // soon as the field has text - so a short/invalid entry produced a red
  // border and nothing else. Now it is also rendered under the field.
  String? _errorKey;

  String? _runValidator(String? value) {
    final result = widget.validator?.call(value);
    if (result != _errorKey) {
      // validate() runs from a button handler, never during build, but the
      // FormField rebuilds itself first - defer our own rebuild one frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _errorKey = result);
      });
    }
    return result;
  }

  void _handleChanged(String value) {
    if (_errorKey != null) {
      // Re-check while typing so the message clears once the input is fixed.
      _textFieldKey.currentState?.validate();
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final language = context.watch<LanguageCubit>().state;
    final isArabic = language == Language.arabic;

    final errorText = _errorKey;
    final hasText = widget.controller?.text.isNotEmpty ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: branding.inputBorder,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: branding.hintText.withValues(alpha: 0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: TextFormField(
            key: _textFieldKey,
            validator: _runValidator,
            autovalidateMode: AutovalidateMode.disabled, // ✅ مهم
            maxLength: widget.maxLength,
            controller: widget.controller,
            readOnly: widget.readOnly,
            keyboardType: widget.type,
            obscureText: widget.obscureText,
            // Password fields: no autocorrect / suggestions even while the
            // eye toggle shows the text - keyboards must not "fix" it.
            autocorrect: widget.type != TextInputType.visiblePassword,
            enableSuggestions: widget.type != TextInputType.visiblePassword,
            cursorColor: branding.iconPrimary,
            onChanged: _handleChanged,
            onTap: widget.onTap,
            inputFormatters: widget.inputFormatters,

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

              /// ✅ رسالة الخطأ بدل الـ hintText (عندما يكون الحقل فارغاً)
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

              /// ❌ إخفاء رسالة الخطأ الافتراضية تحت الحقل (نرسمها بأنفسنا أدناه)
              errorStyle: const TextStyle(fontSize: 0, height: 0),
            ),
          ),
        ),
        // Only needed when the hint (which already carries the message) is
        // hidden behind typed text.
        if (errorText != null && hasText)
          Padding(
            padding: EdgeInsets.only(top: 5.h, left: 6.w, right: 6.w),
            child: Text(
              AppTranslations.getText(context, errorText),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.cairo(
                color: branding.error,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  OutlineInputBorder _buildNormalBorder() {
    final branding = appBrandingNotifier.value;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: branding.iconPrimary, width: 2),
    );
  }

  OutlineInputBorder _buildErrorBorder() {
    final branding = appBrandingNotifier.value;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: branding.error, width: 2),
    );
  }
}
