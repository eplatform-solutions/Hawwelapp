// update_info_repo_impl.dart

import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/profail/data/repo_put/repo.dart';

class UpdateInfoRepoImpl implements UpdateInfoRepo {
  final ApiService _apiService;

  UpdateInfoRepoImpl({required ApiService apiService})
    : _apiService = apiService;
  Future<Either<Failur, Map<String, dynamic>>> sendotpchang({
    required String email,
  }) async {
    try {
      Response res = await _apiService.postdata(
        endpoint: "/verification-codes/send",
        data: {"email": email, "typeOfUse": "change-email"},
        needtoken: false,
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      if (!res.data["error"]) {
        return right({
          "msg": res.data["msg"][lang],
          "session": res.data["data"]["session"],
        });
      } else {
        return left(ServierFailur(res.data["msg"][lang], 400));
      }
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failur, Map<String, dynamic>>> sendotpchangphone({
    required String phonenumber,
  }) async {
    log('--- 📲 بدء إرسال OTP عبر الهاتف ---');
    log('📞 الرقم المرسل: $phonenumber');

    try {
      log('🚀 إرسال طلب POST إلى /verification-codes/send...');

      Response res = await _apiService.postdata(
        endpoint: "/verification-codes/send",
        data: {
          "mobilePhone": phonenumber,
          "channel": "sms",
          "typeOfUse": "activate-account",
        },
        needtoken: false,
      );

      log('✅ استجابة API وصلت');
      log('📡 Status Code: ${res.statusCode}');
      log('📦 Response Data: ${res.data}');

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      log('🌐 لغة التطبيق الحالية: $lang');

      final hasError = res.data["error"] == true;
      final session = res.data["data"]?["session"];

      log('🔍 تحليل الاستجابة:');
      log('  error = ${res.data["error"]}');
      log('  session = $session');

      if (!hasError) {
        log('📨 OTP أُرسل بنجاح عبر SMS');

        return right({"msg": res.data["msg"][lang], "session": session});
      } else {
        final errorMsg = res.data["msg"]?[lang] ?? 'فشل إرسال رمز التحقق';

        log('❌ فشل في إرسال OTP');
        log('  الرسالة: $errorMsg');

        return left(ServierFailur(errorMsg, 400));
      }
    } catch (e, stackTrace) {
      log('💥 استثناء أثناء إرسال OTP عبر الهاتف');
      log('الخطأ: $e');
      log('تتبع الخطأ:\n$stackTrace');

      if (e is DioException) {
        log('⚠️ نوع الخطأ: DioException');

        if (e.response != null) {
          log('📡 Status Code: ${e.response?.statusCode}');
          log('📦 Error Data: ${e.response?.data}');
        }

        log('🔗 URL: ${e.requestOptions.uri}');

        final failure = ServierFailur.fromDioError(e);
        log('📤 إرجاع فشل: ${failure.errMassage}');

        return left(failure);
      }

      final failure = ServierFailur('Send OTP failed: ${e.toString()}', 500);

      log('📤 إرجاع فشل عام: ${failure.errMassage}');
      return left(failure);
    }
  }

  @override
  Future<Either<Failur, String>> updateUserInfo({
    required String email,
    required String mobilePhone,
    required String emailCode,
    required String emailSession,
    required String phoneCode,
    required String phoneSession,
  }) async {
    try {
      final data;
      if (mobilePhone.isNotEmpty &&
          phoneCode.isNotEmpty &&
          phoneSession.isNotEmpty) {
        data = {
          "mobilePhone": mobilePhone,
          "mobilePhoneCode": phoneCode,
          "sessionForMobilePhone": phoneSession,
        };
      } else if (emailCode.isNotEmpty &&
          email.isNotEmpty &&
          emailSession.isNotEmpty) {
        data = {
          "email": email,
          "emailCode": emailCode,
          "sessionForEmail": emailSession,
        };
      } else {
        data = {
          "email": email,
          "mobilePhone": mobilePhone,
          "emailCode": emailCode,
          "sessionForEmail": emailSession,
          "mobilePhoneCode": phoneCode,
          "sessionForMobilePhone": phoneSession,
        };
      }

      log("📤 PUT → /users/update");
      log("📦 DATA SENT → $data");

      final response = await _apiService.put(
        endpoint: "/users/update",
        data: data,
      );

      // ************* PRINT EVERYTHING *************
      log("📥 RESPONSE RECEIVED ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓");
      log("📌 STATUS CODE → ${response.statusCode}");
      log("📌 HEADERS → ${response.headers}");
      log("📌 FULL RAW DATA → ${response.data}");
      log("📌 REQUEST OPTIONS →");
      log("   - Method: ${response.requestOptions.method}");
      log("   - Path: ${response.requestOptions.path}");
      log("   - Base URL: ${response.requestOptions.baseUrl}");
      log("   - Headers: ${response.requestOptions.headers}");
      log("   - ContentType: ${response.requestOptions.contentType}");
      // ************************************************

      // 🌐 لغة التطبيق
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      final msgMap = response.data["msg"] as Map<String, dynamic>?;

      final message =
          msgMap?[lang] ??
          msgMap?["en"] ??
          msgMap?["ar"] ??
          "تم تحديث البيانات بنجاح";

      // ❗ API يرجع 200 حتى لو في خطأ
      if (response.data["error"] == true) {
        log("❌ UPDATE FAILED → $message");

        return Left(ServierFailur(message, response.statusCode ?? 400));
      }

      return Right(message);
    } catch (e) {
      if (e is DioException) {
        // ************** ERROR DEBUG ****************
        log("❌ DIO ERROR ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓");
        log("📌 TYPE → ${e.type}");
        log("📌 MESSAGE → ${e.message}");
        log("📌 STATUS CODE → ${e.response?.statusCode}");
        log("📌 HEADERS → ${e.response?.headers}");
        log("📌 ERROR DATA → ${e.response?.data}");
        log("📌 REQUEST OPTIONS → ${e.requestOptions}");
        log("📌 REQUEST DATA → ${e.requestOptions.data}");

        return Left(ServierFailur.fromDioError(e));
      }

      // ************** UNKNOWN ERROR ****************
      log("❌ UNKNOWN ERROR → $e");

      return Left(ServierFailur(e.toString(), 500));
    }
  }
}
