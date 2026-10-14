// update_info_repo.dart

import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';

abstract class UpdateInfoRepo {
   Future<Either<Failur, Map<String, dynamic>>> sendotpchang({
    required String email,
  });
   Future<Either<Failur, Map<String, dynamic>>> sendotpchangphone({
    required String phonenumber,
  });
  Future<Either<Failur, String>> updateUserInfo({
    required String email,
    required String mobilePhone,
    required String emailCode,
    required String emailSession,
    required String phoneCode,
    required String phoneSession,
    String? country,
  });

  /// تحديث بلد المرسل فقط (ISO code مثل SY/CH).
  Future<Either<Failur, String>> updateSenderCountry({
    required String country,
  });
}
