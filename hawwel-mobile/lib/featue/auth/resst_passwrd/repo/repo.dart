import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';

abstract class ChangePasswordRepo {
  Future<Either<Failur, String>> changePassword({
    required String password,
    required String newPassword,
  });
}
