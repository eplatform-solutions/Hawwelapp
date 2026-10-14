// import 'package:dartz/dartz.dart';
// import 'package:hawwel/constans/failear.dart';
// import 'package:hawwel/featue/sender_information/data/model.dart';
 
// abstract class ReceiversDisplayRepo {
//   Future<Either<Failur, List<ReceiversDisplayModel>>> getAllReceiversDisplay();
// }
import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/sender_information/data/model.dart';

abstract class ReceiversDisplayRepo {
  // أضفنا متغير fullName لفلترة النتائج
  Future<Either<Failur, List<ReceiversDisplayModel>>> getAllReceiversDisplay({String? fullName});
}