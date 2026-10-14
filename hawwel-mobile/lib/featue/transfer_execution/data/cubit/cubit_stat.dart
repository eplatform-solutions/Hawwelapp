abstract class DepositExternalState {}

class DepositExternalInitial extends DepositExternalState {}

class DepositExternalLoading extends DepositExternalState {}

class DepositExternalSuccess extends DepositExternalState {
  final dynamic data;
  DepositExternalSuccess(this.data);
}

class DepositExternalFailure extends DepositExternalState {
  final String errMessage;
  DepositExternalFailure(this.errMessage);
}
