import 'package:hawwel/featue/auth/welcomyou/data/model_country.dart';

abstract class CountriesState {}

class CountriesInitial extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesFailure extends CountriesState {
  final String error;
  CountriesFailure(this.error);
}

class CountriesSuccess extends CountriesState {
  final List<CountryModel> countries;
  final CountryModel selected;
  final bool isCountrySelected;
  

  CountriesSuccess({required this.countries, required this.selected,this.isCountrySelected = false,});
}
