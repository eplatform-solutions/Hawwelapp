import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/resst_passwrd/repo/repo.dart';

void _safeLog(String message) {
  if (kDebugMode) {
    log(message);
  }
}

class ChangePasswordRepoImpl implements ChangePasswordRepo {
  final ApiService api;

  ChangePasswordRepoImpl({required ApiService apiService}) : api = apiService;

  @override
  Future<Either<Failur, String>> changePassword({
    required String password,
    required String newPassword,
  }) async {
    _safeLog('Change password request started');

    try {
      final response = await api.put(
        endpoint: "/users/change-password",
        data: {"password": password, "newPassword": newPassword},
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      final msg = response.data["msg"] != null
          ? (response.data["msg"][lang] ?? response.data["msg"]["en"])
          : "Success";

      _safeLog('Change password request succeeded');
      return Right(msg);
    } catch (e) {
      _safeLog('Change password request failed');

      if (e is DioException) {
        return Left(ServierFailur.fromDioError(e));
      }

      return Left(ServierFailur(e.toString(), 500));
    }
  }
}
