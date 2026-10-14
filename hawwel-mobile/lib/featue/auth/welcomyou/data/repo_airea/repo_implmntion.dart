// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:hawwel/constans/api_servise.dart';
// import 'package:hawwel/constans/failear.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/model_airea.dart';
// import 'package:hawwel/featue/auth/welcomyou/data/repo_airea/repo.dart';

// class AreasRepoImpl implements AreasRepo {
//   final ApiService _apiService;

//   AreasRepoImpl({required ApiService apiService}) : _apiService = apiService;

//   @override
//   Future<Either<Failur, List<AreaModel>>> getAreasByCity(String cityId) async {
//     print('--- بدء جلب المناطق للمدينة ذات المعرّف: $cityId ---');

//     try {
//       final res = await _apiService.get(endpoint: '/areas/city/$cityId');

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

//       final areas = data.map((e) {
//         print('معالجة عنصر منطقة: $e');
//         final area = AreaModel.fromJson(e);
//         print('المنطقة  المطلوبة: ${area.toString()}');
//         return area;
//       }).toList();

//       print('✅ تم  الطلب ${areas.length} منطقة بنجاح.');
//       print('القائمة النهائية للمناطق:');
//       areas.asMap().forEach((i, area) {
//         print(
//           '- [$i] ${area.name ?? 'بدون اسم'} (ID: ${area.id ?? 'غير معروف'})',
//         );
//       });

//       return Right(areas);
//     } catch (e, stackTrace) {
//       print('❌ حدث خطأ أثناء جلب المناطق:');
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
//         'Failed to load areas: ${e.toString()}',
//         500,
//       );
//       print('فشل غير معروف: ${failure.errMassage}');
//       return Left(failure);
//     }
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_airea.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_airea/repo.dart';

class AreasRepoImpl implements AreasRepo {
  final ApiService _apiService;

  AreasRepoImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failur, List<AreaModel>>> getAreasByCity(String cityId) async {
    try {
      final res = await _apiService.get(
        endpoint: '/areas/city/$cityId',
        needtoken: false,
      );

      final data = res.data['data'];

      if (data == null || data is! List) {
        return Left(ServierFailur('بيانات المناطق غير متوفرة أو بتنسيق خاطئ', 500));
      }

      // تحويل البيانات باستخدام الموديل الجديد الذي يدعم اللغتين
      final areas = data.map((e) => AreaModel.fromJson(e)).toList();

      return Right(areas);
    } catch (e) {
      if (e is DioException) {
        return Left(ServierFailur.fromDioError(e));
      }
      return Left(ServierFailur('حدث خطأ غير متوقع: ${e.toString()}', 500));
    }
  }
}