import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/auth/forgeat_password/data/cubit/cubit_forget_stat.dart';
import 'package:hawwel/featue/auth/forgeat_password/data/repo/forget_repo_implmantion.dart';

class ForgetCubit extends Cubit<ForgetState> {
  ForgetCubit(this.implmentRepoforgetpassword) : super(ForgetpasswordInitial());

  final TextEditingController email = TextEditingController();
  final ImplmentRepoforgetpassword implmentRepoforgetpassword;

  // نخزّن الـ session هنا
  String? forgetSession;
  String? submittedIdentifier;
  String? codee;

  Future<void> forgetpasswrdCubit({String? loginValue}) async {
    emit(ForgetpasswordLoading());
    final value = loginValue ?? email.text;
    submittedIdentifier = value;
    var result = await implmentRepoforgetpassword.forgetpassword(
      email: value,
    );

    result.fold((failur) => emit(ForgetpasswordFailure(failur.errMassage)), (
      successful,
    ) {
      // successful هنا خريطة {msg, session}
      forgetSession = successful["session"];
      emit(ForgetpasswordSuccess(massage: successful["msg"] ?? "تم الإرسال"));
    });
  }

 
}

// class ForgetCubit extends Cubit<ForgetState> {
//   ForgetCubit(this.implmentRepoforgetpassword) : super(ForgetpasswordInitial());
//   final TextEditingController email = TextEditingController();
//   final ImplmentRepoforgetpassword implmentRepoforgetpassword;
//   void forgetpasswrdCubit() async {
//     emit(ForgetpasswordLoading());
//     var result = await implmentRepoforgetpassword.forgetpassword(
//       email:email.text ,

//     );
//     result.fold(
//       (failur) => emit(ForgetpasswordFailure(failur.errMassage)),
//       (successful) => emit(ForgetpasswordSuccess(massage: successful)),
//     );
//   }
// }
