import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/technical_support/data/model.dart';
import 'package:hawwel/featue/technical_support/data/repo/repo.dart';
 
class SupportRepoImpl implements SupportRepo {
  final ApiService _api;

  SupportRepoImpl({required ApiService api}) : _api = api;

  @override
  Future<Either<Failur, TechnicalSupportModel>> getTechnicalSupport() async {
    try {
      final response = await _api.get(
        endpoint: "/technical-support/page-content",  
      );

      final result = TechnicalSupportModel.fromJson(response.data);
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServierFailur.fromDioError(e));
      }
      return Left(ServierFailur(e.toString(), 500));
    }
  }
}