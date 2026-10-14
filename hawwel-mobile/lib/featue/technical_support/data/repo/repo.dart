import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/technical_support/data/model.dart';
 
abstract class SupportRepo {
  Future<Either<Failur, TechnicalSupportModel>> getTechnicalSupport();
}