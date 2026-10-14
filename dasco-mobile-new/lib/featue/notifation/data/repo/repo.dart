import 'package:dartz/dartz.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/notifation/data/model.dart';
 
abstract class NotificationsRepo {
  Future<Either<Failur, NotificationsResponse>> getNotifications({
    required int pageNumber,
    required int pageSize,
  });
   Future<Either<Failur, void>> markAllAsRead();
  
}
