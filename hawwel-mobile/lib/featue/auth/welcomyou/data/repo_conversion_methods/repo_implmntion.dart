import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';

import 'package:usdt/featue/auth/welcomyou/data/repo_conversion_methods/repo.dart';
import 'package:usdt/featue/transaction_historu/data/model.dart';

// class PaymentMethodsRepoImpl implements PaymentMethodsRepo {
//   final ApiService _apiService;

//   PaymentMethodsRepoImpl({required ApiService apiService})
//     : _apiService = apiService;

//   @override
//   Future<Either<Failur, List<PaymentMethodModel>>> getByArea(
//     String areaId,
//   ) async {
//     print('--- بدء جلب وسائل الدفع للمنطقة ذات المعرّف: $areaId ---');

//     try {
//       final res = await _apiService.get(
//         endpoint: '/payment-methods/area/$areaId',
//       );

//       print('✅ استجابة API ناجحة:');
//       print('الحالة (status code): ${res.statusCode}');
//       print('البيانات الخام (res.data): ${res.data}');

//       final data = res.data['data'];

//       if (data == null) {
//         print('⚠️ تحذير: الحقل "data" غير موجود أو null في الاستجابة!');
//         return Left(
//           ServierFailur('Invalid response: missing "data" field', 500),
//         );
//       }

//       if (data is! List) {
//         print(
//           '⚠️ خطأ: الحقل "data" ليس قائمة! النوع الفعلي: ${data.runtimeType}',
//         );
//         return Left(
//           ServierFailur('Invalid response format: "data" is not a list', 500),
//         );
//       }

//       print('عدد العناصر في "data": ${data.length}');

//       final methods = data.map((e) {
//         print('معالجة عنصر وسيلة دفع: $e');
//         final method = PaymentMethodModel.fromJson(e);
//         print('الوسيلة  المطلوبة: ${method.toString()}');
//         return method;
//       }).toList();

//       print('✅ تم  طلب ${methods.length} وسيلة دفع بنجاح.');
//       print('القائمة النهائية لوسائل الدفع:');
//       methods.asMap().forEach((i, method) {
//         print(
//           '- [$i] ${method.name ?? 'بدون اسم'} (ID: ${method.id ?? 'غير معروف'})',
//         );
//       });

//       return Right(methods);
//     } catch (e, stackTrace) {
//       print('❌ حدث خطأ أثناء جلب وسائل الدفع:');
//       print('الخطأ: $e');
//       print('تتبع الخطأ (stack trace):\n$stackTrace');

//       if (e is DioException) {
//         final failure = ServierFailur.fromDioError(e);
//         print('فشل من نوع DioException:');
//         print('  الرسالة: ${failure.errMassage}');
//         print('  كود الحالة: ${failure.statusCode}');
//         return Left(failure);
//       }

//       final failure = ServierFailur(
//         'Failed to load payment methods: ${e.toString()}',
//         500,
//       );
//       print('فشل غير معروف: ${failure.errMassage}');
//       return Left(failure);
//     }
//   }
// }

// class PaymentMethodsRepoImpl implements PaymentMethodsRepo {
//   final ApiService _apiService;

//   PaymentMethodsRepoImpl({required ApiService apiService})
//     : _apiService = apiService;

//   @override
//   Future<Either<Failur, List<PaymentMethodModel>>> getByArea(
//     String areaId,
//   ) async {
//     try {
//       final res = await _apiService.get(
//         endpoint: '/payment-methods/area/$areaId',
//       );

//       final data = res.data['data'];
//       print(data);
//       if (data == null || data is! List) {
//         return Left(ServierFailur('بيانات وسائل الدفع غير متوفرة', 500));
//       }

//       // تحويل البيانات للموديل الجديد (بدون أي مشاكل في النوع)
//       final methods = data.map((e) => PaymentMethodModel.fromJson(e)).toList();

//       return Right(methods);
//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServierFailur.fromDioError(e));
//       }
//       return Left(ServierFailur('حدث خطأ: ${e.toString()}', 500));
//     }
//   }
// }
import 'dart:developer'; // لاستخدام log بدلاً من print (أفضل في Flutter)
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodsRepoImpl implements PaymentMethodsRepo {
  final ApiService _apiService;

  PaymentMethodsRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, (List<PaymentMethodModel>, String)>> getByArea(
    String areaId,
  ) async {
    log('--- 🛰️ [START PAYMENT METHODS REQUEST] ---');
    log('📍 Area ID: $areaId');

    try {
      final res = await _apiService.get(
        endpoint: '/payment-methods/area/$areaId',
        needtoken: false,
      );

      log('📥 [RESPONSE RECEIVED]');
      log('📊 Status Code: ${res.statusCode}');
      log('📦 Full Body: ${res.data}');

      // 1. جلب اللغة المحفوظة في التطبيق
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";
      log('🌐 App Language from SharedPrefs: $lang');

      // 2. استخراج الرسالة بناءً على لغة التطبيق
      final serverMsg = res.data['msg'];
      String messageFromServer = "";

      if (serverMsg is Map) {
        messageFromServer =
            serverMsg[lang] ??
            serverMsg['ar'] ??
            serverMsg['en'] ??
            'No message';
      } else {
        messageFromServer = serverMsg?.toString() ?? 'No msg field';
      }
      log('📢 Selected Message to Show: $messageFromServer');

      // 3. التحقق من الخطأ المنطقي (Error: true)
      final bool isError = res.data['error'] ?? false;
      if (isError) {
        log(
          '⚠️ [REPO] Logic Error Detected (error: true). Returning empty list.',
        );
        return Right(([], messageFromServer));
      }

      // 4. معالجة البيانات
      final data = res.data['data'];
      final List<PaymentMethodModel> methods = [];

      if (data is List) {
        log('🔄 Mapping ${data.length} items...');
        for (var i = 0; i < data.length; i++) {
          try {
            methods.add(PaymentMethodModel.fromJson(data[i]));
          } catch (e) {
            log('❌ Parsing Item Error at index $i: $e');
          }
        }
      } else {
        log('🧐 Data field is not a list (Expected for empty results).');
      }

      log('✅ [SUCCESS] Found ${methods.length} methods.');
      return Right((methods, messageFromServer));
    } catch (e, stackTrace) {
      log('🔥 [CRITICAL REPO ERROR]');
      log('🛑 Exception: $e');
      log('📚 Stack: $stackTrace');

      if (e is DioException) {
        log('🌐 Dio Response Status: ${e.response?.statusCode}');
        return Left(ServierFailur.fromDioError(e));
      }
      return Left(ServierFailur('Unexpected Error: ${e.toString()}', 500));
    }
  }
}
