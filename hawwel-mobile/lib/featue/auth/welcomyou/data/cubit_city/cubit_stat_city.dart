// import 'package:usdt/featue/auth/welcomyou/data/model_city.dart';

// abstract class CitiesState {}

// class CitiesInitial extends CitiesState {}

// class CitiesLoading extends CitiesState {}

// class CitiesSuccess extends CitiesState {
//   final List<CityModel> cities;
//   final CityModel? selected;

//   CitiesSuccess({
//     required this.cities,
//     this.selected,
//   });
// }

// class CitiesFailure extends CitiesState {
//   final String error;
//   CitiesFailure(this.error);
// }
import 'package:usdt/featue/auth/welcomyou/data/model_city.dart';

abstract class CitiesState {}

class CitiesInitial extends CitiesState {}

class CitiesLoading extends CitiesState {}

class CitiesSuccess extends CitiesState {
  final List<CityModel> cities;
  final CityModel? selected;
  final String langCode; // <--- أضفنا هذا السطر

  CitiesSuccess({
    required this.cities,
    required this.langCode,
    this.selected,
  });
}

class CitiesFailure extends CitiesState {
  final String error;
  CitiesFailure(this.error);
}