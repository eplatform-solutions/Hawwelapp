import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';

abstract class DepositExternalRepo {
  Future<Either<Failur, dynamic>> depositExternal({
    required String address,
    required String txId,
    required String chain,
    required String subscriptionType,
    required num amount,
    required String contractAddress,
  });
}
