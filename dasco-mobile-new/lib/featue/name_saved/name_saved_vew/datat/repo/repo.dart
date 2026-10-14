import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';

abstract class ReceiversRepo {
  Future<Either<Failur, String>> addReceiver({
    required String fullName,
    required String mobilePhone,
  });
}
