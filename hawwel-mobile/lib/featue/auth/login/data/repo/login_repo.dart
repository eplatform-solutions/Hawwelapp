import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/constans/token.dart';
import 'package:usdt/featue/auth/login/data/repo/repo_implmantion.dart';

class ImplmentRepoLogin extends RepoLogin {
  final ApiService _apiService;

  ImplmentRepoLogin({required ApiService apiService})
    : _apiService = apiService;

  Future<Either<Failur, dynamic>> login({
    required String email,
    required String password,
  }) async {
    log('--- بدء عملية تسجيل الدخول ---');
    log('📧 البريد الإلكتروني: $email');
    // لا نطبع كلمة المرور لأسباب أمنية (حتى في debug)
    log('🔑 تم إدخال كلمة المرور (مخفيّة لأسباب أمنية)');

    try {
      log('🚀 إرسال طلب POST إلى /auth/login...');
final value = email.trim();

final isPhone = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value);
final Map<String, dynamic> requestData = {
  if (isPhone) "mobilePhone": value else "email": value,
  "password": password,
};

      Response response = await _apiService.postdata(
        endpoint: "/auth/login",
        data: requestData,
        needtoken: false,
      );

      log('✅ استجابة API وصلت:');
      log('الحالة (status code): ${response.statusCode}');
      log('البيانات الكاملة (response.data): ${response.data}');

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";
      log('🌐 لغة التطبيق الحاليّة: $lang');

      // تحقق مما إذا كان هناك session (يعني 2FA مطلوبة)
      final hasError = response.data["error"] == true;
      final hasSession = response.data["data"]?["session"] != null;

      log('🔍 تحليل الاستجابة:');
      log('  error = ${response.data["error"]}');
      log('  session موجود؟ $hasSession');

      if (hasError && hasSession) {
        final session = response.data["data"]["session"];
        final message = response.data["msg"]?[lang] ?? "رسالة غير متوفرة";
        log('🔐 تم اكتشاف تفعيل التحقق بخطوتين (2FA)');
        log('  session: $session');
        log('  رسالة السيرفر: $message');

        final result = {
          "status": "2fa_required",
          "session": session,
          "message": message,
        };
        log('📤 إرجاع نتيجة: 2FA مطلوبة');
        return right(result);
      }

      // حالة النجاح
      if (response.data["error"] == false) {
        final token = response.data["data"]?["token"];
        log('🎉 تسجيل الدخول ناجح!');

        if (token != null) {
          log('💾 حفظ التوكن في SharedPreference...');
          await Functions().setToken(token);
          log('✅ التوكن حُفظ بنجاح');
        } else {
          log('⚠️ تحذير: لم يتم استلام توكن من السيرفر!');
        }

        final successResult = {"status": "success", "message": "login_success"};
        log('📤 إرجاع نتيجة: نجاح');
        return right(successResult);
      }

      // فشل عادي
      String errorMessage =
          response.data["msg"]?[lang] ?? "خطأ أثناء تسجيل الدخول";
      int statusCode = response.statusCode ?? 500;

      log('❌ فشل في تسجيل الدخول:');
      log('  الرسالة: $errorMessage');
      log('  كود الحالة: $statusCode');

      return left(ServierFailur(errorMessage, statusCode));
    } catch (e, stackTrace) {
      log('💥 استثناء غير متوقع أثناء تسجيل الدخول:');
      log('الخطأ: $e');
      log('تتبع الخطأ:\n$stackTrace');

      if (e is DioException) {
        log('نوع الخطأ: DioException');
        if (e.response != null) {
          log('كود الاستجابة: ${e.response?.statusCode}');
          log('بيانات الخطأ: ${e.response?.data}');
        }
        if (e.requestOptions != null) {
          log('الـ URL: ${e.requestOptions.uri}');
        }
        final failure = ServierFailur.fromDioError(e);
        log('📤 إرجاع فشل من نوع DioException: ${failure.errMassage}');
        return left(failure);
      }

      final failure = ServierFailur('Login failed: ${e.toString()}', 600);
      log('📤 إرجاع فشل عام: ${failure.errMassage}');
      return left(failure);
    }
  }
}
// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:usdt/constans/api_servise.dart';
// import 'package:usdt/constans/failear.dart';
// import 'package:usdt/constans/token.dart';
// import 'package:usdt/featue/auth/login/data/repo/repo_implmantion.dart';

// class ImplmentRepoLogin extends RepoLogin {
//   final ApiService _apiService;

//   ImplmentRepoLogin({required ApiService apiService})
//     : _apiService = apiService;
// Future<Either<Failur, dynamic>> login({
//   required String email,
//   required String password,
// }) async {
//   try {
//     Response response = await _apiService.postdata(
//       endpoint: "/auth/login",
//       data: {"email": email, "password": password},
//       needtoken: false,
//     );

//     final prefs = await SharedPreferences.getInstance();
//     final lang = prefs.getString("app_language") ?? "ar";

//     // إذا السيرفر رجع error = true لكن فيه session → يعني 2FA مفعّلة
//     if (response.data["error"] == true &&
//         response.data["data"]?["session"] != null) {
//       return right({
//         "status": "2fa_required",
//         "session": response.data["data"]["session"],
//         "message": response.data["msg"][lang]
//       });
//     }

//     // نجاح
//     if (response.data["error"] == false) {
//       String token = response.data["data"]["token"];
//       await Functions().setToken(token);

//       return right({
//         "status": "success",
//         "message": "login_success",
//       });
//     }

//     // فشل عادي
//     String errorMessage =
//         response.data["msg"]?[lang] ??
//         "خطأ أثناء تسجيل الدخول";

//     return left(ServierFailur(errorMessage, response.statusCode ?? 500));

//   } catch (e) {
//     return left(ServierFailur(e.toString(), 600));
//   }
// }

  // @override
  // Future<Either<Failur, String>> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     Response response = await _apiService.postdata(
  //       endpoint: "/auth/login",
  //       data: {"email": email, "password": password},
  //       needtoken: false,
  //     );

  //     final prefs = await SharedPreferences.getInstance();
  //     final lang = prefs.getString("app_language") ?? "ar";

  //     log("LOGIN RESPONSE: ${response.data}");

     
  //     if (response.statusCode == 200 && response.data["error"] == false) {
      
  //       String? token = response.data["data"]?["token"];

  //       if (token == null || token.isEmpty) {
  //         return left(
  //           ServierFailur("Token not found in server response!", 400),
  //         );
  //       }

      
  //       await Functions().setToken(token);

  //       return right("login_success");
  //     }

     
  //     String errorMessage =
  //         response.data["msg"]?[lang] ??
  //         response.data["msg"]?["ar"] ??
  //         "حدث خطأ أثناء تسجيل الدخول.";

  //     return left(ServierFailur(errorMessage, response.statusCode ?? 500));
  //   } on DioException catch (e) {
  //     return left(ServierFailur.fromDioError(e));
  //   } catch (e) {
  //     return left(ServierFailur(e.toString(), 600));
  //   }
  // }

