import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_rate.dart';

abstract class ExchangeRatesRepo {
  Future<Either<Failur, ExchangeRateModel>> getExchangeRates();
}