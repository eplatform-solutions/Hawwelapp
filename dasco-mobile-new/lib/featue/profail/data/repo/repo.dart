// ignore_for_file: non_constant_identifier_names

import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/profail/data/modal.dart';

abstract class Repouserinfo {
 Future<Either<Failur, StudentInfo>> get_user_info();
}
