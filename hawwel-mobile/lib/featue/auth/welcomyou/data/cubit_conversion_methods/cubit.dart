import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_conversion_methods/cubit_stat.dart';
//import 'package:hawwel/featue/auth/welcomyou/data/model_conversion_methods.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_conversion_methods/repo.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart'
    show PaymentMethodModel;

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final PaymentMethodsRepo repo;
  String? _currentAreaId;
  int _requestNonce = 0;

  PaymentMethodsCubit(this.repo) : super(PaymentMethodsInitial());
  void reset() {
    _requestNonce++;
    _currentAreaId = null;
    emit(PaymentMethodsInitial());
  }

  Future<void> fetchMethods(String areaId) async {
    final previousState =
        state is PaymentMethodsSuccess ? state as PaymentMethodsSuccess : null;
    final isSameArea = _currentAreaId == areaId;
    if (isSameArea && previousState != null) {
      return;
    }

    final requestId = ++_requestNonce;
    _currentAreaId = areaId;
    if (previousState == null) {
      emit(PaymentMethodsLoading());
    } else {
      // Keep previous cards visible while fetching new area methods.
      emit(
        PaymentMethodsSuccess(
          methods: previousState.methods,
          selected: null,
          message: previousState.message,
        ),
      );
    }

    final result = await repo.getByArea(areaId);
    if (requestId != _requestNonce || _currentAreaId != areaId) return;

    result.fold(
      (fail) => emit(PaymentMethodsFailure(fail.errMassage)),
      (methods) {
        emit(
          PaymentMethodsSuccess(
            selected: null,
            methods: methods.$1,
            message: methods.$2,
          ),
        );
      },
    );
  }

  void selectMethod(PaymentMethodModel method) {
    if (state is PaymentMethodsSuccess) {
      final s = state as PaymentMethodsSuccess;
      if (s.selected?.id == method.id) return;

      emit(
        PaymentMethodsSuccess(
          methods: s.methods,
          selected: method,
          message: s.message,
        ),
      );
    }
  }

  /// Clears just the selection (keeps the fetched list) - used when the
  /// user instead picks a country-level method, so only one of the two
  /// paths is ever considered "selected" at a time.
  void clearSelection() {
    if (state is PaymentMethodsSuccess) {
      final s = state as PaymentMethodsSuccess;
      if (s.selected == null) return;
      emit(
        PaymentMethodsSuccess(
          methods: s.methods,
          selected: null,
          message: s.message,
        ),
      );
    }
  }
}
