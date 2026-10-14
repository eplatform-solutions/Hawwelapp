import 'package:hawwel/featue/profail/data/modal.dart';

sealed class UserinfoState {}

final class UserinfoInitialState extends UserinfoState {}

final class UserinfoLoadingState extends UserinfoState {}

final class UserinfoSuccessState extends UserinfoState {
  final StudentInfo user;
  UserinfoSuccessState({required this.user});
}

final class UserinfoFailureState extends UserinfoState {
  final String error;
  final int statusCode;

  UserinfoFailureState({
    required this.error,
    required this.statusCode,
  });
}
