import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/transaction_historu/data/model.dart';

abstract class TransfersRepo {
  Future<Either<Failur, List<TransfersByDateModel>>> getTransfers({
    required int pageNumber,
    required int pageSize,
  });
}
