// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/widgets.dart';
// import 'package:hawwel/featue/auth/login/data/cubit/login_cubit_state.dart';
// import 'package:hawwel/featue/auth/login/data/repo/login_repo.dart';

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
import 'package:hawwel/featue/auth/login/data/cubit/login_cubit_state.dart';
import 'package:hawwel/featue/auth/login/data/repo/login_repo.dart';
import 'package:hawwel/firbeas/notifaction.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.repo) : super(LoginInitial());

  final ImplmentRepoLogin repo;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  // The identifier actually sent to the server (E.164 phone with country
  // code, or the email) - the raw field text lacks the country code, so a
  // 2FA resend built from it could never be matched to the account.
  String lastLoginIdentifier = '';

  Future<void> logincub({String? loginValue}) async {
    emit(LoginLoading());

    lastLoginIdentifier = (loginValue ?? email.text).trim();
    var result = await repo.login(
      email: lastLoginIdentifier,
      // Keyboards can append a stray space after punctuation; never send it.
      password: password.text.trim(),
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
