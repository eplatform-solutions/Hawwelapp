import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart'
    show PaymentMethodModel;

abstract class CountryPaymentMethodsRepo {
  Future<Either<Failur, (List<PaymentMethodModel>, String)>> getByCountry(
    String countryId,
  );
}
