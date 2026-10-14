import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/notifation/data/model.dart';
import 'package:usdt/featue/notifation/data/repo/repo.dart';

class NotificationsRepoImpl extends NotificationsRepo {
  final ApiService _apiService;

  NotificationsRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, NotificationsResponse>> getNotifications({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      log('📤 GET Notifications');
      log('➡️ pageNumber: $pageNumber | pageSize: $pageSize');

      final response = await _apiService.get(
        endpoint:
            '/notifications/all-notifications-inside-the-page?pageNumber=$pageNumber&pageSize=$pageSize',
      );

      // 🟢 RESPONSE INFO
      log('✅ STATUS CODE: ${response.statusCode}');
      log('📦 RESPONSE DATA (RAW): ${response.data}');

      final data = response.data['data'];

      log('📊 notificationsCount: ${data['notificationsCount']}');
      log('📊 unreadNotificationsCount: ${data['unreadNotificationsCount']}');

      final notificationsJson = data['notifications'] as List;

      log('📬 notifications length: ${notificationsJson.length}');

       
      for (var i = 0; i < notificationsJson.length; i++) {
        log('🔔 Notification [$i] JSON => ${notificationsJson[i]}');
      }

      final notifications = notificationsJson
          .map((e) => NotificationModel.fromJson(e))
          .toList();

     
      for (var i = 0; i < notifications.length; i++) {
        final n = notifications[i];
        log(
          '🧩 NotificationModel [$i] => '
          'id=${n.id}, '
          'title=${n.title}, '
          'status=${n.data?.status}, '
          'createdAt=${n.createdAt}',
        );
      }

      return right(
        NotificationsResponse(
          notifications: notifications,
          totalCount: data['notificationsCount'],
          unreadCount: data['unreadNotificationsCount'],
        ),
      );
    } on DioException catch (e) {
      log("❌ Dio Error");
      log("❌ STATUS: ${e.response?.statusCode}");
      log("❌ DATA: ${e.response?.data}");
      log("❌ MESSAGE: ${e.message}");

      return left(ServierFailur.fromDioError(e));
    } catch (e, stack) {
      log("💥 Unexpected Error => $e");
      log("📌 StackTrace => $stack");
      return left(ServierFailur(e.toString(), 600));
    }
  }

  @override
  Future<Either<Failur, void>> markAllAsRead() async {
    try {
      final response = await _apiService.put(
        endpoint: '/notifications/mark-all-read',
        data: {},
      );
      log('✅ All notifications marked as read');
      log("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      log(response.toString());
      return right(null);
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 500));
    }
  }
}
