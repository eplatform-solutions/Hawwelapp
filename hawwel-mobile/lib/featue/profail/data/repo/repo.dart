import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/profail/data/modal.dart';

abstract class Repouserinfo {
 Future<Either<Failur, StudentInfo>> get_user_info();
}
