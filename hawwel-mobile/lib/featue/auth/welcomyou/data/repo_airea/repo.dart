import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_airea.dart';

abstract class AreasRepo {
  Future<Either<Failur, List<AreaModel>>> getAreasByCity(String cityId);
}
