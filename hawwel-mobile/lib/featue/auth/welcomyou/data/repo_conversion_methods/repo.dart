import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart' show PaymentMethodModel;
//import 'package:hawwel/featue/auth/welcomyou/data/model_conversion_methods.dart';
 
 

// abstract class PaymentMethodsRepo {
//   Future<Either<Failur, List<PaymentMethodModel>>> getByArea(String areaId);
// }
abstract class PaymentMethodsRepo {
  // عدل السطر ليكون هكذا:
  Future<Either<Failur, (List<PaymentMethodModel>, String)>> getByArea(String areaId);
}