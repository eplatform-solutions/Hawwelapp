import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/transfer_execution/data/cubit/repo/repo.dart';

void _safeLog(String message) {
  if (kDebugMode) {
    log(message);
  }
}

class DepositExternalRepoImpl extends DepositExternalRepo {
  final ApiService apiService;

  DepositExternalRepoImpl({required this.apiService});

  @override
  Future<Either<Failur, dynamic>> depositExternal({
    required String address,
    required String txId,
    required String chain,
    required String subscriptionType,
    required num amount,
    required String contractAddress,
  }) async {
    _safeLog('External payment request started');

    try {
      final response = await apiService.postdata(
        endpoint: "/deposits/external",
        needtoken: true,
        data: {
          "address": address,
          "txId": txId,
          "chain": chain,
          "subscriptionType": subscriptionType,
          "amount": amount,
          "contractAddress": contractAddress,
        },
      );

      if (response.data["error"] == false) {
        _safeLog('External payment request succeeded');
        return right(response.data);
      }

      _safeLog('External payment request failed');
      final errorMessage =
          response.data["msg"]?["ar"] ??
          "حدث خطأ أثناء إتمام الدفع الخارجي";

      return left(
        ServierFailur(errorMessage, response.statusCode ?? 500),
      );
    } on DioException catch (e) {
      _safeLog('External payment request failed');
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      _safeLog('External payment request failed');
      return left(ServierFailur(e.toString(), 600));
    }
  }
}
