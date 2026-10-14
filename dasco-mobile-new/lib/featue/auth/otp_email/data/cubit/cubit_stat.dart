abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSentSuccess extends OtpState {
  final String message;
  OtpSentSuccess(this.message);
}

class OtpVerifySuccess extends OtpState {
  final String message;
  OtpVerifySuccess(this.message);
}

class OtpFailure extends OtpState {
  final String error;
  OtpFailure(this.error);
}
