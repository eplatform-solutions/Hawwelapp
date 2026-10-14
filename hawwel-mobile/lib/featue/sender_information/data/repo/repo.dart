// import 'package:dartz/dartz.dart';
// import 'package:usdt/constans/failear.dart';
// import 'package:usdt/featue/sender_information/data/model.dart';
 
// abstract class ReceiversDisplayRepo {
//   Future<Either<Failur, List<ReceiversDisplayModel>>> getAllReceiversDisplay();
// }
import 'package:dartz/dartz.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/sender_information/data/model.dart';

abstract class ReceiversDisplayRepo {
  // أضفنا متغير fullName لفلترة النتائج
  Future<Either<Failur, List<ReceiversDisplayModel>>> getAllReceiversDisplay({String? fullName});
}