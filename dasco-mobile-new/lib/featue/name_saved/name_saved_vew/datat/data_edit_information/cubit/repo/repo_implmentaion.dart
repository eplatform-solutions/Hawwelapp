import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/data_edit_information/cubit/repo/repo.dart';

class UpdateReceiverRepoImpl implements UpdateReceiverRepo {
  final ApiService _apiService;
  UpdateReceiverRepoImpl(this._apiService);

  @override
  Future<Either<Failur, String>> updateReceiver({
    required String receiverId,
    required String fullName,
    required String mobilePhone,
  }) async {
    try {
      final data = {
        "fullName": fullName,
        "mobilePhone": mobilePhone,
      };

      // الرابط بناءً على الصورة المرسلة
      final endpoint = "/receivers/update/$receiverId";

      final response = await _apiService.put(
        endpoint: endpoint,
        data: data,
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      final raw = response.data["msg"];
      final msg = raw is Map ? (raw[lang] ?? raw["ar"] ?? "Success") : raw.toString();

      if (response.data["error"] == false) {
        return Right(msg);
      } else {
        return Left(ServierFailur(msg, 400));
      }
    } on DioException catch (e) {
      return Left(ServierFailur.fromDioError(e));
    } catch (e) {
      return Left(ServierFailur(e.toString(), 500));
    }
  }
  @override
Future<Either<Failur, String>> deleteReceiver(String receiverId) async {
  try {
    final endpoint = "/receivers/delete/$receiverId"; // تأكد من المسار الصحيح من الـ API
    
    final response = await _apiService.delete( // استخدام دالة delete
      endpoint: endpoint,
    );

    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString("app_language") ?? "ar";

    final raw = response.data["msg"];
    final msg = raw is Map ? (raw[lang] ?? raw["ar"] ?? "Success") : raw.toString();

    if (response.data["error"] == false) {
      return Right(msg);
    } else {
      return Left(ServierFailur(msg, 400));
    }
  } on DioException catch (e) {
    return Left(ServierFailur.fromDioError(e));
  } catch (e) {
    return Left(ServierFailur(e.toString(), 500));
  }
}
}