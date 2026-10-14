import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_amount_to_send.dart';

class TransferDetailsCard extends StatelessWidget {
  final double amount;
  final String fee;
  final double total;

  const TransferDetailsCard({
    super.key,
    required this.amount,
    required this.fee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final currencyName =
        context.read<CurrencyCubit>().state.currency.name.toUpperCase();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            _Row(
              icon: Icons.send_rounded,
              iconColor: branding.accent,
              label: AppTranslations.getText(context, 'transfer_amount'),
              value: '$amount $currencyName',
              valueColor: branding.accent,
              isFirst: true,
            ),
            _Divider(),
            _Row(
              icon: Icons.percent_rounded,
              iconColor: const Color(0xFFF59E0B),
              label: AppTranslations.getText(context, 'fees_label'),
              value: '$fee $currencyName',
              valueColor: const Color(0xFFF59E0B),
            ),
            _Divider(),
            _Row(
              icon: Icons.account_balance_wallet_rounded,
              iconColor: const Color(0xFF10B981),
              label: AppTranslations.getText(context, 'total amount'),
              value: '$total $currencyName',
              valueColor: const Color(0xFF10B981),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final bool isFirst;
  final bool isLast;

  const _Row({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: Row(
        children: [
          if (!isArabic) ...[
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: branding.primaryText,
                ),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ] else ...[
            Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.end,
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: branding.primaryText,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
          ],
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.grey.withValues(alpha: 0.1),
      indent: 18,
      endIndent: 18,
    );
  }
}