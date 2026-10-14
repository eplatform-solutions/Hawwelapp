import 'package:hawwel/featue/transaction_historu/data/model.dart';

abstract class PaymentMethodsState {}

class PaymentMethodsInitial extends PaymentMethodsState {}

class PaymentMethodsLoading extends PaymentMethodsState {}

class PaymentMethodsFailure extends PaymentMethodsState {
  final String error;
  PaymentMethodsFailure(this.error);
}

class PaymentMethodsSuccess extends PaymentMethodsState {
  final List<PaymentMethodModel> methods;
  final PaymentMethodModel? selected;
  final String message;

  PaymentMethodsSuccess({required this.methods, this.selected,this.message=""});
}
// import 'package:hawwel/featue/transaction_historu/data/model.dart';

// abstract class PaymentMethodsState {}

// class PaymentMethodsInitial extends PaymentMethodsState {}
// class PaymentMethodsLoading extends PaymentMethodsState {}

// class PaymentMethodsSuccess extends PaymentMethodsState {
//   final List<PaymentMethodModel> methods;
//   final PaymentMethodModel? selected;

//   PaymentMethodsSuccess({required this.methods, this.selected});
// }

// class PaymentMethodsFailure extends PaymentMethodsState {
//   final String errMessage;
//   PaymentMethodsFailure(this.errMessage);
// }
