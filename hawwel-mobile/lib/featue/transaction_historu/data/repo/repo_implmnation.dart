import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/transaction_historu/data/model.dart';
import 'package:usdt/featue/transaction_historu/data/repo/repo.dart';

class TransfersRepoImpl implements TransfersRepo {
  final ApiService _api;

  TransfersRepoImpl({required ApiService api}) : _api = api;

  @override
Future<Either<Failur, List<TransfersByDateModel>>> getTransfers({
  required int pageNumber,
  required int pageSize,
}) async {
  try {
    print("📤 GET TRANSFERS REQUEST");
    print("➡️ pageNumber: $pageNumber");
    print("➡️ pageSize  : $pageSize");

    final response = await _api.get(
      endpoint:
          "/transfers/all-transfers-inside-the-page?pageNumber=$pageNumber&pageSize=$pageSize",
    );

    print("✅ RESPONSE STATUS: ${response.statusCode}");
    print("✅ FULL RESPONSE : ${response.data}");

    final list = (response.data['data']['transfers'] as List)
        .map((e) => TransfersByDateModel.fromJson(e))
        .toList();

    return Right(list);
  } catch (e) {
    print("❌ DIO ERROR WHILE FETCHING TRANSFERS");

    if (e is DioException) {
      print("Status Code : ${e.response?.statusCode}");
      print("Message     : ${e.message}");
      print("Response    : ${e.response?.data}");

      return Left(ServierFailur.fromDioError(e));
    }

    print("Unknown Error: $e");
    return Left(ServierFailur(e.toString(), 500));
  }
}

}
