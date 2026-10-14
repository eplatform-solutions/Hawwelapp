import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/constans/country_defaults_helper.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_country.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo/repo.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final CountriesRepo repo;
  int _requestNonce = 0;

  CountriesCubit(this.repo) : super(CountriesInitial());
  void reset() {
    _requestNonce++;
    emit(CountriesInitial());
  }

  Future<void> fetchCountries({
    bool confirmCountrySelection = true,
  }) async {
    if (state is CountriesLoading) return;

    if (state is CountriesSuccess) {
      final current = state as CountriesSuccess;
      if (confirmCountrySelection &&
          !current.isCountrySelected) {
        emit(
          CountriesSuccess(
            countries: current.countries,
            selected: current.selected,
            isCountrySelected: true,
          ),
        );
      }
      return;
    }

    final requestId = ++_requestNonce;
    emit(CountriesLoading());

    final result = await repo.getCountries();
    if (requestId != _requestNonce) return;

    result.fold((fail) => emit(CountriesFailure(fail.errMassage)), (data) {
      if (requestId != _requestNonce) return;
      if (data.isEmpty) {
        emit(CountriesFailure('No countries available'));
        return;
      }
      final defaultCountry = CountryDefaultsHelper.resolveDefaultCountry(data);
      emit(
        CountriesSuccess(
          countries: data,
          selected: defaultCountry,
          isCountrySelected: confirmCountrySelection,
        ),
      );
    });
  }

  // void selectCountry(CountryModel country) {
  //   if (state is CountriesSuccess) {
  //     final s = state as CountriesSuccess;
  //     emit(
  //       CountriesSuccess(
  //         countries: s.countries,
  //         selected: country,
  //       ),
  //     );

  //   }
  // }
  void selectCountry(CountryModel country) {
    if (state is CountriesSuccess) {
      final s = state as CountriesSuccess;
      final isSameSelection =
          s.selected.id == country.id && s.isCountrySelected;
      if (isSameSelection) return;
      emit(
        CountriesSuccess(
          countries: s.countries,
          selected: country,
          isCountrySelected: true, // ✅ هون صار الاختيار حقيقي
        ),
      );
    }
  }
}
