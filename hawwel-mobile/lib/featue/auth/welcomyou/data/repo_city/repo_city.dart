import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_city.dart';

abstract class CitiesRepo {
  Future<Either<Failur, List<CityModel>>> getCitiesByCountry(
    String countryId,
  );
}