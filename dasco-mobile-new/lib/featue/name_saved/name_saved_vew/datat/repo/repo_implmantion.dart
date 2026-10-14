// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:hawwel/constans/api_servise.dart';
// import 'package:hawwel/constans/failear.dart';
// import 'package:hawwel/featue/name_saved/name_saved_vew/datat/repo/repo.dart';

// class ReceiversRepoImpl extends ReceiversRepo {
//   final ApiService _apiService;

//   ReceiversRepoImpl({required ApiService apiService})
//     : _apiService = apiService;

//  @override
// Future<Either<Failur, String>> addReceiver({
//   required String fullName,
//   required String mobilePhone,
// }) async {
//   try {
//     log("📤 Sending Receiver => $fullName , $mobilePhone");

//     final response = await _apiService.postdata(
//       endpoint: "/receivers/add",
//       data: {
//         "fullName": fullName,
//         "mobilePhone": mobilePhone,
//       },
//       needtoken: true,
//     );

//     log("📩 Response => ${response.data}");

//     final data = response.data;
//     final msg = data["msg"];

//     
//     String message;
//     if (msg is String) {
//       message = msg;
//     } else if (msg is Map) {
//       // اختر اللغة (عربي / إنجليزي)
//       message = msg["ar"] ?? msg["en"] ?? "Success";
//     } else {
//       message = "Success";
//     }

//     // ⚠️ السيرفر عندك يرجع error=true حتى بالنجاح
//     if (response.statusCode == 200) {
//       return right(message);
//     } else {
//       return left(
//         ServierFailur(
//           message,
//           response.statusCode ?? 400,
//         ),
//       );
//     }
//   } on DioException catch (e) {
//     log("❌ Dio Error => ${e.response?.data}");
//     return left(ServierFailur.fromDioError(e));
//   } catch (e) {
//     log("💥 Unexpected Error => $e");
//     return left(ServierFailur(e.toString(), 600));
//   }
// }

// }
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/repo/repo.dart';

class ReceiversRepoImpl extends ReceiversRepo {
  final ApiService _apiService;

  ReceiversRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, String>> addReceiver({
    required String fullName,
    required String mobilePhone,
  }) async {
    log("📤 Sending Receiver => $fullName , $mobilePhone");

    try {
      final response = await _apiService.postdata(
        endpoint: "/receivers/add",
        data: {"fullName": fullName, "mobilePhone": mobilePhone},
        needtoken: true,
      );

      log("📥 RESPONSE DATA → ${response.data}");
      log("📌 STATUS CODE → ${response.statusCode}");

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";
      log("🌐 App Language → $lang");

      final data = response.data;
      final msg = data["msg"];

      // ✅ نفس منطق login
      String message;
      if (msg is Map) {
        message = msg[lang] ?? msg["en"] ?? msg["ar"] ?? "Operation completed";
      } else if (msg is String) {
        message = msg;
      } else {
        message = "Operation completed";
      }

      // ⚠️ السيرفر عندك يرجع error=true حتى بالنجاح
      if (response.statusCode == 200) {
        log("✅ ADD RECEIVER SUCCESS → $message");
        return right(message);
      }

      log("❌ ADD RECEIVER FAILED → $message");
      return left(ServierFailur(message, response.statusCode ?? 400));
    } on DioException catch (e) {
      log("💥 DIO ERROR");
      log("📌 STATUS → ${e.response?.statusCode}");
      log("📦 DATA → ${e.response?.data}");
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      log("🔥 UNEXPECTED ERROR → $e");
      return left(ServierFailur(e.toString(), 600));
    }
  }
}
