import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hawwel/constans/failear.dart';

abstract class Reporejster {
  Future<Either<Failur, Map<String, dynamic>>> sendotpemail({
    required String email,
  });
   Future<Either<Failur, Map<String, dynamic>>> sendotphone({
    required String phonenumber,
  });
   Future<Either<Failur, Map<String, dynamic>>> sendotpchang({
    required String email,
  });
 Future<Either<Failur, Map<String, dynamic>>>sendotprest({
    required String email,
  });
  Future<Either<Failur, Map<String, dynamic>>>sendOtpTwofactorauthentication({
    required String email,
  });
  Future<Either<Failur, Map<String, dynamic>>> verifyOtp({
    required String session,
    required String code,
    CancelToken? cancelToken,
  });

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
    required String mobilePhoneCode,
    required String sessionForMobilePhone
  });
}

// import 'package:dartz/dartz.dart';
// import 'package:hawwel/constans/failear.dart';

// abstract class Reporejster {
//   Future<Either<Failur, Map<String, dynamic>>> sendotp({
//     required String email,
//   });
//   //  Future<Either<Failur, Map<String, dynamic>>> restotp({
//   //   required String email,
//   // });
//   //  Future<Either<Failur, Map<String, dynamic>>> sendotpafteremai({
//   //   required String  otpp,
//   // });
//    Future<Either<Failur, Map<String, dynamic>>> verifyOtp({
//   required String session,
//    required String code,
//   });

//   Future<Either<Failur, String>> rejster({
//     required String firstname,
//     required String lastname,
//     required String email,
//     required String country,
//     required String password,
//     required String confirmpassword,
//     required String emailverificationcode,
//     required String sessionForEmail,
//   });
// }
