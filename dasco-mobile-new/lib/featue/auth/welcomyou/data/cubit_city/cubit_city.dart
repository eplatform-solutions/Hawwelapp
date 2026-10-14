import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_stat_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_city/repo_city.dart';

class CitiesCubit extends Cubit<CitiesState> {
  final CitiesRepo repo;
  String? _currentCountryId;
  int _requestNonce = 0;

  CitiesCubit(this.repo) : super(CitiesInitial());

  Future<void> fetchCities(String countryId) async {
    final previousState = state is CitiesSuccess ? state as CitiesSuccess : null;
    final isSameCountry = _currentCountryId == countryId;
    if (isSameCountry && previousState != null) {
      return;
    }

    final requestId = ++_requestNonce;
    final previousSelected = previousState?.selected;
    _currentCountryId = countryId;
    emit(CitiesLoading());

    final result = await repo.getCitiesByCountry(countryId);
    if (requestId != _requestNonce || _currentCountryId != countryId) return;

    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('app_language') ?? 'ar';

    result.fold(
      (fail) => emit(CitiesFailure(fail.errMassage)),
      (cities) {
        CityModel? keepSelected;
        if (isSameCountry && previousSelected != null) {
          for (final city in cities) {
            if (city.id == previousSelected.id) {
              keepSelected = city;
              break;
            }
          }
        }
        emit(
          CitiesSuccess(
            cities: cities,
            langCode: lang,
            selected: keepSelected,
          ),
        );
      },
    );
  }

  void selectCity(CityModel city) {
    if (state is CitiesSuccess) {
      final s = state as CitiesSuccess;
      if (s.selected?.id == city.id) return;
      emit(
        CitiesSuccess(
          cities: s.cities,
          langCode: s.langCode,
          selected: city,
        ),
      );
    }
  }

  void reset() {
    _requestNonce++;
    _currentCountryId = null;
    emit(CitiesInitial());
  }
}
