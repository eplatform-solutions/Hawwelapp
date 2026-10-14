import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_rate.dart';
import 'package:usdt/featue/auth/welcomyou/data/repo_rate/repo.dart';

class ExchangeRatesRepoImpl implements ExchangeRatesRepo {
  final ApiService _api;

  ExchangeRatesRepoImpl({required ApiService api}) : _api = api;

  @override
  // Future<Either<Failur, ExchangeRateModel>> getExchangeRates() async {
  //   try {
  //     print("📤 FETCHING EXCHANGE RATES");
  //     final response = await _api.get(endpoint: "/exchange-rates/all");
  //     print("✅ RESPONSE: ${response.data}");
  //     final model = ExchangeRateModel.fromJson(response.data);
  //     return Right(model);
  //   } catch (e) {
  //     print("❌ ERROR FETCHING RATES: $e");
  //     if (e is DioException) {
  //       return Left(ServierFailur.fromDioError(e));
  //     }
  //     return Left(ServierFailur(e.toString(), 500));
  //   }
  // }
  @override
  Future<Either<Failur, ExchangeRateModel>> getExchangeRates() async {
    try {
      print("🚀 [API Request] Path: /exchange-rates/all");

      final response = await _api.get(endpoint: "/exchange-rates/all");

      // طباعة كل ما يتعلق بالرد الناجح
      print("✅ [API Response] Success Status Code: ${response.statusCode}");
      print("📦 [API Data Body]: ${response.data}");

      // محاولة تحويل البيانات إلى Model مع تتبع الأخطاء
      try {
        final model = ExchangeRateModel.fromJson(response.data);
        print("🎯 [Model Parsing] Success: ExchangeRateModel mapped correctly");
        return Right(model);
      } catch (parseError) {
        print(
          "❌ [Model Parsing] Error: Failed to parse JSON to ExchangeRateModel",
        );
        print("Detailed Parsing Error: $parseError");
        return Left(ServierFailur("خطأ في معالجة البيانات: $parseError", 500));
      }
    } catch (e) {
      print("⚠️ [API Catch] An error occurred in getExchangeRates");

      if (e is DioException) {
        print("🚫 [Dio Error] Type: ${e.type}");
        print("🚫 [Dio Error] Status Code: ${e.response?.statusCode}");
        print("🚫 [Dio Error] Response Data: ${e.response?.data}");

        if (e.response?.statusCode == 401) {
          // طباعة تفاصيل الحظر تحديداً
          String msg =
              e.response?.data['msg']['ar'] ?? "تم حظر حسابك، تواصل مع الدعم";
          print("🔒 [Account Blocked] Message: $msg");
          return Left(ServierFailur(msg, 401));
        }

        return Left(ServierFailur.fromDioError(e));
      }

      // خطأ غير متوقع (ليس من نوع Dio)
      print("❗ [Unknown Error]: ${e.toString()}");
      return Left(ServierFailur(e.toString(), 500));
    }
  }
}
