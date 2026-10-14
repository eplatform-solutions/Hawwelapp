abstract class ForgetState {}

class ForgetpasswordInitial extends ForgetState {}

class ForgetpasswordLoading extends ForgetState {}

class ForgetpasswordSuccess extends ForgetState {
  final String massage;

  ForgetpasswordSuccess({required this.massage});
}

class ForgetpasswordFailure extends ForgetState {
  final String error;

  ForgetpasswordFailure(this.error);
}
