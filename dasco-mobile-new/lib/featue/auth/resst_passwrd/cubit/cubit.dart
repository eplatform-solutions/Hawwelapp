import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/auth/resst_passwrd/cubit/cubit_stat.dart';
import 'package:hawwel/featue/auth/resst_passwrd/repo/repo.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepo repo;

  ChangePasswordCubit(this.repo) : super(ChangePasswordInitial());
  final TextEditingController oldpassword = TextEditingController();
  final TextEditingController newpassword = TextEditingController();
  Future<void> changePassword() async {
    emit(ChangePasswordLoading());

    final result = await repo.changePassword(
      password: oldpassword.text.trim(),
      newPassword: newpassword.text.trim(),
    );

    result.fold(
      (fail) => emit(ChangePasswordFailure(fail.errMassage, fail.statusCode)),
      (msg) => emit(ChangePasswordSuccess(msg)),
    );
  }
}
