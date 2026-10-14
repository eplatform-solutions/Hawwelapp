import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/Two-factor_authentication/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/Two-factor_authentication/data/repo/repo.dart';

class Change2FACubit extends Cubit<Change2FAState> {
  Change2FACubit(this.repo) : super(Change2FAInitial());

  final Change2FARepository repo;

  Future<void> change2FA({
    required bool enabled,
    required List<String> methods,
  }) async {
    emit(Change2FALoading());

    var result = await repo.change2FA(enabled: enabled, methods: methods);

    result.fold(
      (failure) => emit(Change2FAError(failure.errMassage)),
      (success) => emit(Change2FASuccess(success.message)),
    );
  }
}
