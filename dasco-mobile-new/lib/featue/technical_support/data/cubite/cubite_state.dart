import 'package:hawwel/featue/technical_support/data/model.dart';

 
abstract class SupportState {}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportFailure extends SupportState {
  final String error;
  SupportFailure(this.error);
}

class SupportSuccess extends SupportState {
  final TechnicalSupportModel data;
  SupportSuccess(this.data);
}