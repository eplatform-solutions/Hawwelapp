import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/constans/token.dart';
import 'package:usdt/featue/auth/rejster/data/repo/rejster_repo.dart';

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
    log('--- 📲 بدء إرسال OTP عبر الهاتف ---');
    log('📞 الرقم المرسل: $phonenumber');

    try {
      log('🚀 إرسال طلب POST إلى /verification-codes/send...');

      Response res = await _apiService.postdata(
        endpoint: "/verification-codes/send",
        data: {
          "mobilePhone": phonenumber,
          "channel": "sms",
          "typeOfUse": "activate-account",
        },
        needtoken: false,
      );

      log('✅ استجابة API وصلت');
      log('📡 Status Code: ${res.statusCode}');
      log('📦 Response Data: ${res.data}');

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      log('🌐 لغة التطبيق الحالية: $lang');

      final hasError = res.data["error"] == true;
      final session = res.data["data"]?["session"];

      log('🔍 تحليل الاستجابة:');
      log('  error = ${res.data["error"]}');
      log('  session = $session');

      if (!hasError) {
        log('📨 OTP أُرسل بنجاح عبر SMS');

        return right({"msg": res.data["msg"][lang], "session": session});
      } else {
        final errorMsg = res.data["msg"]?[lang] ?? 'فشل إرسال رمز التحقق';

        log('❌ فشل في إرسال OTP');
        log('  الرسالة: $errorMsg');

        return left(ServierFailur(errorMsg, 400));
      }
    } catch (e, stackTrace) {
      log('💥 استثناء أثناء إرسال OTP عبر الهاتف');
      log('الخطأ: $e');
      log('تتبع الخطأ:\n$stackTrace');

      if (e is DioException) {
        log('⚠️ نوع الخطأ: DioException');

        if (e.response != null) {
          log('📡 Status Code: ${e.response?.statusCode}');
          log('📦 Error Data: ${e.response?.data}');
        }

        log('🔗 URL: ${e.requestOptions.uri}');

        final failure = ServierFailur.fromDioError(e);
        log('📤 إرجاع فشل: ${failure.errMassage}');

        return left(failure);
      }

      final failure = ServierFailur('Send OTP failed: ${e.toString()}', 500);

      log('📤 إرجاع فشل عام: ${failure.errMassage}');
      return left(failure);
    }
  }

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
      Response res = await _apiService.postdata(
        endpoint: "/verification-codes/send",
        data: {"email": email, "typeOfUse": "login"},
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
  Future<Either<Failur, Map<String, dynamic>>> verifyOtp({
    required String session,
    required String code,
  }) async {
    try {
      final res = await _apiService.postdata(
        endpoint: "/verification-codes/verify",
        data: {"session": session, "code": code},
        needtoken: false,
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

      log("REGISTER RESPONSE: ${response.data}");

      // نجاح
      if (response.statusCode == 200 && response.data["error"] == false) {
        String msg =
            response.data["msg"]?[lang] ??
            response.data["msg"]?["ar"] ??
            "تم التسجيل بنجاح";
        final token = response.data["data"]?["token"];
        log('🎉 تسجيل الدخول ناجح!');

        if (token != null) {
          log('💾 حفظ التوكن في SharedPreference...');
          await Functions().setToken(token);
          log('✅ التوكن حُفظ بنجاح');
        } else {
          log('⚠️ تحذير: لم يتم استلام توكن من السيرفر!');
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
      // لوج مفصل مثل login
      log("📌 Dio ERROR (REGISTER) ----------------------------");
      log("Status Code: ${e.response?.statusCode}");
      log("Data: ${e.response?.data}");
      log("Message: ${e.message}");
      log("-----------------------------------------------------");

      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      log("📌 UNKNOWN ERROR (REGISTER): $e");
      return left(ServierFailur(e.toString(), 600));
    }
  }
}

// import 'dart:developer';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:usdt/constans/api_servise.dart';
// import 'package:usdt/constans/failear.dart';
// import 'package:usdt/featue/auth/rejster/data/repo/rejster_repo.dart';

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
// import 'package:usdt/constans/api_servise.dart';
// import 'package:usdt/constans/failear.dart';
// import 'package:usdt/featue/auth/rejster/data/repo/rejster_repo.dart';

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
