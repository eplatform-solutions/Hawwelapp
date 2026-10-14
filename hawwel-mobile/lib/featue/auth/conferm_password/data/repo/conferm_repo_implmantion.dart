// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:usdt/constans/api_servise.dart';
// import 'package:usdt/constans/failear.dart';
// import 'package:usdt/featue/auth/conferm_password/data/repo/conferm_repo.dart';

// class ImplmentConfirmRepo extends ConfirmRepo {
//   final ApiService _apiService;

//   ImplmentConfirmRepo({required ApiService apiService})
//     : _apiService = apiService;

//   @override
//   Future<Either<Failur, String>> confirmPassword({
//     required String password,
//     required String otp,
//     required String session,
//   }) async {
//     try {
//       log(
//         "🔐 Sending data => session: $session , otp: $otp , password: $password",
//       );

//       final response = await _apiService.put(
//         endpoint: "/auth/reset-password",
//         //  needtoken: false,
//         data: {"session": session, "code": otp, "password": password},
//       );

//       log("📩 Response: ${response.data}");

//       if (response.statusCode == 200 || response.data["success"] == true) {
//         return right(response.data["message"] ?? "Password updated");
//       }
//       else {
//         return left(
//           ServierFailur(
//             response.data["message"] ?? "Unknown error",
//             response.statusCode ?? 400,
//           ),
//         );
//       }
//     } on DioException catch (e) {
//       log("❌ DioException: ${e.response?.data}");
//       return left(ServierFailur.fromDioError(e));
//     } catch (e) {
//       log("💥 Unexpected: $e");
//       return left(ServierFailur(e.toString(), 600));
//     }
//   }
// }
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/conferm_password/data/repo/conferm_repo.dart';

class ImplmentConfirmRepo extends ConfirmRepo {
  final ApiService _apiService;

  ImplmentConfirmRepo({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, String>> confirmPassword({
    required String password,
    required String otp,
    required String session,
  }) async {
    try {
      log(
        "🔐 Sending data => session: $session , otp: $otp , password: $password",
      );

      final response = await _apiService.put(
        endpoint: "/auth/reset-password",
        data: {"session": session, "code": otp, "password": password},
      );

      log("📩 Response: ${response.data}");

      
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";
      log("🌐 App Language: $lang");

      
      if (response.statusCode == 200 || response.data["success"] == true) {
        final message = response.data["msg"]?[lang] ?? "Password updated";
        return right(message);
      }

     
      final errorMessage = response.data["msg"]?[lang] ?? "Unknown error";

      return left(ServierFailur(errorMessage, response.statusCode ?? 400));
    } on DioException catch (e) {
      log("❌ DioException: ${e.response?.data}");
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      log("💥 Unexpected: $e");
      return left(ServierFailur(e.toString(), 600));
    }
  }
}
