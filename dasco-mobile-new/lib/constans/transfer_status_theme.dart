import 'package:flutter/material.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';

class TransferStatusVisual {
  final String normalizedStatus;
  final String bucket;
  final Color color;
  final IconData icon;

  const TransferStatusVisual({
    required this.normalizedStatus,
    required this.bucket,
    required this.color,
    required this.icon,
  });
}

class NotificationVisual {
  final Color accentColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const NotificationVisual({
    required this.accentColor,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });
}

String normalizeTransferStatus(String? raw) =>
    (raw ?? '').trim().toLowerCase().replaceAll('_', '-');

String transferStatusBucket(String? rawStatus) {
  final s = normalizeTransferStatus(rawStatus);
  if (s == 'pending' || s == 'under-paid' || s == 'over-paid') {
    return 'awaiting-payment';
  }
  if (s == 'full-paid') return 'paid';
  if (s == 'preparing-address' || s == 'address-preparing') return 'processing';
  if (s == 'can-receive' || s == 'ready-to-receive') return 'can-receive';
  if (s == 'received' ||
      s == 'is-received' ||
      s == 'completed' ||
      s == 'compleated') {
    return 'received';
  }
  if (s == 'cancelled' || s == 'expired') return 'cancelled';
  if (s == 'rejected' || s == 'dispute' || s == 'conflict') return 'dispute';
  return 'awaiting-payment';
}

bool isAwaitingPaymentStatus(String? rawStatus) =>
    transferStatusBucket(rawStatus) == 'awaiting-payment';

TransferStatusVisual resolveTransferStatusVisual(
  String? rawStatus,
  AppBrandingConfig branding,
) {
  final s = normalizeTransferStatus(rawStatus);
  final bucket = transferStatusBucket(s);

  switch (s) {
    case 'under-paid':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: const Color(0xFFF59E0B),
        icon: Icons.warning_amber_rounded,
      );
    case 'over-paid':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: const Color(0xFFEA580C),
        icon: Icons.warning_rounded,
      );
    case 'pending':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: const Color(0xFF2563EB),
        icon: Icons.hourglass_top_rounded,
      );
    case 'full-paid':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: const Color(0xFF0EA5E9),
        icon: Icons.paid_rounded,
      );
    case 'preparing-address':
    case 'address-preparing':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: const Color(0xFF7C3AED),
        icon: Icons.inventory_2_rounded,
      );
    case 'can-receive':
    case 'ready-to-receive':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: const Color(0xFF06B6D4),
        icon: Icons.local_shipping_rounded,
      );
    case 'received':
    case 'is-received':
    case 'completed':
    case 'compleated':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: branding.success,
        icon: Icons.check_circle_rounded,
      );
    case 'cancelled':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: branding.error,
        icon: Icons.cancel_rounded,
      );
    case 'expired':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: const Color(0xFFB91C1C),
        icon: Icons.timer_off_rounded,
      );
    case 'rejected':
    case 'dispute':
    case 'conflict':
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: const Color(0xFF7C3AED),
        icon: Icons.gpp_bad_rounded,
      );
    default:
      return TransferStatusVisual(
        normalizedStatus: s,
        bucket: bucket,
        color: branding.hintText,
        icon: Icons.info_rounded,
      );
  }
}

String transferStatusBucketLabel(BuildContext context, String bucket) {
  switch (bucket) {
    case 'awaiting-payment':
      return AppTranslations.getText(context, 'transfer_status_pending');
    case 'paid':
      return AppTranslations.getText(context, 'transfer_status_full_paid');
    case 'processing':
      return AppTranslations.getText(
        context,
        'transfer_status_preparing_address',
      );
    case 'can-receive':
      return AppTranslations.getText(context, 'transfer_status_can_receive');
    case 'received':
      return AppTranslations.getText(context, 'transfer_status_received');
    case 'cancelled':
      return AppTranslations.getText(context, 'transfer_status_cancelled');
    case 'dispute':
      return AppTranslations.getText(context, 'transfer_status_dispute');
    default:
      return AppTranslations.getText(context, 'transfer_status_pending');
  }
}

String transferStatusLabel(BuildContext context, String status) {
  return AppTranslations.transferStatusLabel(context, status);
}

bool isPaymentProofNotification({String? title, String? body, String? status}) {
  final t = (title ?? '').toLowerCase();
  final b = (body ?? '').toLowerCase();
  final s = normalizeTransferStatus(status);
  if (t.contains('payment proof') || b.contains('payment proof')) return true;
  if (t.contains('إثبات') || b.contains('إثبات')) return true;
  return s == 'can-receive' && (t.contains('proof') || b.contains('proof'));
}

NotificationVisual resolveNotificationVisual({
  required AppBrandingConfig branding,
  String? status,
  String? title,
  String? body,
}) {
  if (isPaymentProofNotification(title: title, body: body, status: status)) {
    const accent = Color(0xFF7C3AED);
    return NotificationVisual(
      accentColor: accent,
      icon: Icons.receipt_long_rounded,
      iconColor: accent,
      iconBackground: accent.withValues(alpha: 0.12),
    );
  }

  final statusVisual = resolveTransferStatusVisual(status, branding);
  return NotificationVisual(
    accentColor: statusVisual.color,
    icon: statusVisual.icon,
    iconColor: statusVisual.color,
    iconBackground: statusVisual.color.withValues(alpha: 0.12),
  );
}
