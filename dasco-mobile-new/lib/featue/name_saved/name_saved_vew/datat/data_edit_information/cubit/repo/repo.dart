import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';

abstract class UpdateReceiverRepo {
  Future<Either<Failur, String>> updateReceiver({
    required String receiverId,
    required String fullName,
    required String mobilePhone,
  });
  Future<Either<Failur, String>> deleteReceiver(String receiverId);
}