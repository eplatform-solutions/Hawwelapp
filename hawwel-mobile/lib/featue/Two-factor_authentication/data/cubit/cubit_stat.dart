abstract class Change2FAState {}

class Change2FAInitial extends Change2FAState {}

class Change2FALoading extends Change2FAState {}

class Change2FASuccess extends Change2FAState {
  final String message;
  Change2FASuccess(this.message);
}

class Change2FAError extends Change2FAState {
  final String message;
  Change2FAError(this.message);
}
