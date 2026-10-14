import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/transfer_execution/data/cubit/repo/repo.dart';
 
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
    try {
      log("🚀 POST /deposits/external");

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

      log("✅ RESPONSE: ${response.data}");

      if (response.data["error"] == false) {
        return right(response.data);
      }

      final errorMessage =
          response.data["msg"]?["ar"] ?? "حدث خطأ أثناء تنفيذ الإيداع";

      return left(
        ServierFailur(errorMessage, response.statusCode ?? 500),
      );
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 600));
    }
  }
}
