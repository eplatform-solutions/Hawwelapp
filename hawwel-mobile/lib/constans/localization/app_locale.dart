import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Single source of truth for app language code used by UI and API messages.
class AppLocaleHelper {
  static const String prefKey = 'app_language';

  static Future<String> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(prefKey)) {
      final saved = prefs.getString(prefKey);
      return saved == 'ar' ? 'ar' : 'en';
    }
    final deviceLang =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return deviceLang == 'ar' ? 'ar' : 'en';
  }

  /// Persists device-resolved language on first launch so repos match UI locale.
  static Future<void> persistLanguageIfMissing() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(prefKey)) {
      final code = await getLanguageCode();
      await prefs.setString(prefKey, code);
    }
  }

  static String messageFromResponse(dynamic msg, String lang) {
    if (msg is Map) {
      final primary = msg[lang]?.toString().trim();
      if (primary != null && primary.isNotEmpty) return primary;

      final en = msg['en']?.toString().trim();
      if (en != null && en.isNotEmpty) return en;

      final ar = msg['ar']?.toString().trim();
      if (ar != null && ar.isNotEmpty) return ar;
    } else if (msg is String && msg.trim().isNotEmpty) {
      return msg.trim();
    }
    return '';
  }

  static String genericErrorFallback(String lang) {
    return lang == 'ar'
        ? 'حدث خطأ، حاول لاحقاً'
        : 'Something went wrong. Please try again.';
  }

  static String loginErrorFallback(String lang) {
    return lang == 'ar'
        ? 'خطأ أثناء تسجيل الدخول'
        : 'Login failed. Please try again.';
  }

  /// Detects common invalid-credential responses from backend (any language).
  static bool isInvalidCredentialsMessage(String message) {
    final lower = message.toLowerCase();

    final hasCredentialHint = lower.contains('بريد') ||
        lower.contains('email') ||
        lower.contains('هاتف') ||
        lower.contains('phone') ||
        lower.contains('mobile') ||
        lower.contains('جوال');

    final hasPasswordHint = lower.contains('password') ||
        lower.contains('كلمة') ||
        lower.contains('سر');

    final hasInvalidHint = lower.contains('incorrect') ||
        lower.contains('غير صحيح') ||
        lower.contains('wrong') ||
        lower.contains('invalid') ||
        lower.contains('عذراً') ||
        lower.contains('sorry');

    return (hasCredentialHint && hasPasswordHint) ||
        (hasInvalidHint && (hasCredentialHint || hasPasswordHint));
  }

  /// Detects duplicate-phone responses before/during signup OTP.
  static bool isPhoneAlreadyRegisteredMessage(String message) {
    final lower = message.toLowerCase();
    const hints = [
      'already registered',
      'already exists',
      'phone already',
      'mobile already',
      'number already',
      'user already',
      'account already',
      'مسجل مسبق',
      'رقم الهاتف مسجل',
      'الرقم مسجل',
      'موجود مسبق',
      'هذا الرقم',
      'مستخدم بالفعل',
    ];
    return hints.any((h) => lower.contains(h));
  }
}
