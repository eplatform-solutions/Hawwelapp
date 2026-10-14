import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_rate.dart';

abstract class ExchangeRatesRepo {
  Future<Either<Failur, ExchangeRateModel>> getExchangeRates();
}