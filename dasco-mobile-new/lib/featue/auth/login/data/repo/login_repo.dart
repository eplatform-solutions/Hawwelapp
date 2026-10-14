import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/constans/localization/app_locale.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/featue/auth/login/data/repo/repo_implmantion.dart';

class ImplmentRepoLogin extends RepoLogin {
  final ApiService _apiService;

  ImplmentRepoLogin({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
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
      if (kDebugMode) {
        debugPrint('LOGIN request completed with status ${response.statusCode}');
      }

      final lang = await AppLocaleHelper.getLanguageCode();

      // تحقق مما إذا كان هناك session (يعني 2FA مطلوبة)
      final hasError = response.data["error"] == true;
      final hasSession = response.data["data"]?["session"] != null;

      if (hasError && hasSession) {
        final session = response.data["data"]["session"];
        final message = AppLocaleHelper.messageFromResponse(
              response.data["msg"],
              lang,
            ).isNotEmpty
            ? AppLocaleHelper.messageFromResponse(response.data["msg"], lang)
            : AppLocaleHelper.genericErrorFallback(lang);
        final result = {
          "status": "2fa_required",
          "session": session,
          "message": message,
        };
        return right(result);
      }

      // حالة النجاح
      if (response.data["error"] == false) {
        final token = (response.data["data"]?["token"] ?? "").toString().trim();

        if (token.isNotEmpty) {
          await Functions().setToken(token);
        } else {
          final missingTokenMessage = lang == 'ar'
              ? 'فشل إنشاء جلسة الدخول. يرجى المحاولة مرة أخرى.'
              : 'Failed to create login session. Please try again.';
          return left(ServierFailur(missingTokenMessage, 500));
        }

        final successResult = {"status": "success", "message": "login_success"};
        return right(successResult);
      }

      // فشل عادي
      final localizedMsg = AppLocaleHelper.messageFromResponse(
        response.data["msg"],
        lang,
      );
      String errorMessage = localizedMsg.isNotEmpty
          ? localizedMsg
          : AppLocaleHelper.loginErrorFallback(lang);
      int statusCode = response.statusCode ?? 500;

      return left(ServierFailur(errorMessage, statusCode));
    } catch (e) {
      if (e is DioException) {
        if (kDebugMode) {
          debugPrint(
            'LOGIN DioException status=${e.response?.statusCode} endpoint=${e.requestOptions.path}',
          );
        }
        final lang = await AppLocaleHelper.getLanguageCode();
        final failure = ServierFailur.fromDioError(e, lang: lang);
        return left(failure);
      }

      final failure = ServierFailur('Login failed: ${e.toString()}', 600);
      return left(failure);
    }
  }
}
// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hawwel/constans/api_servise.dart';
// import 'package:hawwel/constans/failear.dart';
// import 'package:hawwel/constans/token.dart';
// import 'package:hawwel/featue/auth/login/data/repo/repo_implmantion.dart';

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

