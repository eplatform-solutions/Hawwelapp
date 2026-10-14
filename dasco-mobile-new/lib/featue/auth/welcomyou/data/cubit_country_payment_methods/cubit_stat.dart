import 'package:hawwel/featue/transaction_historu/data/model.dart';

abstract class CountryPaymentMethodsState {}

class CountryPaymentMethodsInitial extends CountryPaymentMethodsState {}

class CountryPaymentMethodsLoading extends CountryPaymentMethodsState {}

class CountryPaymentMethodsFailure extends CountryPaymentMethodsState {
  final String error;
  CountryPaymentMethodsFailure(this.error);
}

class CountryPaymentMethodsSuccess extends CountryPaymentMethodsState {
  final List<PaymentMethodModel> methods;
  final PaymentMethodModel? selected;
  final String message;

  CountryPaymentMethodsSuccess({
    required this.methods,
    this.selected,
    this.message = "",
  });
}
