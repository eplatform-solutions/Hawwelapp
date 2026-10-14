import 'package:hawwel/featue/auth/welcomyou/data/cubit_airea/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_stat_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_conversion_methods/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_country_payment_methods/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_airea.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_city.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart'
    show PaymentMethodModel;

/// The user can reach a valid, submittable payment-method choice through
/// either of two independent paths on the transfer screen:
/// - the full city → region → payment-method flow ([isCountryLevel] = false)
/// - a country-wide payment method picked directly, shown in the same
///   payment-methods box the moment the country has one, before any
///   city/region is chosen ([isCountryLevel] = true, no [city]/[area])
///
/// When both are present (the user completed the detailed flow after also
/// tapping a country-level shortcut), the detailed flow wins — it is the
/// more specific, already-required selection and keeps existing behavior
/// untouched for countries where nothing changed.
class ResolvedPaymentSelection {
  final PaymentMethodModel method;
  final CityModel? city;
  final AreaModel? area;
  final bool isCountryLevel;

  const ResolvedPaymentSelection({
    required this.method,
    required this.isCountryLevel,
    this.city,
    this.area,
  });
}

ResolvedPaymentSelection? resolvePaymentSelection({
  required CitiesState cityState,
  required AreasState areaState,
  required PaymentMethodsState paymentState,
  required CountryPaymentMethodsState countryPaymentState,
}) {
  final hasFullRegionSelection =
      cityState is CitiesSuccess &&
      cityState.selected != null &&
      areaState is AreasSuccess &&
      areaState.selected != null &&
      paymentState is PaymentMethodsSuccess &&
      paymentState.selected != null;

  if (hasFullRegionSelection) {
    return ResolvedPaymentSelection(
      method: paymentState.selected!,
      city: cityState.selected,
      area: areaState.selected,
      isCountryLevel: false,
    );
  }

  if (countryPaymentState is CountryPaymentMethodsSuccess &&
      countryPaymentState.selected != null) {
    return ResolvedPaymentSelection(
      method: countryPaymentState.selected!,
      isCountryLevel: true,
    );
  }

  return null;
}
