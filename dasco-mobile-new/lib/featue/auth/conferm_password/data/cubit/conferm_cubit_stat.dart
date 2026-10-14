abstract class ConfermState {}

class ConfermInitial extends ConfermState {}

class ConfermLoading extends ConfermState {}

class ConfermSuccess extends ConfermState {
  final String massage;
  ConfermSuccess({required this.massage});
}

class ConfermFailure extends ConfermState {
  final String error;
  ConfermFailure(this.error);
}
