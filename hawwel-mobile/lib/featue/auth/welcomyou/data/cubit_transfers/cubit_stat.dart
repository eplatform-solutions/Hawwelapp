// import 'package:hawwel/featue/auth/welcomyou/data/model_transfer.dart';

// abstract class TransferState {}

// class TransferInitial extends TransferState {}

// class TransferLoading extends TransferState {}

// class TransferSuccess extends TransferState {


 
// }

// class TransferFailure extends TransferState {
//   final String error;
//   TransferFailure(this.error);
// }
import 'package:hawwel/featue/auth/welcomyou/data/model_ressponse_transfer.dart';

abstract class TransferState {}

class TransferInitial extends TransferState {}

class TransferLoading extends TransferState {}

class TransferSuccess extends TransferState {
  final TransferResponseModel transfer;

  TransferSuccess(this.transfer);
}

class TransferFailure extends TransferState {
  final String error;
  final int? statusCode;
  final String? errorCode;

  TransferFailure(
    this.error, {
    this.statusCode,
    this.errorCode,
  });
}
