import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
 
abstract class KycRepo {
  Future<Either<Failur, String>> uploadKyc(String filePath);
}
