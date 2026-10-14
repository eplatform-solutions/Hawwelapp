import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:usdt/featue/name_saved/name_saved_vew/datat/cubit/cubit_stat.dart';
import 'package:usdt/featue/name_saved/name_saved_vew/datat/repo/repo_implmantion.dart';

class ReceiversCubit extends Cubit<ReceiversState> {
  ReceiversCubit(this.repo) : super(ReceiversInitial());

  final ReceiversRepoImpl repo;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobilePhoneController = TextEditingController();

  Future<void> addReceiver({String? mobilePhone}) async {
    emit(ReceiversLoading());

    final result = await repo.addReceiver(
      fullName: fullNameController.text,
      mobilePhone: mobilePhone ?? mobilePhoneController.text,
    );

    result.fold(
      (failure) => emit(ReceiversFailure(failure.errMassage)),
      (success) => emit(ReceiversSuccess(message: success)),
    );
  }
}
