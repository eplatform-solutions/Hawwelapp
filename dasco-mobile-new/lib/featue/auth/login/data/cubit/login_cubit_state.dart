// // abstract class LoginState {}

// // class LoginInitial extends LoginState {}

// // class LoginLoading extends LoginState {}

// // class LoginSuccess extends LoginState {
// //   final String message;
// //   LoginSuccess(this.message);
// // }

// // class LoginFailure extends LoginState {
// //   final dynamic error; // Map or string
// //   LoginFailure(this.error);
// // }
// abstract class LoginState {}

// class LoginInitial extends LoginState {}

// class LoginLoading extends LoginState {}

// class LoginSuccess extends LoginState {
//   final dynamic data;
//   LoginSuccess(this.data);
// }

// class LoginFailure extends LoginState {
//   final String errMessage;
//   LoginFailure(this.errMessage);
// }
// ignore: prefer_typing_uninitialized_variables
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final dynamic data; 
  LoginSuccess(this.data);
}

class LoginFailure extends LoginState {
  final String errMessage;
  LoginFailure(this.errMessage);
}

