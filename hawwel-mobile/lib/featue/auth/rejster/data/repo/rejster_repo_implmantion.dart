import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/featue/auth/rejster/data/repo/rejster_repo.dart';

class ImplmentReporejster extends Reporejster {
  final ApiService _apiService;

  ImplmentReporejster({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, Map<String, dynamic>>> sendotpemail({
    required String email,
  }) async {
    try {
      Response res = await _apiService.postdata(
        endpoint: "/verification-codes/send",

        data: {"email": email, "typeOfUse": "activate-account"},
        needtoken: false,
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      if (!res.data["error"]) {
        return right({
          "msg": res.data["msg"][lang],
          "session": res.data["data"]["session"],
        });
      } else {
        return left(ServierFailur(res.data["msg"][lang], 400));
      }
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failur, Map<String, dynamic>>> sendotphone({
    required String phonenumber,
  }) async {
    try {
      Response res = await _apiService.postdata(
        endpoint: "/verification-codes/send",
        data: {
          "mobilePhone": phonenumber,
          "channel": "sms",
          "typeOfUse": "activate-account",
        },
        needtoken: false,
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      final hasError = res.data["error"] == true;
      final session = res.data["data"]?["session"];

      if (!hasError) {
        return right({"msg": res.data["msg"][lang], "session": session});
      } else {
        final errorMsg = res.data["msg"]?[lang] ?? 'فشل إرسال رمز التحقق';

        return left(ServierFailur(errorMsg, 400));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServierFailur.fromDioError(e));
      }

      return left(ServierFailur('Send OTP failed: ${e.toString()}', 500));
    }
  }

  @override
  Future<Either<Failur, Map<String, dynamic>>> sendotpchang({
    required String email,
  }) async {
    try {
      Response res = await _apiService.postdata(
        endpoint: "/verification-codes/send",
        data: {"email": email, "typeOfUse": "change-email"},
        needtoken: false,
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      if (!res.data["error"]) {
        return right({
          "msg": res.data["msg"][lang],
          "session": res.data["data"]["session"],
        });
      } else {
        return left(ServierFailur(res.data["msg"][lang], 400));
      }
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failur, Map<String, dynamic>>> sendOtpTwofactorauthentication({
    required String email,
  }) async {
    try {
      final value = email.trim();
      final isPhone = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value);
      final Map<String, dynamic> requestData = {
        if (isPhone) "mobilePhone": value else "email": value,
        "typeOfUse": "login",
      };
      Response res = await _apiService.postdata(
        endpoint: "/verification-codes/send",
        data: requestData,
        needtoken: false,
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      if (!res.data["error"]) {
        return right({
          "msg": res.data["msg"][lang],
          "session": res.data["data"]["session"],
        });
      } else {
        return left(ServierFailur(res.data["msg"][lang], 400));
      }
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failur, Map<String, dynamic>>> sendotprest({
    required String email,
  }) async {
    try {
      final value = email.trim();
      final isPhone = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value);
      final Map<String, dynamic> requestData = {
        if (isPhone) "mobilePhone": value else "email": value,
        "typeOfUse": "reset-password",
      };
      Response res = await _apiService.postdata(
        endpoint: "/verification-codes/send",
        data: requestData,
        needtoken: false,
      );
      // Response res = await _apiService.postdata(
      //   endpoint: "/verification-codes/send",
      //   data: {"email": email, "typeOfUse": "reset-password"},
      //   needtoken: false,
      // );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      if (!res.data["error"]) {
        return right({
          "msg": res.data["msg"][lang],
          "session": res.data["data"]["session"],
        });
      } else {
        return left(ServierFailur(res.data["msg"][lang], 400));
      }
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 500));
    }
  }

  // ********************* VERIFY OTP FIXED *********************
  // @override
  // Future<Either<Failur, Map<String, dynamic>>> verifyOtp({
  //   required String session,
  //   required String code,
  // }) async {
  //   try {
  //     Response res = await _apiService.postdata(
  //       endpoint: "/verification-codes/verify",
  //       data: {"session": session, "code": code},
  //       needtoken: false,
  //     );

  //     final prefs = await SharedPreferences.getInstance();
  //     final lang = prefs.getString("app_language") ?? "ar";

  //     if (!res.data["error"]) {
  //       return right({
  //         "msg": res.data["msg"][lang],
  //         "session": res.data["data"]["session"], // ← السشن الجديد
  //       });
  //     } else {
  //       return left(ServierFailur(res.data["msg"][lang], 400));
  //     }
  //   } on DioException catch (e) {
  //     return left(ServierFailur.fromDioError(e));
  //   } catch (e) {
  //     return left(ServierFailur(e.toString(), 500));
  //   }
  // }
  @override
  Future<Either<Failur, Map<String, dynamic>>> verifyOtp({
    required String session,
    required String code,
    CancelToken? cancelToken,
  }) async {
    try {
      final res = await _apiService.postdata(
        endpoint: "/verification-codes/verify",
        data: {"session": session, "code": code},
        needtoken: false,
        cancelToken: cancelToken,
        timeout: const Duration(seconds: 25),
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      if (res.data["error"] == false) {
        return right({
          "msg": res.data["msg"][lang],
          "data": res.data["data"], // 🔥 مهم جدًا
        });
      } else {
        return left(ServierFailur(res.data["msg"][lang], 400));
      }
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 500));
    }
  }

  // ********************* REGISTER *********************
  @override
  Future<Either<Failur, String>> rejster({
    required String firstname,
    required String lastname,
    required String email,
    required String country,
    required String password,
    required String confirmpassword,
    required String emailverificationcode,
    required String sessionForEmail,
    required String phone,
    required String sessionForMobilePhone,
    required String mobilePhoneCode,
  }) async {
    try {
      final trimmedEmail = email.trim();
      // country = ISO code (مثل SY/CH) لربط بلد المرسل في الحساب
      final Map<String, dynamic> payload = {
        "name": firstname,
        "nickname": lastname,
        "fatherName": "adnan",
        "country": country,
        "mobilePhone": phone,
        "password": password,
        "sessionForMobilePhone": sessionForMobilePhone,
        "mobilePhoneCode": mobilePhoneCode,
      };
      if (trimmedEmail.isNotEmpty) {
        payload["email"] = trimmedEmail;
        payload["emailCode"] = emailverificationcode;
        payload["sessionForEmail"] = sessionForEmail;
      }

      Response response = await _apiService.postdata(
        endpoint: "/auth/sign-up",
        data: payload,
        needtoken: false,
      );

      // قراءة اللغة من ال preferences
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      // نجاح
      if (response.statusCode == 200 && response.data["error"] == false) {
        String msg =
            response.data["msg"]?[lang] ??
            response.data["msg"]?["ar"] ??
            "تم التسجيل بنجاح";
        final token = (response.data["data"]?["token"] ?? "").toString().trim();

        if (token.isNotEmpty) {
          await Functions().setToken(token);
        } else {
          final missingTokenMessage = lang == 'ar'
              ? 'فشل إنشاء جلسة الحساب. يرجى المحاولة مرة أخرى.'
              : 'Failed to create account session. Please try again.';
          return left(ServierFailur(missingTokenMessage, 500));
        }
        return right(msg);
      }

      // فشل
      String errorMessage =
          response.data["msg"]?[lang] ??
          response.data["msg"]?["ar"] ??
          "حدث خطأ أثناء عملية التسجيل.";

      return left(ServierFailur(errorMessage, response.statusCode ?? 500));
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 600));
    }
  }
}

// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hawwel/constans/api_servise.dart';
// import 'package:hawwel/constans/failear.dart';
// import 'package:hawwel/featue/auth/rejster/data/repo/rejster_repo.dart';

// class ImplmentReporejster extends Reporejster {
//   final ApiService _apiService;

//   ImplmentReporejster({required ApiService apiService})
//     : _apiService = apiService;

//   @override
//   Future<Either<Failur, Map<String, dynamic>>> sendotp({
//     required String email,
//   }) async {
//     try {
//       Response res = await _apiService.postdata(
//         endpoint: "/verification-codes/send",
//         data: {"email": email, "typeOfUse": "activate-account"},
//         needtoken: false,
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final lang = prefs.getString("app_language") ?? "ar";

//       if (!res.data["error"]) {
//         return right({
//           "msg": res.data["msg"][lang],
//           "session": res.data["data"]["session"],
//         });
//       } else {
//         return left(ServierFailur(res.data["msg"][lang], 400));
//       }
//     } on DioException catch (e) {
//       return left(ServierFailur.fromDioError(e));
//     } catch (e) {
//       return left(ServierFailur(e.toString(), 500));
//     }
//   }

// @override
//   Future<Either<Failur, Map<String, dynamic>>> sendotpafteremai({
//    required String  otpp,
//   }) async {
//     try {
//       Response res = await _apiService.postdata(
//         endpoint: "/verification-codes/verify",
//         data: {"code": otpp, },
//         needtoken: false,
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final lang = prefs.getString("app_language") ?? "ar";

//       if (!res.data["error"]) {
//         return right({
//           "msg": res.data["msg"][lang],
//           "session": res.data["data"]["session"],
//         });
//       } else {
//         return left(ServierFailur(res.data["msg"][lang], 400));
//       }
//     } on DioException catch (e) {
//       return left(ServierFailur.fromDioError(e));
//     } catch (e) {
//       return left(ServierFailur(e.toString(), 500));
//     }
//   }
//   @override
//   Future<Either<Failur, Map<String, dynamic>>> restotp({
//     required String email,
//   }) async {
//     try {
//       Response res = await _apiService.postdata(
//         endpoint: "/verification-codes/send",
//         data: {"email": email, "typeOfUse": "reset-password"},
//         needtoken: false,
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final lang = prefs.getString("app_language") ?? "ar";

//       if (!res.data["error"]) {
//         return right({
//           "msg": res.data["msg"][lang],
//           "session": res.data["data"]["session"],
//         });
//       } else {
//         return left(ServierFailur(res.data["msg"][lang], 400));
//       }
//     } on DioException catch (e) {
//       return left(ServierFailur.fromDioError(e));
//     } catch (e) {
//       return left(ServierFailur(e.toString(), 500));
//     }
//   }

//   @override
//   Future<Either<Failur, String>> rejster({
//     required String firstname,
//     required String lastname,
//     required String email,
//     required String country,
//     required String password,
//     required String confirmpassword,
//     required String emailverificationcode,
//     required String sessionForEmail,
//   }) async {
//     try {
//       Response response = await _apiService.postdata(
//         endpoint: "/auth/sign-up",
//         data: {
//           "name": firstname,
//           "nickname": lastname,
//           "fatherName": "adnan",
//           "country": country,
//           "mobilePhone": "099665588741",
//           "email": email,
//           "password": password,
//           "confirm_password": confirmpassword,
//           "emailCode": emailverificationcode,
//           "mobilePhoneCode": "9406",
//           "sessionForEmail": sessionForEmail,
//           "sessionForMobilePhone": "691b3c7f05d2ac4586559044",
//         },
//         needtoken: false,
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final lang = prefs.getString("app_language") ?? "ar";

//       if (!response.data["error"]) {
//         return right(response.data["msg"][lang]);
//       }

//       return left(
//         ServierFailur(response.data["msg"][lang], response.statusCode ?? 400),
//       );
//     } on DioException catch (e) {
//       return left(ServierFailur.fromDioError(e));
//     } catch (e) {
//       return left(ServierFailur(e.toString(), 500));
//     }
//   }
// }
// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hawwel/constans/api_servise.dart';
// import 'package:hawwel/constans/failear.dart';
// import 'package:hawwel/featue/auth/rejster/data/repo/rejster_repo.dart';

// class ImplmentReporejster extends Reporejster {
//   final ApiService _apiService;

//   ImplmentReporejster({required ApiService apiService})
//     : _apiService = apiService;

//   @override
//   Future<Either<Failur, Map<String, dynamic>>> sendotp({
//     required String email,
//   }) async {
//     try {
//       Response res = await _apiService.postdata(
//         endpoint: "/verification-codes/send",
//         data: {"email": email, "typeOfUse": "activate-account"},
//         needtoken: false,
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final lang = prefs.getString("app_language") ?? "ar";

//       if (!res.data["error"]) {
//         return right({
//           "msg": res.data["msg"][lang],
//           "session": res.data["data"]["session"],
//         });
//       } else {
//         return left(ServierFailur(res.data["msg"][lang], 400));
//       }
//     } on DioException catch (e) {
//       return left(ServierFailur.fromDioError(e));
//     } catch (e) {
//       return left(ServierFailur(e.toString(), 500));
//     }
//   }

//   // 🟢 إضافة verifyOtp
//   @override
//   Future<Either<Failur, Map<String, dynamic>>> verifyOtp({
//     required String session,
//     required String code,
//   }) async {
//     try {
//       Response res = await _apiService.postdata(
//         endpoint: "/verification-codes/verify",
//         data: {"session": session, "code": code},
//         needtoken: false,
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final lang = prefs.getString("app_language") ?? "ar";

//       if (!res.data["error"]) {
//         return right(res.data["msg"][lang]);
//       } else {
//         return left(ServierFailur(res.data["msg"][lang], 400));
//       }
//     } on DioException catch (e) {
//       return left(ServierFailur.fromDioError(e));
//     } catch (e) {
//       return left(ServierFailur(e.toString(), 500));
//     }
//   }

//   @override
//   Future<Either<Failur, String>> rejster({
//     required String firstname,
//     required String lastname,
//     required String email,
//     required String country,
//     required String password,
//     required String confirmpassword,
//     required String emailverificationcode,
//     required String sessionForEmail,
//   }) async {
//     try {
//       Response response = await _apiService.postdata(
//         endpoint: "/auth/sign-up",
//         data: {
//           "name": firstname,
//           "nickname": lastname,
//           "fatherName": "adnan",
//           "country": country,
//           "mobilePhone": "099665588741",
//           "email": email,
//           "password": password,
//           "confirm_password": confirmpassword,
//           "emailCode": emailverificationcode,
//           "sessionForEmail": sessionForEmail,
//         },
//         needtoken: false,
//       );

//       final prefs = await SharedPreferences.getInstance();
//       final lang = prefs.getString("app_language") ?? "ar";

//       if (!response.data["error"]) {
//         return right(response.data["msg"][lang]);
//       }

//       return left(
//         ServierFailur(response.data["msg"][lang], response.statusCode ?? 400),
//       );
//     } on DioException catch (e) {
//       return left(ServierFailur.fromDioError(e));
//     } catch (e) {
//       return left(ServierFailur(e.toString(), 500));
//     }
//   }
// }
