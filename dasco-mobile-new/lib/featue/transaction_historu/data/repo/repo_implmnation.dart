import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart';
import 'package:hawwel/featue/transaction_historu/data/repo/repo.dart';

class TransfersRepoImpl implements TransfersRepo {
  final ApiService _api;

  TransfersRepoImpl({required ApiService api}) : _api = api;

  @override
Future<Either<Failur, List<TransfersByDateModel>>> getTransfers({
  required int pageNumber,
  required int pageSize,
}) async {
  try {
    debugPrint("📤 GET TRANSFERS REQUEST");
    debugPrint("➡️ pageNumber: $pageNumber");
    debugPrint("➡️ pageSize  : $pageSize");

    final response = await _api.get(
      endpoint:
          "/transfers/all-transfers-inside-the-page?pageNumber=$pageNumber&pageSize=$pageSize",
    );

    debugPrint("✅ RESPONSE STATUS: ${response.statusCode}");
    debugPrint("✅ FULL RESPONSE : ${response.data}");

    final list = (response.data['data']['transfers'] as List)
        .map((e) => TransfersByDateModel.fromJson(e))
        .toList();

    return Right(list);
  } catch (e) {
    debugPrint("❌ DIO ERROR WHILE FETCHING TRANSFERS");

    if (e is DioException) {
      debugPrint("Status Code : ${e.response?.statusCode}");
      debugPrint("Message     : ${e.message}");
      debugPrint("Response    : ${e.response?.data}");

      return Left(ServierFailur.fromDioError(e));
    }

    debugPrint("Unknown Error: $e");
    return Left(ServierFailur(e.toString(), 500));
  }
}

}
