import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
 
abstract class ConfirmRepo {
  Future<Either<Failur, String>> confirmPassword({
    required String password,
    required String otp,
    required String session,
  });
}
