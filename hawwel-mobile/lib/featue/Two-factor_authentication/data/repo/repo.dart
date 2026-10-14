 import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/Two-factor_authentication/data/repo/modal.dart';

abstract class Change2FARepository {
  Future<Either<Failur, Change2FAResponse>> change2FA({
    required bool enabled,
    required List<String> methods,
  });
}
