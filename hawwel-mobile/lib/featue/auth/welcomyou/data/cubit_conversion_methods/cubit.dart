import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_conversion_methods/cubit_stat.dart';
//import 'package:usdt/featue/auth/welcomyou/data/model_conversion_methods.dart';
import 'package:usdt/featue/auth/welcomyou/data/repo_conversion_methods/repo.dart';
import 'package:usdt/featue/transaction_historu/data/model.dart'
    show PaymentMethodModel;

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final PaymentMethodsRepo repo;

  PaymentMethodsCubit(this.repo) : super(PaymentMethodsInitial());
  void reset() {
    emit(PaymentMethodsInitial());
  }

  Future<void> fetchMethods(String areaId) async {
    emit(PaymentMethodsLoading());

    final result = await repo.getByArea(areaId);

    result.fold(
      (fail) => emit(PaymentMethodsFailure(fail.errMassage)),
      (methods) => emit(
        PaymentMethodsSuccess(
        
          selected: null,
        methods: methods.$1, 
      message: methods.$2,
        ),
      ),
    );
  }

  void selectMethod(PaymentMethodModel method) {
    if (state is PaymentMethodsSuccess) {
      final s = state as PaymentMethodsSuccess;

      emit(PaymentMethodsSuccess(methods: s.methods, selected: method,message: s.message));
    }
  }
}
