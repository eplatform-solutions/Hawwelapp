import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hawwel/constans/send_currency_helper.dart';

export 'package:hawwel/constans/send_currency_helper.dart' show SendCurrencyHelper;

enum CurrencyType { usdt, usdc }

class CurrencyState {
  final CurrencyType currency;
  final String amount;

  CurrencyState({required this.currency, required this.amount});

  CurrencyState copyWith({CurrencyType? currency, String? amount}) {
    return CurrencyState(
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
    );
  }
}

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit()
    : super(
        CurrencyState(
          // USDC, not USDT: Tether never applied for MiCA authorisation, so
          // since 1 July 2026 no licensed venue in the EEA may offer it and no
          // licensed partner can settle it. The server has the final say via
          // allowedSendCurrencies - this is only the starting selection.
          currency: SendCurrencyHelper.defaultCurrency,
          amount: '',
        ),
      ) {
    // The server config arrives after launch, so a selection made before it
    // lands has to be re-checked once it does.
    SendCurrencyHelper.allowedCurrenciesRevision.addListener(
      reconcileWithAllowed,
    );
  }
      void setCurrency(CurrencyType type) => emit(state.copyWith(currency: type));
  void reset() {
    emit(
      CurrencyState(
        currency: SendCurrencyHelper.defaultCurrency,
        amount: '',
      ),
    );
  }

  /// Moves to the next currency the server still allows. With only one allowed
  /// this is a no-op, so a withdrawn stablecoin cannot be reached by tapping
  /// the toggle on an older screen.
  void toggleCurrency() {
    final allowed = SendCurrencyHelper.allowedCurrencies;
    if (allowed.length < 2) {
      if (allowed.isNotEmpty && state.currency != allowed.first) {
        emit(state.copyWith(currency: allowed.first));
      }
      return;
    }
    final next = allowed[(allowed.indexOf(state.currency) + 1) % allowed.length];
    emit(state.copyWith(currency: next));
  }

  /// Pulls the selection back onto an allowed currency after the server config
  /// arrives - a session that started on a now-withdrawn coin must not be able
  /// to submit it.
  void reconcileWithAllowed() {
    final allowed = SendCurrencyHelper.allowedCurrencies;
    if (allowed.isNotEmpty && !allowed.contains(state.currency)) {
      emit(state.copyWith(currency: allowed.first));
    }
  }

  String apiSymbol() => SendCurrencyHelper.apiSymbolFor(state.currency);

  String displayLabel({required bool isArabic}) =>
      SendCurrencyHelper.displayLabelForType(state.currency, isArabic: isArabic);

  void changeAmount(String value) {
    emit(state.copyWith(amount: value));
  }

  @override
  Future<void> close() {
    SendCurrencyHelper.allowedCurrenciesRevision.removeListener(
      reconcileWithAllowed,
    );
    return super.close();
  }
}
