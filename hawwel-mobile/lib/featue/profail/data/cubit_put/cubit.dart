// update_info_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/profail/data/cubit_put/cubit_stat.dart';
import 'package:usdt/featue/profail/data/repo_put/repo.dart';

class UpdateInfoCubit extends Cubit<UpdateInfoState> {
  final UpdateInfoRepo repo;

  UpdateInfoCubit(this.repo) : super(UpdateInfoInitial());

  // Text controllers (إذا حابب تربطها بالشاشة)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailOtpController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController phoneOtpController = TextEditingController();
  // final TextEditingController  = TextEditingController();

  String? sessionForEmail;
  String? sessionForphone;
  String? submittedPhone;

  Future<void> sendOtpchange() async {
    emit(RegisterchangOTPLoading());

    var result = await repo.sendotpchang(email: emailController.text);

    result.fold(
      (fail) {
        //   int? seconds;
        // if (fail.data != null) {
        //   seconds = fail.data['retryAfterSeconds'];
        // }
        emit(RegisterchangOTPError(fail.errMassage));
      },
      (success) {
        sessionForEmail = success["session"];
        emit(RegisterchangOTPSent(success["msg"]));
      },
    );
  }

  Future<void> sendOtpchangephone() async {
    emit(RegisterchangOTPLoading());

    var result = await repo.sendotpchangphone(
      phonenumber: submittedPhone ?? phoneController.text,
    );

    result.fold((fail) => emit(RegisterchangOTPError(fail.errMassage)), (
      success,
    ) {
      sessionForphone = success["session"];
      emit(RegisterchangOTPSent(success["msg"]));
    });
  }

  //0988960034
  Future<void> updateUserInfo({String? mobilePhone}) async {
    emit(UpdateInfoLoading());

    final result = await repo.updateUserInfo(
      email: emailController.text,
      mobilePhone: mobilePhone ?? submittedPhone ?? phoneController.text,
      emailCode: emailOtpController.text,
      emailSession: sessionForEmail ?? "",
      phoneCode: phoneOtpController.text,
      phoneSession: sessionForphone ?? "",
    );

    result.fold(
      (l) => emit(
        UpdateInfoFailure(error: l.errMassage, statusCode: l.statusCode),
      ),
      (r) => emit(UpdateInfoSuccess(r)),
    );
  }
}
