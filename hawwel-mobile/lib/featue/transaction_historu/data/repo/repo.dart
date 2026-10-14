import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart';

abstract class TransfersRepo {
  Future<Either<Failur, List<TransfersByDateModel>>> getTransfers({
    required int pageNumber,
    required int pageSize,
  });
}
