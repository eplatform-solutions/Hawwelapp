// import 'package:hawwel/featue/transaction_historu/data/model.dart';

// sealed class TransfersState {}

// class TransfersInitial extends TransfersState {}

// class TransfersLoading extends TransfersState {}

// class TransfersSuccess extends TransfersState {
//   final List<TransfersByDateModel> data;
//   final bool hasMore;

//   TransfersSuccess({
//     required this.data,
//     required this.hasMore,
//   });
// }

// class TransfersFailure extends TransfersState {
//   final String error;

//   TransfersFailure(this.error);
// }
import 'package:hawwel/featue/transaction_historu/data/model.dart';

abstract class TransfersState {}

class TransfersInitial extends TransfersState {}

class TransfersLoading extends TransfersState {}

class TransfersFailure extends TransfersState {
  final String error;
  final int? statusCode;
  TransfersFailure(this.error, {this.statusCode});
}

class TransfersSuccess extends TransfersState {
  final List<TransfersByDateModel> data;
  final bool hasMore;
  

  TransfersSuccess({required this.data, required this.hasMore});
}
