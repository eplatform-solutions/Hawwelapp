// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:usdt/constans/api_servise.dart';
// import 'package:usdt/constans/failear.dart';
// import 'package:usdt/featue/lode_file/data/repo/repo.dart';

// class KycRepoImpl implements KycRepo {
//   final ApiService api;

//   KycRepoImpl(this.api);

//   @override
//   Future<Either<Failur, String>> uploadKyc(String filePath) async {
//     try {
//       log("📤 UPLOAD FILE → $filePath");

//       final formData = FormData.fromMap({
//         "kycFile": await MultipartFile.fromFile(filePath),
//       });

//       log("📤 POST → /kyc/create");
//       log("📦 DATA → $formData");

//       final response = await api.postdata2(
//         endpoint: "/kyc/create",
//         data: formData,
//        needtoken: true
//       );

//       log("📥 RESPONSE → ${response.data}");

//       final msg = response.data["msg"]["ar"] ??
//           response.data["msg"]["en"] ??
//           "تم رفع المستند بنجاح";

//       return Right(msg);
//     } catch (e) {
//       if (e is DioException) {
//         log("❌ DIO ERROR → ${e.response?.data}");
//         return Left(ServierFailur.fromDioError(e));
//       }

//       log("❌ UNKNOWN ERROR → $e");
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
import 'package:usdt/featue/lode_file/data/repo/repo.dart';
import 'package:http_parser/http_parser.dart'; // مهم جداً للتعرف على نوع الملف

class KycRepoImpl implements KycRepo {
  final ApiService api;

  KycRepoImpl(this.api);

  @override
  Future<Either<Failur, String>> uploadKyc(String filePath) async {
    try {
      log("📤 [REPO] بدء رفع الملف: $filePath");

      // تجهيز نوع الملف لضمان عدم حدوث خطأ Invalid Real File Type
      String extension = filePath.split('.').last.toLowerCase();
      String mimeSubtype = extension == 'jpg' ? 'jpeg' : extension;
      String type = (extension == 'pdf') ? 'application' : 'image';

      final formData = FormData.fromMap({
        "kycFile": await MultipartFile.fromFile(
          filePath,
          filename: 'kyc_document.$extension',
          contentType: MediaType(type, mimeSubtype),
        ),
      });

      final response = await api.postdata2(
        endpoint: "/kyc/create",
        data: formData,
        needtoken: true,
      );

      final responseData = response.data;
      log("📥 [REPO] استجابة السيرفر: $responseData");

      // 1. جلب لغة التطبيق
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      // 2. استخراج الرسالة بناءً على اللغة
      String serverMessage = "";
      if (responseData['msg'] is Map) {
        serverMessage =
            responseData['msg'][lang] ??
            responseData['msg']['ar'] ??
            "خطأ غير معروف";
      } else {
        serverMessage = responseData['msg']?.toString() ?? "تمت العملية";
      }

      // 3. التحقق من الخطأ المنطقي (هنا الحل لمنع التعليق في الـ Loading)
      if (responseData['error'] == true) {
        log("⚠️ [REPO] خطأ منطقي من السيرفر: $serverMessage");
        // نرجعه كـ Left ليتحول الـ Cubit فوراً لحالة Failure
        return Left(ServierFailur(serverMessage, response.statusCode ?? 400));
      }

      // 4. حالة النجاح الحقيقي
      log("✅ [REPO] رفع الملف بنجاح");
      return Right(serverMessage);
    } catch (e) {
      if (e is DioException) {
        log("❌ [REPO] Dio Error:");
        log("  ↳ Status Code : ${e.response?.statusCode}");
        log("  ↳ Status Msg  : ${e.response?.statusMessage}");
        log("  ↳ Response    : ${e.response?.data}");
        log("  ↳ Request URL : ${e.requestOptions.uri}");
        log("  ↳ Request Data: ${e.requestOptions.data}");
        log("  ↳ Dio Message : ${e.message}");
        return Left(ServierFailur.fromDioError(e));
      }

      log("❌ [REPO] Unexpected Error: $e");
      log("  ↳ Type: ${e.runtimeType}");
      return Left(ServierFailur("حدث خطأ غير متوقع: ${e.toString()}", 500));
    }
  }
}
