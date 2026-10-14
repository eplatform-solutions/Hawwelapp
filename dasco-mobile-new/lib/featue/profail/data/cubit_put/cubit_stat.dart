// update_info_state.dart

sealed class UpdateInfoState {}

final class UpdateInfoInitial extends UpdateInfoState {}

final class UpdateInfoLoading extends UpdateInfoState {}

final class UpdateInfoSuccess extends UpdateInfoState {
  final String message;
  UpdateInfoSuccess(this.message);
}

final class UpdateInfoFailure extends UpdateInfoState {
  final String error;
  final int statusCode;

  UpdateInfoFailure({
    required this.error,
    required this.statusCode,
  });
}
class RegisterchangOTPLoading extends UpdateInfoState {}

class RegisterchangOTPSent extends UpdateInfoState {
  final String msg;
  RegisterchangOTPSent(this.msg);
}

class RegisterchangOTPVerified extends UpdateInfoState {
  final String msg;
  final String newSession;

  RegisterchangOTPVerified({
    required this.msg,
    required this.newSession,
  });
}

class RegisterchangOTPError extends UpdateInfoState {
  final String error;
  // final int? retryAfterSeconds;
  RegisterchangOTPError(this.error);
}