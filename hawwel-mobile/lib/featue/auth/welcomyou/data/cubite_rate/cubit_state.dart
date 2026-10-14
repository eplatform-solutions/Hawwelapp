import 'package:usdt/featue/auth/welcomyou/data/model_rate.dart';

abstract class ExchangeRatesState {}

class ExchangeRatesInitial extends ExchangeRatesState {}

class ExchangeRatesLoading extends ExchangeRatesState {}

class ExchangeRatesFailure extends ExchangeRatesState {
  final String error;
  ExchangeRatesFailure(this.error);
}

class ExchangeRatesSuccess extends ExchangeRatesState {
  final ExchangeRateModel data;
  ExchangeRatesSuccess(this.data);
}