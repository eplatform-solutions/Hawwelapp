import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_airea/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_airea.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_airea/repo.dart';

class AreasCubit extends Cubit<AreasState> {
  final AreasRepo repo;
  String? _currentCityId;
  int _requestNonce = 0;

  AreasCubit(this.repo) : super(AreasInitial());

  Future<void> fetchAreas(String cityId) async {
    final previousState = state is AreasSuccess ? state as AreasSuccess : null;
    final isSameCity = _currentCityId == cityId;
    if (isSameCity && previousState != null) {
      return;
    }

    final requestId = ++_requestNonce;
    final previousSelected = previousState?.selected;
    _currentCityId = cityId;
    emit(AreasLoading());

    final result = await repo.getAreasByCity(cityId);
    if (requestId != _requestNonce || _currentCityId != cityId) return;

    result.fold(
      (fail) => emit(AreasFailure(fail.errMassage)),
      (areas) {
        AreaModel? keepSelected;
        if (isSameCity && previousSelected != null) {
          for (final area in areas) {
            if (area.id == previousSelected.id) {
              keepSelected = area;
              break;
            }
          }
        }
        emit(AreasSuccess(areas: areas, selected: keepSelected));
      },
    );
  }

  void selectArea(AreaModel area) {
    if (state is AreasSuccess) {
      final s = state as AreasSuccess;
      if (s.selected?.id == area.id) return;
      emit(AreasSuccess(
        areas: s.areas,
        selected: area,
      ));
    }
  }

  void reset() {
    _requestNonce++;
    _currentCityId = null;
    emit(AreasInitial());
  }
}
