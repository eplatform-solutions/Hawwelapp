import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/conferm_password/data/repo/conferm_repo.dart';

void _safeLog(String message) {
  if (kDebugMode) {
    log(message);
  }
}

class ImplmentConfirmRepo extends ConfirmRepo {
  final ApiService _apiService;

  ImplmentConfirmRepo({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, String>> confirmPassword({
    required String password,
    required String otp,
    required String session,
  }) async {
    _safeLog('Reset password confirmation started');

    try {
      final response = await _apiService.put(
        endpoint: "/auth/reset-password",
        data: {"session": session, "code": otp, "password": password},
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      // The backend answers 200 for business failures too (wrong/expired
      // code) and flags them with error:true - there is no "success" key.
      if (response.data is Map && response.data["error"] == false) {
        final message = response.data["msg"]?[lang] ?? "Password updated";
        _safeLog('Reset password confirmation succeeded');
        return right(message);
      }

      final errorMessage = response.data["msg"]?[lang] ?? "Unknown error";
      _safeLog('Reset password confirmation failed');
      return left(ServierFailur(errorMessage, response.statusCode ?? 400));
    } on DioException catch (e) {
      _safeLog('Reset password confirmation failed');
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      _safeLog('Reset password confirmation failed');
      return left(ServierFailur(e.toString(), 600));
    }
  }
}
