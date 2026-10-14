import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_city.dart';

abstract class CitiesRepo {
  Future<Either<Failur, List<CityModel>>> getCitiesByCountry(
    String countryId,
  );
}