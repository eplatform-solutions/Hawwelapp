import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_airea/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_airea.dart';
import 'package:usdt/featue/auth/welcomyou/data/repo_airea/repo.dart';

class AreasCubit extends Cubit<AreasState> {
  final AreasRepo repo;

  AreasCubit(this.repo) : super(AreasInitial());

  Future<void> fetchAreas(String cityId) async {
    emit(AreasLoading());

    final result = await repo.getAreasByCity(cityId);

    result.fold(
      (fail) => emit(AreasFailure(fail.errMassage)),
      (areas) => emit(AreasSuccess(areas: areas)),
    );
  }

  void selectArea(AreaModel area) {
    if (state is AreasSuccess) {
      final s = state as AreasSuccess;
      emit(AreasSuccess(
        areas: s.areas,
        selected: area,
      ));
    }
  }

  void reset() {
    emit(AreasInitial());
  }
}
