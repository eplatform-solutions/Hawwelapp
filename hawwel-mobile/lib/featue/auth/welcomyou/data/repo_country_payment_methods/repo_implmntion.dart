import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_country_payment_methods/repo.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart';

/// Country-scoped payment methods (e.g. Vodafone Cash across all of Egypt).
/// Mirrors [PaymentMethodsRepoImpl] (area-scoped), only the endpoint differs.
class CountryPaymentMethodsRepoImpl implements CountryPaymentMethodsRepo {
  final ApiService _apiService;

  CountryPaymentMethodsRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, (List<PaymentMethodModel>, String)>> getByCountry(
    String countryId,
  ) async {
    log('--- 🛰️ [START COUNTRY PAYMENT METHODS REQUEST] ---');
    log('📍 Country ID: $countryId');

    try {
      final res = await _apiService.get(
        endpoint: '/payment-methods/country/$countryId',
        needtoken: false,
      );

      log('📥 [RESPONSE RECEIVED]');
      log('📊 Status Code: ${res.statusCode}');
      log('📦 Full Body: ${res.data}');

      // 1. جلب اللغة المحفوظة في التطبيق
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

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

      // 3. التحقق من الخطأ المنطقي (Error: true) — يعني ما في وسائل دفع على
      //    مستوى الدولة، فبنرجع لستة فاضية بدل ما نعتبرها خطأ حقيقي
      //    (الصندوق نفسه بيرجع فاضي، ويبقى ينتظر اختيار مدينة/منطقة).
      final bool isError = res.data['error'] ?? false;
      if (isError) {
        log(
          '⚠️ [REPO] Logic Error Detected (error: true). Returning empty list.',
        );
        return Right(([], messageFromServer));
      }

      // 4. معالجة البيانات — لو data كانت {} (مش List) بنعتبرها فاضية.
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

      log('✅ [SUCCESS] Found ${methods.length} country-level methods.');
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
