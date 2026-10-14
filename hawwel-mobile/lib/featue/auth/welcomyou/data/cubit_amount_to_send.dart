import 'package:flutter_bloc/flutter_bloc.dart';

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
          currency: CurrencyType.usdt, // 🔥 default
          amount: '',
        ),
      );
      void setCurrency(CurrencyType type) => emit(state.copyWith(currency: type));
  void reset() {
    emit(
      CurrencyState(
        currency: CurrencyType.usdt, // الافتراضي
        amount: '',
      ),
    );
  }

  void toggleCurrency() {
    emit(
      state.copyWith(
        currency: state.currency == CurrencyType.usdt
            ? CurrencyType.usdc
            : CurrencyType.usdt,
      ),
    );
  }

  void changeAmount(String value) {
    emit(state.copyWith(amount: value));
  }
}
