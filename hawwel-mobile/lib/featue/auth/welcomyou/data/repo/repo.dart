import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_country.dart';
 
abstract class CountriesRepo {
  Future<Either<Failur, List<CountryModel>>> getCountries();
}
