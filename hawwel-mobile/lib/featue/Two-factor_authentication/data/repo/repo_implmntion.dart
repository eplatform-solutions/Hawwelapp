import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/featue/Two-factor_authentication/data/repo/modal.dart';
import 'package:usdt/featue/Two-factor_authentication/data/repo/repo.dart';
import 'dart:developer';

class Change2FARepositoryImpl implements Change2FARepository {
  final ApiService api;

  Change2FARepositoryImpl({required ApiService apiService}) : api = apiService;

  // @override
  // Future<Either<Failur, Change2FAResponse>> change2FA({
  //   required bool enabled,
  //   required List<String> methods,
  // }) async {
  //   try {
  //     log("📤 PUT REQUEST → /users/change-2fa-status");
  //     log("🔸 REQUEST BODY → { enabled: $enabled, methods: $methods }");

  //     final response = await api.put(
  //       endpoint: "/users/change-2fa-status",
  //       data: {"enabled": enabled, "methods": methods},
  //     );

  //     log("📥 SERVER RESPONSE RAW → ${response.data}");
  //     log("📌 STATUS CODE → ${response.statusCode}");
  //     log("📌 HEADERS → ${response.headers}");

  //     if (response.statusCode == 200 && response.data != null) {
  //       log(
  //         "✅ SUCCESS PARSED MODEL → ${Change2FAResponse.fromJson(response.data)}",
  //       );
  //       return right(Change2FAResponse.fromJson(response.data));
  //     }

  //     log("❗ SERVER RETURNED INVALID RESPONSE FORMAT");

  //     return left(
  //       ServierFailur("Unexpected server response", response.statusCode ?? 500),
  //     );
  //   } on DioException catch (e) {
  //     log("💥 DIO ERROR CAUGHT!");
  //     log("🔸 Dio Message → ${e.message}");
  //     log("🔸 Dio Type → ${e.type}");
  //     log("🔸 Dio Response → ${e.response?.data}");
  //     log("🔸 Status Code → ${e.response?.statusCode}");

  //     return left(ServierFailur.fromDioError(e));
  //   } catch (e) {
  //     log("🔥 NON-DIO ERROR → $e");
  //     return left(ServierFailur(e.toString(), 500));
  //   }
  // }
  @override
  Future<Either<Failur, Change2FAResponse>> change2FA({
    required bool enabled,
    required List<String> methods,
  }) async {
    try {
      log("📤 PUT REQUEST → /users/change-2fa-status");
      log("🔸 REQUEST BODY → { enabled: $enabled, methods: $methods }");

      final response = await api.put(
        endpoint: "/users/change-2fa-status",
        data: {"enabled": enabled, "methods": methods},
      );

      log("📥 SERVER RESPONSE RAW → ${response.data}");
      log("📌 STATUS CODE → ${response.statusCode}");
      log("📌 HEADERS → ${response.headers}");

      // 🌐 لغة التطبيق
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      // 📩 رسائل السيرفر
      final msgMap = response.data["msg"] as Map<String, dynamic>?;

      // ✅ اختيار الرسالة حسب لغة التطبيق
      final message =
          msgMap?[lang] ??
          msgMap?["en"] ??
          msgMap?["ar"] ??
          "تم تحديث إعدادات التحقق بخطوتين";

      // ❗ السيرفر يرجع 200 حتى لو في خطأ
      if (response.data["error"] == true) {
        log("❌ CHANGE 2FA FAILED → $message");

        return left(ServierFailur(message, response.statusCode ?? 400));
      }

      // ✅ نجاح → رجّع الموديل
      if (response.statusCode == 200 && response.data != null) {
        final model = Change2FAResponse.fromJson(response.data,lang);

        log("✅ SUCCESS PARSED MODEL → $model");

        return right(model);
      }

      log("❗ SERVER RETURNED INVALID RESPONSE FORMAT");

      return left(ServierFailur(message, response.statusCode ?? 500));
    } on DioException catch (e) {
      log("💥 DIO ERROR CAUGHT!");
      log("🔸 Dio Message → ${e.message}");
      log("🔸 Dio Type → ${e.type}");
      log("🔸 Dio Response → ${e.response?.data}");
      log("🔸 Status Code → ${e.response?.statusCode}");

      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      log("🔥 NON-DIO ERROR → $e");
      return left(ServierFailur(e.toString(), 500));
    }
  }
}
