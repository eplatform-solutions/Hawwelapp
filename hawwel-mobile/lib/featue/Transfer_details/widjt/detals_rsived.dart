import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';

class ReceiverDetailsCard extends StatelessWidget {
  final String name;
  final String phone;
  final double amount;
  final String qq;
  final String city;
  final String area;
  final String pickupPoint;
  final String exchangeRate;

  const ReceiverDetailsCard({
    super.key,
    required this.qq,
    required this.area,
    required this.name,
    required this.phone,
    required this.amount,
    required this.city,
    required this.pickupPoint,
    required this.exchangeRate,
  });

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;

    final rows = [
      _RowData(
        icon: Icons.person_rounded,
        iconColor: branding.accent,
        labelKey: 'recipient',
        value: name,
      ),
      _RowData(
        icon: Icons.phone_rounded,
        iconColor: const Color(0xFF10B981),
        labelKey: 'phone_number',
        value: phone,
        ltr: true,
      ),
      _RowData(
        icon: Icons.payments_rounded,
        iconColor: const Color(0xFFF59E0B),
        labelKey: 'recipient receives',
        value: '$amount $qq',
      ),
      _RowData(
        icon: Icons.location_city_rounded,
        iconColor: const Color(0xFF6366F1),
        labelKey: 'city',
        value: city,
      ),
      _RowData(
        icon: Icons.map_rounded,
        iconColor: const Color(0xFFEC4899),
        labelKey: 'Area',
        value: area,
      ),
      _RowData(
        icon: Icons.storefront_rounded,
        iconColor: const Color(0xFF0EA5E9),
        labelKey: 'Pickup location',
        value: pickupPoint,
      ),
      if (exchangeRate.isNotEmpty)
        _RowData(
          icon: Icons.currency_exchange_rounded,
          iconColor: const Color(0xFF22C55E),
          labelKey: 'exchange_rate',
          value: exchangeRate,
        ),
    ];

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
            for (int i = 0; i < rows.length; i++) ...[
              _DetailRow(data: rows[i]),
              if (i < rows.length - 1)
                Divider(
                  height: 1,
                  color: Colors.grey.withValues(alpha: 0.1),
                  indent: 18,
                  endIndent: 18,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RowData {
  final IconData icon;
  final Color iconColor;
  final String labelKey;
  final String value;
  final bool ltr;

  const _RowData({
    required this.icon,
    required this.iconColor,
    required this.labelKey,
    required this.value,
    this.ltr = false,
  });
}

class _DetailRow extends StatelessWidget {
  final _RowData data;
  const _DetailRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: data.iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.iconColor, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.getText(context, data.labelKey),
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: branding.secondaryText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                data.ltr
                    ? Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          data.value,
                          style: GoogleFonts.cairo(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: branding.primaryText,
                          ),
                        ),
                      )
                    : Text(
                        data.value,
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: branding.primaryText,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}