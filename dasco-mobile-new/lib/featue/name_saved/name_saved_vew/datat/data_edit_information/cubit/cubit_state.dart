sealed class UpdateReceiverState {}

final class UpdateReceiverInitial extends UpdateReceiverState {}
final class UpdateReceiverLoading extends UpdateReceiverState {}

final class UpdateReceiverSuccess extends UpdateReceiverState {
  final String message;
  UpdateReceiverSuccess(this.message);
}

final class UpdateReceiverFailure extends UpdateReceiverState {
  final String error;
  UpdateReceiverFailure(this.error);
}