import 'package:hawwel/featue/auth/welcomyou/data/model_airea.dart';

abstract class AreasState {}

class AreasInitial extends AreasState {}

class AreasLoading extends AreasState {}

class AreasSuccess extends AreasState {
  final List<AreaModel> areas;
  final AreaModel? selected;

  AreasSuccess({
    required this.areas,
    this.selected,
  });
}

class AreasFailure extends AreasState {
  final String error;
  AreasFailure(this.error);
}
