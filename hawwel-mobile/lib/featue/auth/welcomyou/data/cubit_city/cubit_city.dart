// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:usdt/featue/auth/welcomyou/data/cubit_city/cubit_stat_city.dart';
// import 'package:usdt/featue/auth/welcomyou/data/model_city.dart';
// import 'package:usdt/featue/auth/welcomyou/data/repo_city/repo_city.dart';

// class CitiesCubit extends Cubit<CitiesState> {
//   final CitiesRepo repo;
//   String? _currentCountryId;

//   CitiesCubit(this.repo) : super(CitiesInitial());

//   Future<void> fetchCities(String countryId) async {
//     if (_currentCountryId == countryId && state is CitiesSuccess) {
//       return; // نفس الدولة، ما نعيد الطلب
//     }

//     _currentCountryId = countryId;
//     emit(CitiesLoading());

//     final result = await repo.getCitiesByCountry(countryId);

//     result.fold(
//       (fail) => emit(CitiesFailure(fail.errMassage)),
//       (cities) => emit(
//         CitiesSuccess(
//           cities: cities,
//           selected: null,
//         ),
//       ),
//     );
//   }

//   void selectCity(CityModel city) {
//     if (state is CitiesSuccess) {
//       final s = state as CitiesSuccess;
//       emit(CitiesSuccess(cities: s.cities, selected: city));
//     }
//   }

//   void reset() {
//     _currentCountryId = null;
//     emit(CitiesInitial());
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_city/cubit_stat_city.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_city.dart';
import 'package:usdt/featue/auth/welcomyou/data/repo_city/repo_city.dart';

class CitiesCubit extends Cubit<CitiesState> {
  final CitiesRepo repo;
  String? _currentCountryId;

  CitiesCubit(this.repo) : super(CitiesInitial());

  Future<void> fetchCities(String countryId) async {
    if (_currentCountryId == countryId && state is CitiesSuccess) return;

    _currentCountryId = countryId;
    emit(CitiesLoading());

    final result = await repo.getCitiesByCountry(countryId);
    
    // جلب اللغة المخزنة
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString("app_language") ?? "ar";

    result.fold(
      (fail) => emit(CitiesFailure(fail.errMassage)),
      (cities) => emit(CitiesSuccess(
        cities: cities,
        langCode: lang, // تمرير اللغة للحالة
        selected: null,
      )),
    );
  }

  void selectCity(CityModel city) {
    if (state is CitiesSuccess) {
      final s = state as CitiesSuccess;
      emit(CitiesSuccess(cities: s.cities, langCode: s.langCode, selected: city));
    }
  }
   void reset() {
    _currentCountryId = null;
    emit(CitiesInitial());
  }
}