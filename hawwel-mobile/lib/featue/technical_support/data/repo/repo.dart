import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/technical_support/data/model.dart';
 
abstract class SupportRepo {
  Future<Either<Failur, TechnicalSupportModel>> getTechnicalSupport();
}