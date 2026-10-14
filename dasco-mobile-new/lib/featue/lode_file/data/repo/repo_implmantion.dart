// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:hawwel/constans/api_servise.dart';
// import 'package:hawwel/constans/failear.dart';
// import 'package:hawwel/featue/lode_file/data/repo/repo.dart';

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
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/lode_file/data/repo/repo.dart';
import 'package:http_parser/http_parser.dart'; // مهم جداً للتعرف على نوع الملف

class KycRepoImpl implements KycRepo {
  final ApiService api;

  KycRepoImpl(this.api);

  @override
  Future<Either<Failur, String>> uploadKyc(
    String firstFilePath,
    String secondFilePath,
  ) async {
    try {
      Future<MultipartFile> buildPart(String filePath, String fieldName) async {
        final extension = filePath.split('.').last.toLowerCase();
        final mimeSubtype = extension == 'jpg' ? 'jpeg' : extension;
        final type = extension == 'pdf' ? 'application' : 'image';
        return MultipartFile.fromFile(
          filePath,
          filename: '$fieldName.$extension',
          contentType: MediaType(type, mimeSubtype),
        );
      }

      final formData = FormData.fromMap({
        "kycFile1": await buildPart(firstFilePath, 'kyc_document_1'),
        "kycFile2": await buildPart(secondFilePath, 'kyc_document_2'),
      });

      final response = await api.postdata2(
        endpoint: "/kyc/create",
        data: formData,
        needtoken: true,
      );

      final responseData = response.data;

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
        // نرجعه كـ Left ليتحول الـ Cubit فوراً لحالة Failure
        return Left(ServierFailur(serverMessage, response.statusCode ?? 400));
      }

      return Right(serverMessage);
    } catch (e) {
      if (e is DioException) {
        return Left(ServierFailur.fromDioError(e));
      }

      return Left(ServierFailur("حدث خطأ غير متوقع: ${e.toString()}", 500));
    }
  }
}
