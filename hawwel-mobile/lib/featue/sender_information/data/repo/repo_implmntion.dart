// // import 'dart:developer';
// // import 'package:dartz/dartz.dart';
// // import 'package:dio/dio.dart';
// // import 'package:usdt/constans/api_servise.dart';
// // import 'package:usdt/constans/failear.dart';
// // import 'package:usdt/featue/sender_information/data/model.dart';
// // import 'package:usdt/featue/sender_information/data/repo/repo.dart';

// // class ReceiversDisplayRepoImpl extends ReceiversDisplayRepo {
// //  final ApiService _apiService;

// //   ReceiversDisplayRepoImpl({required ApiService apiService})
// //     : _apiService = apiService;

// //   @override
// //   Future<Either<Failur, List<ReceiversDisplayModel>>> getAllReceiversDisplay() async {
// //     try {
// //       log("📤 GET → /receivers/all-receivers");

// //       final response = await _apiService.get(
// //         endpoint: "/receivers/all-receivers",

// //       );

// //       log("📩 Response => ${response.data}");

// //       final data = response.data;

// //       final msg = data['msg'];
// //       String message;
// //       if (msg is Map) {
// //         message = msg['ar'] ?? msg['en'] ?? '';
// //       } else {
// //         message = msg.toString();
// //       }

// //       if (response.statusCode == 200) {
// //         final List list = data['data'];

// //         final receivers = list
// //             .map((e) => ReceiversDisplayModel.fromJson(e))
// //             .toList();

// //         return right(receivers);
// //       } else {
// //         return left(
// //           ServierFailur(
// //             message,
// //             response.statusCode ?? 400,
// //           ),
// //         );
// //       }
// //     } on DioException catch (e) {
// //       log("❌ Dio Error => ${e.response?.data}");
// //       return left(ServierFailur.fromDioError(e));
// //     } catch (e) {
// //       log("💥 Unexpected Error => $e");
// //       return left(ServierFailur(e.toString(), 600));
// //     }
// //   }
// // }
// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:usdt/constans/api_servise.dart';
// import 'package:usdt/constans/failear.dart';
// import 'package:usdt/featue/sender_information/data/model.dart';
// import 'package:usdt/featue/sender_information/data/repo/repo.dart';

// class ReceiversDisplayRepoImpl extends ReceiversDisplayRepo {
//   final ApiService _apiService;

//   ReceiversDisplayRepoImpl({required ApiService apiService})
//     : _apiService = apiService;

//   @override
//   @override
//   Future<Either<Failur, List<ReceiversDisplayModel>>> getAllReceiversDisplay({
//     String? fullName,
//   }) async {
//     try {
//       final response = await _apiService.getsearch(
//         endpoint: "/receivers/all-receivers",
//         queryParameters: (fullName != null && fullName.isNotEmpty)
//             ? {'fullName': fullName}
//             : null,
//       );

//       if (response.statusCode == 200) {
//         final List list = response.data['data'];
//         final receivers = list
//             .map((e) => ReceiversDisplayModel.fromJson(e))
//             .toList();
//         return right(receivers);
//       } else {
//         return left(ServierFailur("حدث خطأ ما", response.statusCode ?? 400));
//       }
//     } catch (e) {
//       return left(ServierFailur(e.toString(), 500));
//     }
//   }
// }
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/sender_information/data/model.dart';
import 'package:usdt/featue/sender_information/data/repo/repo.dart';

class ReceiversDisplayRepoImpl extends ReceiversDisplayRepo {
  final ApiService _apiService;

  ReceiversDisplayRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, List<ReceiversDisplayModel>>> getAllReceiversDisplay({
    String? fullName,
  }) async {
    try {
      log("📤 GET → /receivers/all-receivers | Search Name: $fullName");

      final response = await _apiService.getsearch(
        endpoint: "/receivers/all-receivers",
        queryParameters: (fullName != null && fullName.isNotEmpty)
            ? {'fullName': fullName}
            : null,
      );

      final data = response.data;

      // التعامل مع حالة النجاح 200 أو 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List list = data['data'];
        final receivers = list
            .map((e) => ReceiversDisplayModel.fromJson(e))
            .toList();
        return right(receivers);
      } else {
        // استخراج رسالة الخطأ المترجمة إذا السيرفر رجع statusCode غير النجاح
        return left(
          ServierFailur(_parseServerMessage(data), response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      log("❌ Dio Error => ${e.response?.data}");
      // الاعتماد على الميثود الاحترافية اللي عندك بملف الـ Failure
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      log("💥 Unexpected Error => $e");
      return left(ServierFailur("حدث خطأ غير متوقع، حاول لاحقاً", 500));
    }
  }

  // الميثود "المعلمة" لاستخراج الرسالة حسب اللغة
  String _parseServerMessage(dynamic data) {
    if (data != null && data['msg'] != null) {
      final msg = data['msg'];
      if (msg is Map) {
        // بيرجع العربي، وإذا ما فيه بيرجع الإنجليزي
        return msg['ar'] ?? msg['en'] ?? "حدث خطأ ما";
      }
      return msg.toString();
    }
    return "فشل الاتصال بالنظام";
  }
}
