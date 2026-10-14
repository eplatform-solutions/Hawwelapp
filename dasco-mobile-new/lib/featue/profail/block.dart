import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/featue/idintity_veryfation/idinty_verv.dart';

class KycStatusPage extends StatelessWidget {
  final String status;
  final String reason;

  const KycStatusPage({super.key, required this.status, required this.reason});

  Color _statusColor() {
    switch (status) {
      case "blocked":
        return Colors.red.shade700;
      case "rejected":
      case "remove-verified":
        return Colors.orange.shade700;
      case "under-review":
        return Colors.blue.shade700;
      case "verified":
        return Colors.green.shade700;
      default:
        return Colors.black87;
    }
  }

  // Rejected / unapproved users are asked to resubmit; blocked users must go
  // through support first, so they get no upload shortcut.
  bool get _canResubmit => status == "rejected" || status == "remove-verified";

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    String statusText() {
      switch (status) {
        case "blocked":
          return AppTranslations.getText(context, "Blocked account");
        case "rejected":
          return AppTranslations.getText(context, "kyc_status_rejected_title");
        case "remove-verified":
          return AppTranslations.getText(context, "remove-verified");
        case "under-review":
          return AppTranslations.getText(
              context, "kyc_status_under_review_title");
        case "verified":
          return AppTranslations.getText(context, "kyc_status_verified_title");
        default:
          return AppTranslations.getText(context, "kyc_status_unknown_title");
      }
    }

    final showReason = reason.trim().isNotEmpty && status != "verified";

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
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                statusText(),
                style: GoogleFonts.cairo(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: _statusColor(),
                ),
                textAlign: TextAlign.center,
              ),
              if (showReason) ...[
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
              if (_canResubmit) ...[
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => idintyview()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: branding.accent,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    icon: const Icon(Icons.upload_file_rounded,
                        color: Colors.white),
                    label: Text(
                      AppTranslations.getText(context, "kyc_resubmit_button"),
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
