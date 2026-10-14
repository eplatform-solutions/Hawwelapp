import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/digit_utils.dart';

/// بطاقة "أنت ترسل" — عرض فقط، أو إدخال عبر [amountController] عند [editable].
class Trsletastkbl2 extends StatelessWidget {
  static const Color _kDarkText = Color(0xFF111827);

  final String text1; // label  e.g. "أنت ترسل"
  final String text2; // symbol e.g. "USDT"
  final String text3; // amount e.g. "120.00" (يُتجاهل عند التفعيل editable)
  final bool editable;
  final TextEditingController? amountController;
  final ValueChanged<String>? onAmountChanged;

  const Trsletastkbl2({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
    this.editable = false,
    this.amountController,
    this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;

    final labelStyle = GoogleFonts.cairo(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      color: _kDarkText,
      height: 1.2,
    );

    final amountStyle = GoogleFonts.cairo(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: _kDarkText,
      height: 1.1,
    );

    final hintStyle = GoogleFonts.cairo(
      fontSize: 20.sp,
      fontWeight: FontWeight.w400,
      color: _kDarkText.withValues(alpha: 0.35),
      height: 1.1,
    );

    final symbolStyle = GoogleFonts.cairo(
      fontSize: 11.sp,
      fontWeight: FontWeight.w700,
      color: _kDarkText,
    );

    return Container(
      width: 148.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: branding.cardBg,
        border: Border.all(
          color: branding.accent.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: labelStyle,
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: editable && amountController != null
                    ? TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: const [
                          WesternDigitsTextInputFormatter(),
                        ],
                        onChanged: onAmountChanged,
                        textAlign: TextAlign.center,
                        style: amountStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: '0.00',
                          hintStyle: hintStyle,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                    : Text(
                        text3.isEmpty ? '0.00' : text3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: amountStyle,
                      ),
              ),
              SizedBox(width: 6.w),
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(text2, style: symbolStyle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
