import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubite_rate/cubit_state.dart';
import 'package:usdt/featue/auth/welcomyou/data/repo_rate/repo.dart';

class ExchangeRatesCubit extends Cubit<ExchangeRatesState> {
  final ExchangeRatesRepo repo;

  ExchangeRatesCubit(this.repo) : super(ExchangeRatesInitial());

  Future<void> fetchRates() async {
    emit(ExchangeRatesLoading());

    final result = await repo.getExchangeRates();

    result.fold(
      (failure) => emit(ExchangeRatesFailure(failure.errMassage)),
      (data) => emit(ExchangeRatesSuccess(data)),
    );
  }
//   Future<void> fetchRates() async {
//   // لا نضع Loading هنا في كل مرة لأن التايمر شغال بالخلفية عشان ما يقطع تجربة المستخدم
//   final result = await repo.getExchangeRates();

//   result.fold(
//     (failure) {
//       if (failure is ServierFailur && failure.statusCode == 401) {
//         emit(ExchangeRatesUserBlocked(failure.errMassage));
//       } else {
//         emit(ExchangeRatesFailure(failure.errMassage));
//       }
//     },
//     (data) => emit(ExchangeRatesSuccess(data)),
//   );
// }
}