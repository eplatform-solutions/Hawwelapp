import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:usdt/constans/token.dart';
import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
import 'package:usdt/featue/auth/rejster/data/repo/rejster_repo_implmantion.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.repo) : super(RegisterInitial());

  final ImplmentReporejster repo;

  // Controllers
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController otpEmail = TextEditingController();
  final TextEditingController otpphone = TextEditingController();
  //final TextEditingController otpEmailrest = TextEditingController();
  final TextEditingController phonee = TextEditingController();

  String? sessionForEmail;
  String? sessionForphone;
  String? submittedMobilePhone;
  // **************** SEND OTP ****************
  Future<void> sendOtpemail() async {
    emit(RegisterOTPLoading());

    var result = await repo.sendotpemail(email: email.text);

    result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
      sessionForEmail = success["session"];
      emit(RegisterOTPSent(success["msg"]));
    });
  }

  Future<void> sendOtpphone() async {
    emit(RegisterOTPLoading());

    var result = await repo.sendotphone(
      phonenumber: submittedMobilePhone ?? phonee.text,
    );

    result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
      sessionForphone = success["session"];
      emit(RegisterOTPSent(success["msg"]));
    });
  }

  /// إرسال رمز التحقق للجوال بعد التحقق من الرقم (مثلاً بعد «سجل الآن»).
  Future<bool> requestMobileOtpForSignup({required String mobilePhone}) async {
    emit(RegisterOTPLoading());
    submittedMobilePhone = mobilePhone;
    final result = await repo.sendotphone(phonenumber: mobilePhone.trim());
    return result.fold(
      (fail) {
        emit(RegisterOTPError(fail.errMassage));
        return false;
      },
      (success) {
        sessionForphone = success["session"];
        emit(RegisterOTPSent(success["msg"] ?? ""));
        return true;
      },
    );
  }

  Future<void> sendOtpchange() async {
    emit(RegisterOTPLoading());

    var result = await repo.sendotpchang(email: email.text);

    result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
      sessionForEmail = success["session"];
      emit(RegisterOTPSent(success["msg"]));
    });
  }

  // **************** RESEND OTP ****************
  Future<void> sendOtpAgain(String email) async {
    emit(RegisterOTPLoading());

    var result = await repo.sendotprest(email: email);

    result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
      sessionForEmail = success["session"];
      emit(RegisterOTPSent(success["msg"]));
    });
  }

  Future<void> sendOtpfactorauthentication(String email) async {
    emit(RegisterOTPLoading());

    var result = await repo.sendOtpTwofactorauthentication(email: email);

    result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
      sessionForEmail = success["session"];
      emit(RegisterOTPSent(success["msg"]));
    });
  }

  Future<void> verifyOtpAndGetSession({
    required String otp,
    required String session,
  }) async {
    emit(RegisterOTPLoading());

    final result = await repo.verifyOtp(code: otp, session: session);

    result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
      final data = success["data"];

      emit(
        RegisterOTPVerified(msg: success["msg"], newSession: data["session"]),
      );
    });
  }

  Future<void> verifyOtpAndGetSession2({
    required String otp,
    required String session,
  }) async {
    emit(RegisterOTPLoading());

    final result = await repo.verifyOtp(code: otp, session: session);

    result.fold(
      (fail) {
        emit(RegisterOTPError(fail.errMassage));
      },
      (success) async {
        final data = success["data"];
        final token = data?["token"];

        if (token == null || token.toString().isEmpty) {
          emit(RegisterOTPError("Token not returned from server"));
          return;
        }

        // 🔐 حفظ التوكن
        await Functions().saveToken(token);

        emit(
          RegisterOTPVerified(
            msg: success["msg"],
            newSession: data["session"] ?? session,
          ),
        );
      },
    );
  }

  // **************** VERIFY OTP ****************
  // Future<void> verifyOtpAndGetSession({
  //   required String otp,
  //   required String session,
  // }) async {
  //   emit(RegisterOTPLoading());

  //   var result = await repo.verifyOtp(
  //     code: otp,
  //     session: session,
  //     // code: otpEmailrest.text,
  //     // session: session,
  //   );

  //   result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
  //     if (success["session"] != null) {
  //       sessionForEmail = success["session"];
  //     }

  //     emit(
  //       RegisterOTPVerified(
  //         msg: success["msg"],
  //         newSession: sessionForEmail ?? session,
  //       ),
  //     );
  //   });
  // }

  // **************** REGISTER ****************
  Future<void> register() async {
    emit(RegisterLoading());

    var result = await repo.rejster(
      phone: submittedMobilePhone ?? phonee.text,
      firstname: firstName.text,
      lastname: lastName.text,
      email: email.text,
      country: country.text,
      password: password.text,
      confirmpassword: confirmPassword.text,
      emailverificationcode: otpEmail.text,
      sessionForEmail: sessionForEmail ?? "",
      mobilePhoneCode: otpphone.text,
      sessionForMobilePhone: sessionForphone ?? "",
    );

    result.fold(
      (fail) => emit(RegisterError(fail.errMassage)),
      (success) => emit(RegisterSuccess(success)),
    );
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
// import 'package:usdt/featue/auth/rejster/data/repo/rejster_repo_implmantion.dart';

// class RegisterCubit extends Cubit<RegisterState> {
//   RegisterCubit(this.repo) : super(RegisterInitial());

//   final ImplmentReporejster repo;

//   // Controllers
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   final TextEditingController confirmPassword = TextEditingController();
//   final TextEditingController firstName = TextEditingController();
//   final TextEditingController lastName = TextEditingController();
//   final TextEditingController country = TextEditingController();
//   final TextEditingController otpEmail = TextEditingController();
//   final TextEditingController otpEmailrest = TextEditingController();
//   // session used for verification
//   String? sessionForEmail;

//   // **************** SEND OTP ****************
//   Future<void> sendOtp() async {
//     emit(RegisterOTPLoading());

//     var result = await repo.sendotp(email: email.text);

//     result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
//       sessionForEmail = success["session"];
//       emit(RegisterOTPSent(success["msg"]));
//     });
//   }
//   Future<void> sendOtpchange() async {
//     emit(RegisterOTPLoading());

//     var result = await repo.sendotpchang(email: email.text);

//     result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
//       sessionForEmail = success["session"];
//       emit(RegisterOTPSent(success["msg"]));
//     });
//   }

//   // **************** RESEND OTP ****************
//   Future<void> sendOtpAgain(String email) async {
//     emit(RegisterOTPLoading());

//     var result = await repo.sendotprest(email: email);

//     result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
//       sessionForEmail = success["session"]; // ← تحديث السشن الجديد
//       emit(RegisterOTPSent(success["msg"]));
//     });
//   }
//   Future<void> sendOtpfactorauthentication(String email) async {
//     emit(RegisterOTPLoading());

//     var result = await repo.sendOtpTwofactorauthentication(email: email);

//     result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
//       sessionForEmail = success["session"]; // ← تحديث السشن الجديد
//       emit(RegisterOTPSent(success["msg"]));
//     });
//   }

//   Future<void> verifyOtpAndGetSession({
//     required String otp,
//     required String session,
//   }) async {
//     emit(RegisterOTPLoading());

//     var result = await repo.verifyOtp(
//       code: otpEmailrest.text,
//       session: session,
//     );

//     result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (success) {
//       // خزن فقط إذا رجع فعلاً
//       if (success["session"] != null) {
//         sessionForEmail = success["session"];
//       }

//       emit(
//         RegisterOTPVerified(
//           msg: success["msg"],
//           newSession: sessionForEmail ?? session,
//         ),
//       );
//     });
//   }

//   // **************** VERIFY OTP ****************
//   //   Future<void> verifyOtpAndGetSession({
//   //   required String otp,
//   //   required String session,
//   // }) async {
//   //   emit(RegisterOTPLoading());

//   //   var result = await repo.verifyOtp(
//   //     code: otpEmailrest.text,
//   //     session: session,
//   //   );

//   //   result.fold(
//   //     (fail) => emit(RegisterOTPError(fail.errMassage)),
//   //     (success) {
//   //       // خزن فقط إذا رجع فعلاً
//   //       if (success["session"] != null) {
//   //         sessionForEmail = success["session"];
//   //       }

//   //       emit(RegisterOTPSent(success["msg"]));
//   //     },
//   //   );
//   // }

//   // **************** REGISTER ****************
//   Future<void> register() async {
//     emit(RegisterLoading());

//     var result = await repo.rejster(
//       firstname: firstName.text,
//       lastname: lastName.text,
//       email: email.text,
//       country: country.text,
//       password: password.text,
//       confirmpassword: confirmPassword.text,
//       emailverificationcode: otpEmail.text,
//       sessionForEmail: sessionForEmail ?? "",
//     );

//     result.fold(
//       (fail) => emit(RegisterError(fail.errMassage)),
//       (success) => emit(RegisterSuccess(success)),
//     );
//   }
// }

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
// import 'package:usdt/featue/auth/rejster/data/repo/rejster_repo_implmantion.dart';

// class RegisterCubit extends Cubit<RegisterState> {
//   RegisterCubit(this.repo) : super(RegisterInitial());

//   final ImplmentReporejster repo;

//   // Controllers
//   final email = TextEditingController();
//   final password = TextEditingController();
//   final confirmPassword = TextEditingController();
//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final country = TextEditingController();
//   final otppp = TextEditingController();
//   final otpEmail = TextEditingController();

//   String? sessionForEmail;

//   Future<void> sendOtpAgain(String email) async {
//     emit(RegisterOTPLoading());

//     var result = await repo.sendotp(email: email);

//     result.fold(
//       (fail) => emit(RegisterOTPError(fail.errMassage)),
//       (success) => emit(RegisterOTPSuccess(success["msg"])),
//     );
//   }

//   Future<void> sendOtpafteremail() async {
//     emit(RegisterOTPLoading());

//     var result = await repo.sendotpafteremai(otpp: otpEmail.text);

//     result.fold(
//       (fail) => emit(RegisterOTPError(fail.errMassage)),
//       (success) => emit(RegisterOTPSuccess(success["msg"])),
//     );
//   }

//   Future<void> sendOtp() async {
//     emit(RegisterOTPLoading());

//     var result = await repo.sendotp(email: email.text);

//     result.fold((fail) => emit(RegisterOTPError(fail.errMassage)), (
//       successData,
//     ) {
//       sessionForEmail = successData["session"];
//       emit(RegisterOTPSuccess(successData["msg"]));
//     });
//   }

//   Future<void> register() async {
//     emit(RegisterLoading());

//     var result = await repo.rejster(
//       firstname: firstName.text,
//       lastname: lastName.text,
//       email: email.text,
//       country: country.text,
//       password: password.text,
//       confirmpassword: confirmPassword.text,
//       emailverificationcode: otpEmail.text,
//       sessionForEmail: sessionForEmail ?? "",
//     );

//     result.fold(
//       (fail) => emit(RegisterError(fail.errMassage)),
//       (success) => emit(RegisterSuccess(success)),
//     );
//   }

// }
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:usdt/featue/auth/rejster/data/cubit/regster_cubi_statet.dart';
// import 'package:usdt/featue/auth/rejster/data/repo/rejster_repo_implmantion.dart';

// class RegisterCubit extends Cubit<RegisterState> {
//   RegisterCubit(this.repo) : super(RegisterInitial());

//   final ImplmentReporejster repo;

//   final email = TextEditingController();
//   final password = TextEditingController();
//   final confirmPassword = TextEditingController();
//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final country = TextEditingController();
//   final otpEmail = TextEditingController();

//   String? sessionForEmail;

//   Future<void> sendOtp() async {
//     emit(RegisterOTPLoading());

//     var result = await repo.sendotp(email: email.text);

//     result.fold(
//       (fail) => emit(RegisterOTPError(fail.errMassage)),
//       (success) {
//         sessionForEmail = success["session"];
//         emit(RegisterOTPSuccess(success["msg"]));
//       },
//     );
//   }
//  Future<void> sendOtpAgain(String email) async {
//     emit(RegisterOTPLoading());

//     var result = await repo.sendotp(email: email);

//     result.fold(
//       (fail) => emit(RegisterOTPError(fail.errMassage)),
//       (success) => emit(RegisterOTPSuccess(success["msg"])),
//     );
//   }

//  Future<void> verifyOtpAndGetSession({
//   required String code,
//   required String session,
// }) async {
//   emit(RegisterOTPLoading());

//   var result = await repo.verifyOtp(
//     code: code,
//     session: session,
//   );

//   result.fold(
//     (fail) => emit(RegisterOTPError(fail.errMassage)),
//     (success) {
//       // خزّن السشن الجديد القادم من الباك
//       sessionForEmail = success["session"] as String?;

//       emit(RegisterOTPSuccess(sessionForEmail ?? ""));
//     },
//   );
// }

//   // Future<void> verifyOtp() async {
//   //   emit(RegisterOTPLoading());

//   //   var result = await repo.sendotpafteremai(
//   //     otpp: otpEmail.text,
//   //   );

//   //   result.fold(
//   //     (fail) => emit(RegisterOTPError(fail.errMassage)),
//   //     (success) => emit(RegisterOTPSuccess(success["msg"])),
//   //   );
//   // }

//   Future<void> register() async {
//     emit(RegisterLoading());

//     var result = await repo.rejster(
//       firstname: firstName.text,
//       lastname: lastName.text,
//       email: email.text,
//       country: country.text,
//       password: password.text,
//       confirmpassword: confirmPassword.text,
//       emailverificationcode: otpEmail.text,
//       sessionForEmail: sessionForEmail ?? "",
//     );

//     result.fold(
//       (fail) => emit(RegisterError(fail.errMassage)),
//       (success) => emit(RegisterSuccess(success)),
//     );
//   }
// }
