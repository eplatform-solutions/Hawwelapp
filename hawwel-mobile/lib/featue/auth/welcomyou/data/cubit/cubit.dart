import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_country.dart';
import 'package:usdt/featue/auth/welcomyou/data/repo/repo.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final CountriesRepo repo;

  CountriesCubit(this.repo) : super(CountriesInitial());
  void reset() {
    emit(CountriesInitial());
  }

  Future<void> fetchCountries() async {
    if (state is CountriesSuccess) return; // ⛔ ما تعيد الطلب

    emit(CountriesLoading());

    final result = await repo.getCountries();

    result.fold((fail) => emit(CountriesFailure(fail.errMassage)), (data) {
      if (data.isEmpty) {
        emit(CountriesFailure('No countries available'));
        return;
      }
      final defaultCountry = data.firstWhere(
        (c) => c.code.toUpperCase() == 'SY',
        orElse: () => data.first,
      );
      emit(
        CountriesSuccess(
          countries: data,
          selected: defaultCountry,
          isCountrySelected: true,
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
