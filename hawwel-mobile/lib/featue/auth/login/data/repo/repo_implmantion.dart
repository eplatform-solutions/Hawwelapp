import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';

abstract class RepoLogin {
  Future<Either<Failur, dynamic>> login({
    required String email,
    required String password,
  });
}
