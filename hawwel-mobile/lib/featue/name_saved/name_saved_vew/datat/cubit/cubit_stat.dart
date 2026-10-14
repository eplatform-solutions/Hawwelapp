abstract class ReceiversState {}

class ReceiversInitial extends ReceiversState {}

class ReceiversLoading extends ReceiversState {}

class ReceiversSuccess extends ReceiversState {
  final String message;
  ReceiversSuccess({required this.message});
}

class ReceiversFailure extends ReceiversState {
  final String error;
  ReceiversFailure(this.error);
}
