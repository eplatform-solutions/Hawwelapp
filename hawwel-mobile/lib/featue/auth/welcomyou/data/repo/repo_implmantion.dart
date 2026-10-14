import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_country.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo/repo.dart';

// class CountriesRepoImpl implements CountriesRepo {
//   final ApiService _apiService;

//   CountriesRepoImpl({required ApiService apiService})
//       : _apiService = apiService;

//   @override
//   Future<Either<Failur, List<CountryModel>>> getCountries() async {
//     try {
//       print('--- إرسال طلب GET إلى /countries/all ---');
//       final response = await _apiService.get(endpoint: '/countries/all');

//       print('استجابة الـ API: ${response.data}');

//       final list = (response.data['data'] as List)
//           .map((e) {
//             print('معالجة عنصر الدولة: $e');
//             return CountryModel.fromJson(e);
//           })
//           .toList();

//       print('القائمة النهائية بعد  الطلب: $list');
//       return Right(list);
//     } catch (e) {
//       print('حدث خطأ أثناء جلب الدول: $e');
//       if (e is DioException) {
//         final failure = ServierFailur.fromDioError(e);
//         print('فشل من نوع DioException: ${failure.errMassage} (كود: ${failure.statusCode})');
//         return Left(failure);
//       }
//       final failure = ServierFailur(e.toString(), 500);
//       print('خطأ غير معروف: ${failure.errMassage}');
//       return Left(failure);
//     }
//   }
// }
class CountriesRepoImpl implements CountriesRepo {
  final ApiService _apiService;

  CountriesRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, List<CountryModel>>> getCountries() async {
    try {
      debugPrint('--- إرسال طلب GET إلى /countries/all ---');
      final response = await _apiService.get(
        endpoint: '/countries/all',
        needtoken: false,
      );

      final list = (response.data['data'] as List)
          .map((e) => CountryModel.fromJson(e))
          .toList();

      return Right(list);
    } catch (e) {
      // 2. معالجة الخطأ حسب اللغة
      final prefs = await SharedPreferences.getInstance();
      final String lang = prefs.getString("app_language") ?? "ar";

      if (e is DioException) {
        // إذا كان السيرفر باعت رد (Bad Response) متل حالة الصيانة اللي بعتها
        if (e.response != null && e.response!.data is Map) {
          final data = e.response!.data;

          // التأكد إذا كان الـ msg موجود وفيه لغات
          if (data['msg'] != null && data['msg'] is Map) {
            String serverMessage =
                data['msg'][lang] ?? data['msg']['ar'] ?? "Error";
            return Left(
              ServierFailur(serverMessage, e.response?.statusCode ?? 500),
            );
          }
        }

        // إذا ما في رد مفصل من السيرفر، بنستخدم الـ fromDioError العادية
        return Left(ServierFailur.fromDioError(e));
      }

      return Left(ServierFailur(e.toString(), 500));
    }
  }
}
