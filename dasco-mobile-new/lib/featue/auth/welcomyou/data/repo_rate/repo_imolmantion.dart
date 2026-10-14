import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_rate.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_rate/repo.dart';

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
      debugPrint("🚀 [API Request] Path: /exchange-rates/all");

      final response = await _api.get(endpoint: "/exchange-rates/all");

      // طباعة كل ما يتعلق بالرد الناجح
      debugPrint("✅ [API Response] Success Status Code: ${response.statusCode}");
      debugPrint("📦 [API Data Body]: ${response.data}");

      // محاولة تحويل البيانات إلى Model مع تتبع الأخطاء
      try {
        final model = ExchangeRateModel.fromJson(response.data);
        debugPrint("🎯 [Model Parsing] Success: ExchangeRateModel mapped correctly");
        return Right(model);
      } catch (parseError) {
        debugPrint(
          "❌ [Model Parsing] Error: Failed to parse JSON to ExchangeRateModel",
        );
        debugPrint("Detailed Parsing Error: $parseError");
        return Left(ServierFailur("خطأ في معالجة البيانات: $parseError", 500));
      }
    } catch (e) {
      debugPrint("⚠️ [API Catch] An error occurred in getExchangeRates");

      if (e is DioException) {
        debugPrint("🚫 [Dio Error] Type: ${e.type}");
        debugPrint("🚫 [Dio Error] Status Code: ${e.response?.statusCode}");
        debugPrint("🚫 [Dio Error] Response Data: ${e.response?.data}");

        if (e.response?.statusCode == 401) {
          // طباعة تفاصيل الحظر تحديداً
          String msg =
              e.response?.data['msg']['ar'] ?? "تم حظر حسابك، تواصل مع الدعم";
          debugPrint("🔒 [Account Blocked] Message: $msg");
          return Left(ServierFailur(msg, 401));
        }

        return Left(ServierFailur.fromDioError(e));
      }

      // خطأ غير متوقع (ليس من نوع Dio)
      debugPrint("❗ [Unknown Error]: ${e.toString()}");
      return Left(ServierFailur(e.toString(), 500));
    }
  }
}
