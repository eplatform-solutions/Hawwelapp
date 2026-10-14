import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_country_payment_methods/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_country_payment_methods/repo.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart'
    show PaymentMethodModel;

/// Mirrors [PaymentMethodsCubit] (area-scoped) but keyed by country instead
/// of area - used to offer a payment method directly under a chosen
/// country, with no city/region selection required at all.
class CountryPaymentMethodsCubit extends Cubit<CountryPaymentMethodsState> {
  final CountryPaymentMethodsRepo repo;
  String? _currentCountryId;
  int _requestNonce = 0;

  CountryPaymentMethodsCubit(this.repo)
    : super(CountryPaymentMethodsInitial());

  void reset() {
    _requestNonce++;
    _currentCountryId = null;
    emit(CountryPaymentMethodsInitial());
  }

  Future<void> fetchMethods(String countryId) async {
    final previousState = state is CountryPaymentMethodsSuccess
        ? state as CountryPaymentMethodsSuccess
        : null;
    final isSameCountry = _currentCountryId == countryId;
    if (isSameCountry && previousState != null) {
      return;
    }

    final requestId = ++_requestNonce;
    _currentCountryId = countryId;
    emit(CountryPaymentMethodsLoading());

    final result = await repo.getByCountry(countryId);
    if (requestId != _requestNonce || _currentCountryId != countryId) return;

    result.fold(
      (fail) => emit(CountryPaymentMethodsFailure(fail.errMassage)),
      (methods) {
        emit(
          CountryPaymentMethodsSuccess(
            selected: null,
            methods: methods.$1,
            message: methods.$2,
          ),
        );
      },
    );
  }

  void selectMethod(PaymentMethodModel method) {
    if (state is CountryPaymentMethodsSuccess) {
      final s = state as CountryPaymentMethodsSuccess;
      if (s.selected?.id == method.id) return;

      emit(
        CountryPaymentMethodsSuccess(
          methods: s.methods,
          selected: method,
          message: s.message,
        ),
      );
    }
  }

  /// Clears just the selection (keeps the fetched list) - used when the
  /// user instead picks a method from the city/region flow, so only one
  /// of the two paths is ever considered "selected" at a time.
  void clearSelection() {
    if (state is CountryPaymentMethodsSuccess) {
      final s = state as CountryPaymentMethodsSuccess;
      if (s.selected == null) return;
      emit(
        CountryPaymentMethodsSuccess(
          methods: s.methods,
          selected: null,
          message: s.message,
        ),
      );
    }
  }
}
