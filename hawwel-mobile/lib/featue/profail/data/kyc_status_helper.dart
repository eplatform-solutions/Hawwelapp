import 'package:hawwel/featue/profail/data/modal.dart';

class KycStatusHelper {
  static String resolve(StudentInfo user) {
    final normalized = user.kycStatus.trim();
    if (normalized.isNotEmpty) {
      return normalized;
    }
    return _fromRawStatus(user.kyc?.status ?? '');
  }

  static bool canTransfer(StudentInfo user) => resolve(user) == 'approved';

  /// Whether the user can do anything about their KYC right now - drives
  /// whether gates show an "upload" action or just an explanation.
  static bool canSubmitDocuments(StudentInfo user) {
    final state = resolve(user);
    return state == 'not_submitted' ||
        state == 'rejected' ||
        state == 'resubmission_required';
  }

  static String gateMessage(StudentInfo user, bool isArabic) {
    final localized = user.kycRequiredMessage;
    if (localized != null) {
      final message = isArabic ? localized['ar'] : localized['en'];
      if (message != null && message.trim().isNotEmpty) {
        return message;
      }
    }
    switch (resolve(user)) {
      case 'pending':
        return isArabic
            ? 'طلب التحقق من هويتك قيد المراجعة. يمكنك إنشاء الطلبات بعد الموافقة.'
            : 'Your identity verification is under review. You can create transfers once it is approved.';
      case 'rejected':
        return isArabic
            ? 'لم تتم الموافقة على التحقق من هويتك. يرجى إعادة تقديم المستندات.'
            : 'Your identity verification was not approved. Please resubmit your documents.';
      case 'resubmission_required':
        return isArabic
            ? 'تم رفع الحظر عن التحقق من هويتك. يرجى إعادة رفع مستنداتك لمتابعة عملية التحقق.'
            : 'Your identity verification block has been lifted. Please resubmit your documents to continue.';
      case 'blocked':
        return isArabic
            ? 'التحقق من هويتك محظور. يرجى التواصل مع الدعم.'
            : 'Your identity verification is blocked. Please contact support.';
      default:
        return isArabic
            ? 'يجب إكمال التحقق من الهوية قبل إنشاء طلب. يرجى إكمال KYC.'
            : 'Identity verification is required before you can create a transfer. Please complete KYC.';
    }
  }

  static String bannerMessage(StudentInfo user, bool isArabic) {
    return gateMessage(user, isArabic);
  }

  static String _fromRawStatus(String status) {
    switch (status) {
      case 'verified':
        return 'approved';
      case 'under-review':
        return 'pending';
      case 'rejected':
      case 'remove-verified':
        return 'rejected';
      // Distinct from 'rejected' so the UI never invites a blocked user to
      // upload documents the server will refuse.
      case 'blocked':
        return 'blocked';
      case 'cancel-blocked':
        return 'resubmission_required';
      default:
        return 'not_submitted';
    }
  }
}
