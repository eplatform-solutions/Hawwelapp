// mark_all_read_state.dart
abstract class MarkAllReadState {}

class MarkAllReadInitial extends MarkAllReadState {}

class MarkAllReadLoading extends MarkAllReadState {}

class MarkAllReadSuccess extends MarkAllReadState {}

class MarkAllReadFailure extends MarkAllReadState {
  final String error;
  MarkAllReadFailure(this.error);
}
