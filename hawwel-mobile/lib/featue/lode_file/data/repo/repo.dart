import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
 
abstract class KycRepo {
  Future<Either<Failur, String>> uploadKyc(String firstFilePath, String secondFilePath);
}
