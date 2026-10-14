import 'package:hawwel/featue/notifation/data/model.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final List<NotificationModel> notifications;
  final int totalCount;
  final int unreadCount;
  final bool hasMore;

  NotificationsSuccess({
    required this.notifications,
    required this.totalCount,
    required this.unreadCount,
    required this.hasMore,
  });
}


class NotificationsFailure extends NotificationsState {
  final String error;
  NotificationsFailure(this.error);
}
