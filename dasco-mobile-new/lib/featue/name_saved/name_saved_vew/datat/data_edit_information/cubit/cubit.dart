import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/data_edit_information/cubit/cubit_state.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/data_edit_information/cubit/repo/repo.dart';

class UpdateReceiverCubit extends Cubit<UpdateReceiverState> {
  final UpdateReceiverRepo repo;
  UpdateReceiverCubit(this.repo) : super(UpdateReceiverInitial());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<void> updateReceiverData(
    String receiverId, {
    String? mobilePhone,
  }) async {
    final phone = mobilePhone ?? phoneController.text;
    if (nameController.text.isEmpty || phone.isEmpty) {
      emit(UpdateReceiverFailure("يرجى ملء جميع الحقول"));
      return;
    }

    emit(UpdateReceiverLoading());

    final result = await repo.updateReceiver(
      receiverId: receiverId,
      fullName: nameController.text,
      mobilePhone: phone,
    );

    result.fold(
      (failure) => emit(UpdateReceiverFailure(failure.errMassage)),
      (successMsg) => emit(UpdateReceiverSuccess(successMsg)),
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    return super.close();
  }

  Future<void> deleteReceiverData(String receiverId) async {
    emit(UpdateReceiverLoading());

    final result = await repo.deleteReceiver(receiverId);

    result.fold(
      (failure) => emit(UpdateReceiverFailure(failure.errMassage)),
      (successMsg) => emit(UpdateReceiverSuccess(successMsg)),
    );
  }
}
