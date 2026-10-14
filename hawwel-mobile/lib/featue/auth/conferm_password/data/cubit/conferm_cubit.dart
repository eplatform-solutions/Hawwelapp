import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/auth/conferm_password/data/cubit/conferm_cubit_stat.dart';
import 'package:usdt/featue/auth/conferm_password/data/repo/conferm_repo_implmantion.dart';

  

class ConfermCubit extends Cubit<ConfermState> {
  ConfermCubit(this.repo) : super(ConfermInitial());

  final ImplmentConfirmRepo repo;

  final TextEditingController password = TextEditingController();

  Future<void> confermCubit({
    required String confermpassword,
    required String otp,
    required String session,
  }) async {
    emit(ConfermLoading());

    final result = await repo.confirmPassword(
      password:confermpassword,
      otp: otp,
      session: session,
    );

    result.fold(
      (fail) => emit(ConfermFailure(fail.errMassage)),
      (success) => emit(ConfermSuccess(massage: success)),
    );
  }
}

