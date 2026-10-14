// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:usdt/constans/api_servise.dart';
// import 'package:usdt/constans/failear.dart';
// import 'package:usdt/featue/auth/resst_passwrd/repo/repo.dart';

// class ChangePasswordRepoImpl implements ChangePasswordRepo {
//   final ApiService api;

//   ChangePasswordRepoImpl({required ApiService apiService}) : api = apiService;

//   @override
//   Future<Either<Failur, String>> changePassword({
//     required String password,
//     required String newPassword,
//   }) async {
//     try {
//       final response = await api.put(
//         endpoint: "/users/change-password",
//         data: {"password": password, "newPassword": newPassword},
//       );

//       log("🔐 CHANGE PASSWORD RESPONSE : ${response.data}");

//       final msg = response.data["msg"]["ar"] ?? "تم تغيير كلمة السر";

//       return Right(msg);
//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServierFailur.fromDioError(e));
//       }
//       return Left(ServierFailur(e.toString(), 500));
//     }
//   }
// }
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/resst_passwrd/repo/repo.dart';

class ChangePasswordRepoImpl implements ChangePasswordRepo {
  final ApiService api;

  ChangePasswordRepoImpl({required ApiService apiService}) : api = apiService;

  @override
  Future<Either<Failur, String>> changePassword({
    required String password,
    required String newPassword,
  }) async {
    try {
      // طباعة البيانات المرسلة (Request Data)
      log("🚀 SENDING CHANGE PASSWORD REQUEST...");
      log("📦 DATA: {password: $password, newPassword: $newPassword}");

      final response = await api.put(
        endpoint: "/users/change-password",
        data: {"password": password, "newPassword": newPassword},
      );

      // طباعة الرد الكامل (Full Response)
      log("✅ FULL RESPONSE DATA: ${response.data}");

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      // استخراج الرسالة بناءً على اللغة
      final msg = response.data["msg"] != null
          ? (response.data["msg"][lang] ?? response.data["msg"]["en"])
          : "Success";

      return Right(msg);
    } catch (e) {
      log("❌ ERROR IN CHANGE PASSWORD REPO");

      if (e is DioException) {
        // طباعة تفاصيل الخطأ القادم من السيرفر (Server Error Details)
        log("⚠️ DIO ERROR: ${e.type}");
        log("💬 SERVER RESPONSE: ${e.response?.data}");
        log("🔢 STATUS CODE: ${e.response?.statusCode}");

        return Left(ServierFailur.fromDioError(e));
      }

      log("❗ UNEXPECTED ERROR: ${e.toString()}");
      return Left(ServierFailur(e.toString(), 500));
    }
  }
}
