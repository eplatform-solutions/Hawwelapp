import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';

class KycStatusPage extends StatelessWidget {
  final String status;
  final String reason;

  const KycStatusPage({super.key, required this.status, required this.reason});

  Color _statusColor() {
    switch (status) {
      case "blocked":
        return Colors.red.shade700;
      case "rejected":
        return Colors.orange.shade700;
      case "under-review":
        return Colors.blue.shade700;
      default:
        return Colors.black87;
    }
  }

  // String _statusText() {
  //   switch (status) {
  //     case "blocked":
  //       return AppTranslations.getText(context, key);
  //     case "rejected":
  //       return "❌ طلب التحقق مرفوض";
  //     case "under-review":
  //       return "⏳ قيد المراجعة";
  //     default:
  //       return "ℹ️ حالة غير معروفة";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    String _statusText() {
      switch (status) {
        case "blocked":
          return AppTranslations.getText(context, "Blocked account");
        case "rejected":
          return "❌ طلب التحقق مرفوض";
        case "under-review":
          return "⏳ قيد المراجعة";
        default:
          return "ℹ️ حالة غير معروفة";
      }
    }

    return Scaffold(
      backgroundColor: branding.appBar,
      appBar: AppBar(
        backgroundColor: branding.appBar,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          AppTranslations.getText(context, "Verification status"),
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 320.w,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: branding.badge,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _statusText(),
                style: GoogleFonts.cairo(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: _statusColor(),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Text(
                AppTranslations.getText(context, "the reason:"),
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                reason,
                style: GoogleFonts.cairo(fontSize: 17.sp, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
