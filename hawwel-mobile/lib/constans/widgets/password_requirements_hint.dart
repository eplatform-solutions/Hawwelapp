import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';

/// النص التوضيحي الموحّد لشروط كلمة المرور، يُعرض تحت حقل كلمة المرور في
/// شاشات التسجيل وإعادة التعيين وتأكيد كلمة المرور الجديدة.
class PasswordRequirementsHint extends StatelessWidget {
  const PasswordRequirementsHint({super.key});

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;

    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Text(
        AppTranslations.getText(context, 'password_requirements_hint'),
        style: GoogleFonts.cairo(
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w500,
          color: branding.secondaryText,
        ),
      ),
    );
  }
}
