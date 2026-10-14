// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/widgets.dart';
// import 'package:usdt/featue/auth/login/data/cubit/login_cubit_state.dart';
// import 'package:usdt/featue/auth/login/data/repo/login_repo.dart';

// class LoginCubit extends Cubit<LoginState> {
//   LoginCubit(this.repo) : super(LoginInitial());

//   final ImplmentRepoLogin repo;
//   final email = TextEditingController();
//   final password = TextEditingController();

//   Future<void> logincub() async {
//     emit(LoginLoading());

//     var result = await repo.login(
//       email: email.text,
//       password: password.text,
//     );

//     result.fold(
//       (failure) => emit(LoginFailure(failure.errMassage)),
//       (success) => emit(LoginSuccess(success)),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/auth/login/data/cubit/login_cubit_state.dart';
import 'package:usdt/featue/auth/login/data/repo/login_repo.dart';
import 'package:usdt/firbeas/notifaction.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.repo) : super(LoginInitial());

  final ImplmentRepoLogin repo;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> logincub({String? loginValue}) async {
    emit(LoginLoading());

    var result = await repo.login(
      email: loginValue ?? email.text,
      password: password.text,
    );

    // result.fold((failure) => emit(LoginFailure(failure.errMassage)), (success) {
    //   print("🔥 RAW SUCCESS FROM REPO → $success");
    //   emit(LoginSuccess(success));
      
    // });
    result.fold(
  (failure) => emit(LoginFailure(failure.errMassage)),
  (success) async {
    emit(LoginSuccess(success));

    await Notifications.registerFCMToken(
      loggedIn: true,
      language: 'ar',
    );
  },
);

  }
}
