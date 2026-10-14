// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:usdt/constans/api_servise.dart';
// import 'package:usdt/constans/failear.dart';
// import 'package:usdt/featue/profail/data/modal.dart';
// import 'package:usdt/featue/profail/data/repo/repo.dart';

// class Implemntuserinfo implements Repouserinfo {
//   final ApiService _apiService;

//   Implemntuserinfo({required ApiService apiService}) : _apiService = apiService;

//   @override
//   Future<Either<Failur, StudentInfo>> get_user_info() async {
//     try {
//       print("🚀 [GET_USER_INFO] Starting Request to: /users/info");

//       Response response = await _apiService.get(endpoint: "/users/info");

//       // 🔥 طباعة تفصيلية وشاملة للرد الناجح
//       print("✅ =============== [SUCCESS] USER INFO =============== ✅");
//       print("🔹 Status Code   : ${response.statusCode}");
//       print("🔹 Status Message: ${response.statusMessage}");
//       print(
//         "🔹 Headers       : ${response.headers}",
//       ); // عشان تتأكد من التوكن وغيره
//       print("🔹 Full JSON     : ${response.data}");

//       if (response.data is Map) {
//         print("🔹 Msg (AR)      : ${response.data["msg"]?["ar"]}");
//         print("🔹 Msg (EN)      : ${response.data["msg"]?["en"]}");
//         print("🔹 Data Object   : ${response.data["data"]}");
//       }
//       print("✅ ================================================== ✅");

//       final data = StudentInfo.fromJson(response.data["data"]);
//       return Right(data);
//     } catch (e, stacktrace) {
//       print("❌ =============== [ERROR] USER INFO =============== ❌");

//       if (e is DioException) {
//         print("🚩 Type        : ${e.type}");
//         print("🚩 Message     : ${e.message}");
//         print("🚩 Status Code : ${e.response?.statusCode}");
//         print("🚩 Error Data  : ${e.response?.data}");
//         print("🚩 Request Path: ${e.requestOptions.path}");
//         print("🚩 Req Headers : ${e.requestOptions.headers}");

//         return Left(ServierFailur.fromDioError(e));
//       }

//       // في حال كان الخطأ برمجي (مثل خطأ في الـ Model parsing)
//       print("🚩 Unknown Error : $e");
//       print(
//         "🚩 StackTrace    : $stacktrace",
//       ); // بيطبعلك وين السطر اللي ضرب بالكود
//       print("❌ ================================================== ❌");

//       return Left(ServierFailur(e.toString(), 500));
//     }
//   }
// }
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/profail/data/modal.dart';
import 'package:usdt/featue/profail/data/repo/repo.dart';

class Implemntuserinfo implements Repouserinfo {
  final ApiService _apiService;

  Implemntuserinfo({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failur, StudentInfo>> get_user_info() async {
    try {
      log("🚀 [GET_USER_INFO] Starting Request to: /users/info");

      Response response = await _apiService.get(endpoint: "/users/info");
      final responseData = response.data;

      // حالة النجاح (عادة 200 أو 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ [SUCCESS] User Info Received");
        final data = StudentInfo.fromJson(responseData["data"]);
        return Right(data);
      } else {
        // إذا رجع السيرفر كود فشل (مثلاً 403 أو 503 صيانة)
        log("⚠️ [SERVER_ERROR] Status: ${response.statusCode}");
        return Left(
          ServierFailur(
            _parseServerMessage(responseData),
            response.statusCode ?? 400,
          ),
        );
      }
    } on DioException catch (e) {
      log("❌ [DIO_ERROR] => ${e.response?.data}");
      // الاعتماد على الميثود اللي بتعالج الـ Timeout والـ Connection
      return Left(ServierFailur.fromDioError(e));
    } catch (e, stacktrace) {
      log("💥 [UNKNOWN_ERROR] => $e");
      log("🚩 StackTrace: $stacktrace");
      return Left(ServierFailur("حدث خطأ غير متوقع في معالجة البيانات", 500));
    }
  }

  // الميثود "المعلمة" لاستخراج الرسالة حسب اللغة (عشان توحد السيستم بكل الـ Repos)
  String _parseServerMessage(dynamic data) {
    if (data != null && data['msg'] != null) {
      final msg = data['msg'];
      if (msg is Map) {
        return msg['ar'] ?? msg['en'] ?? "فشل في جلب بيانات المستخدم";
      }
      return msg.toString();
    }
    return "لا يمكن الوصول إلى خادم المعلومات حالياً";
  }
}
