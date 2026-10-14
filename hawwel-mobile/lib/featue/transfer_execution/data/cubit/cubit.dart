import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/transfer_execution/data/cubit/cubit_stat.dart';
  import 'package:usdt/featue/transfer_execution/data/cubit/repo/repo.dart';

class DepositExternalCubit extends Cubit<DepositExternalState> {
  DepositExternalCubit(this.repo) : super(DepositExternalInitial());

  final DepositExternalRepo repo;

  Future<void> sendExternalDeposit({
    required String address,
    required String txId,
    required String chain,
    required String subscriptionType,
    required num amount,
    required String contractAddress,
  }) async {
    emit(DepositExternalLoading());

    final result = await repo.depositExternal(
      address: address,
      txId: txId,
      chain: chain,
      subscriptionType: subscriptionType,
      amount: amount,
      contractAddress: contractAddress,
    );

    result.fold(
      (failure) => emit(DepositExternalFailure(failure.errMassage)),
      (success) => emit(DepositExternalSuccess(success)),
    );
  }
}
