import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_country.dart';
 
abstract class CountriesRepo {
  Future<Either<Failur, List<CountryModel>>> getCountries();
}
