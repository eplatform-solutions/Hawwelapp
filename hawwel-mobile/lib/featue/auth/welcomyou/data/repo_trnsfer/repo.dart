import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_ressponse_transfer.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_transfer.dart';

abstract class TransferRepo {
  Future<Either<Failur, TransferResponseModel>> sendTransfer(
    TransferRequestModel model,
  );
}
