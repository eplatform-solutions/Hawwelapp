abstract class RegisterState {}

// REGISTER STATES
class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String msg;
  RegisterSuccess(this.msg);
}

class RegisterError extends RegisterState {
  final String error;
  RegisterError(this.error);
}

// OTP STATES
class RegisterOTPLoading extends RegisterState {}

class RegisterOTPSent extends RegisterState {
  final String msg;
  RegisterOTPSent(this.msg);
}

class RegisterOTPVerified extends RegisterState {
  final String msg;
  final String newSession;

  RegisterOTPVerified({
    required this.msg,
    required this.newSession,
  });
}

class RegisterOTPError extends RegisterState {
  final String error;
  RegisterOTPError(this.error);
}

// // abstract class Regsterstat {}

// // class RegesterInitial extends Regsterstat {}

// // class RegesterLoading extends Regsterstat {}

// // class RegesterSuccess extends Regsterstat {
// //   final String massage;

// //   RegesterSuccess({required this.massage});
// // }

// // class RegesterFailure extends Regsterstat {
// //   final String error;

// //   RegesterFailure(this.error);
// // }
// abstract class RegisterState {}

// class RegisterInitial extends RegisterState {}

// class RegisterLoading extends RegisterState {}
// class RegisterSuccess extends RegisterState {
//   final String message;
//   RegisterSuccess(this.message);
// }
// class RegisterError extends RegisterState {
//   final String error;
//   RegisterError(this.error);
// }

// // OTP
// class RegisterOTPLoading extends RegisterState {}
// class RegisterOTPSuccess extends RegisterState {
//   final String message;
//   RegisterOTPSuccess(this.message);
// }
// class RegisterOTPError extends RegisterState {
//   final String error;
//   RegisterOTPError(this.error);
// }

// abstract class RegisterState  {
//   @override
//   List<Object?> get props => [];
// }

// class RegisterInitial extends RegisterState {}

// class RegisterLoading extends RegisterState {}

// class RegisterSuccess extends RegisterState {
//   final String msg;
//   RegisterSuccess(this.msg);

//   @override
//   List<Object?> get props => [msg];
// }

// class RegisterError extends RegisterState {
//   final String error;
//   RegisterError(this.error);

//   @override
//   List<Object?> get props => [error];
// }

// // OTP STATES
// class RegisterOTPLoading extends RegisterState {}

// class RegisterOTPSuccess extends RegisterState {
//   final String msg;
//   RegisterOTPSuccess(this.msg);

//   @override
//   List<Object?> get props => [msg];
// }

// class RegisterOTPError extends RegisterState {
//   final String error;
//   RegisterOTPError(this.error);

//   @override
//   List<Object?> get props => [error];
// }
