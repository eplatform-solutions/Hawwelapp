 
import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
 
abstract class RepoForgetpassword {
 Future<Either<Failur, Map<String, dynamic>>> forgetpassword({
  required String email,
});

}
