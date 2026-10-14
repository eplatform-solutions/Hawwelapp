import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_airea.dart';

abstract class AreasRepo {
  Future<Either<Failur, List<AreaModel>>> getAreasByCity(String cityId);
}
