import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';

abstract class RepoChangeImage {
  Future<Either<Failur, String>> changeProfileImage(String filePath);
}
