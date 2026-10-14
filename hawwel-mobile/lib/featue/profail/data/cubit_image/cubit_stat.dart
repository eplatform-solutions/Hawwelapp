sealed class ChangeImageState {}

final class ChangeImageInitial extends ChangeImageState {}

final class ChangeImageLoading extends ChangeImageState {}

final class ChangeImageSuccess extends ChangeImageState {
  final String imagePath;
  ChangeImageSuccess(this.imagePath);
}

final class ChangeImageFailure extends ChangeImageState {
  final String error;
  ChangeImageFailure(this.error);
}
