// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:hawwel/constans/api_servise.dart';
// import 'package:hawwel/constans/failear.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/model_city.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/repo_city/repo_city.dart';

// class CitiesRepoImpl implements CitiesRepo {
//   final ApiService _apiService;

//   CitiesRepoImpl({required ApiService apiService})
//       : _apiService = apiService;

//   @override
//   Future<Either<Failur, List<CityModel>>> getCitiesByCountry(
//     String countryId,
//   ) async {
//     print('--- بدء جلب المدن لدولة ذات المعرّف: $countryId ---');

//     try {
//       final res = await _apiService.get(
//         endpoint: '/cities/country/$countryId',
//       );

//       print('✅ استجابة API ناجحة:');
//       print('الحالة (status code): ${res.statusCode}');
//       print('البيانات الخام (res.data): ${res.data}');

//       final List? data = res.data['data'];

//       if (data == null) {
//         print('⚠️ تحذير: الحقل "data" غير موجود أو null في الاستجابة!');
//         return Left(ServierFailur('Invalid response format: missing "data"', 500));
//       }

//       print('عدد العناصر في data: ${data.length}');

//       final cities = data.map((e) {
//         print('معالجة عنصر مدينة: $e');
//         final city = CityModel.fromJson(e);
//         print('المدينة  المطلوبة: ${city.toString()}');
//         return city;
//       }).toList();

//       print('✅ تم  طلب ${cities.length} مدينة بنجاح.');
//       print('القائمة النهائية:');
//       cities.forEach((city) => print('- ${city.name ?? 'بدون اسم'}'));

//       return Right(cities);

//     } catch (e, stackTrace) {
//       print('❌ حدث خطأ أثناء جلب المدن:');
//       print('الخطأ: $e');
//       print('تتبع الخطأ (stack trace):\n$stackTrace');

//       if (e is DioException) {
//         final failure = ServierFailur.fromDioError(e);
//         print('فشل من نوع DioException:');
//         print('  الرسالة: ${failure.errMassage}');
//         print('  كود الحالة: ${failure.statusCode}');
//         return Left(failure);
//       }

//       final failure = ServierFailur('Failed to load cities: ${e.toString()}', 500);
//       print('فشل غير معروف: ${failure.errMassage}');
//       return Left(failure);
//     }
//   }
// }
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:hawwel/constans/api_servise.dart';
// import 'package:hawwel/constans/failear.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/model_city.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/repo_city/repo_city.dart';

// class CitiesRepoImpl implements CitiesRepo {
//   final ApiService _apiService;

//   CitiesRepoImpl({required ApiService apiService}) : _apiService = apiService;

//   @override
//   Future<Either<Failur, List<CityModel>>> getCitiesByCountry(String countryId) async {
//     try {
//       final res = await _apiService.get(endpoint: '/cities/country/$countryId');

//       final List? data = res.data['data'];
//       if (data == null) {
//         return Left(ServierFailur('بيانات المدن غير متوفرة', 500));
//       }

//       final cities = data.map((e) => CityModel.fromJson(e)).toList();
//       return Right(cities);

//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServierFailur.fromDioError(e));
//       }
//       return Left(ServierFailur('حدث خطأ غير متوقع: ${e.toString()}', 500));
//     }
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_city/repo_city.dart';

class CitiesRepoImpl implements CitiesRepo {
  final ApiService _apiService;
  CitiesRepoImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failur, List<CityModel>>> getCitiesByCountry(String countryId) async {
    try {
      final res = await _apiService.get(
        endpoint: '/cities/country/$countryId',
        needtoken: false,
      );

      // لا توجد مدن لهذا البلد (بلد يعتمد فقط على طريقة دفع على مستوى
      // البلد) - السيرفر بيرجع error: true و data: {} بدل List، فنعتبرها
      // قائمة فاضية بدل اعتبارها فشلاً حقيقياً في الطلب.
      final bool isError = res.data['error'] ?? false;
      final dynamic rawData = res.data['data'];
      if (isError || rawData is! List) {
        return const Right([]);
      }

      // نمرر البيانات للـ Model (الذي سيحفظ اللغتين)
      final cities = rawData.map((e) => CityModel.fromJson(e)).toList();

      return Right(cities);
    } catch (e) {
      if (e is DioException) {
        return Left(ServierFailur.fromDioError(e));
      }
      return Left(ServierFailur('حدث خطأ: ${e.toString()}', 500));
    }
  }
}