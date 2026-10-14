import 'package:usdt/featue/sender_information/data/model.dart';

abstract class ReceiversDisplayState {}

class ReceiversDisplayInitial extends ReceiversDisplayState {}

class ReceiversDisplayLoading extends ReceiversDisplayState {}

class ReceiversDisplaySuccess extends ReceiversDisplayState {
  final List<ReceiversDisplayModel> receivers;
  final String message;

  ReceiversDisplaySuccess({
    required this.receivers,
    required this.message,
  });
}

class ReceiversDisplayFailure extends ReceiversDisplayState {
  final String error;
  ReceiversDisplayFailure(this.error);
}
