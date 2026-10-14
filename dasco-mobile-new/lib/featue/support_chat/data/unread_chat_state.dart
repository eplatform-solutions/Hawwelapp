import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/token.dart';

// Global, reactive unread count for support chat - read by the floating
// chat button's badge. Kept independent of ChatCubit/BlocProvider on
// purpose: it must be updatable from places with no widget tree context at
// all (a foreground push handler) and readable from the floating button
// that lives above the whole app.
//
// Never trusted from a single source: refreshFromServer() re-derives the
// real count from the database (used on app start, app resume, and every
// navigation), while bump() gives instant feedback for a push received
// while the app is already in the foreground - a background/terminated
// push runs in a separate isolate with no access to this notifier, so its
// count is picked up by the next refreshFromServer() instead (on resume).
class ChatUnreadState {
  static final ValueNotifier<int> count = ValueNotifier<int>(0);

  static void bump() {
    count.value = count.value + 1;
  }

  static void reset() {
    count.value = 0;
  }

  static Future<void> refreshFromServer() async {
    if (!Functions.loginStateNotifier.value) {
      count.value = 0;
      return;
    }
    try {
      final api = ApiService(dio: Dio());
      final response = await api.get(endpoint: '/chat/unread-count');
      final data = response.data['data'];
      final value = (data['count'] as num?)?.toInt() ?? 0;
      count.value = value < 0 ? 0 : value;
    } catch (_) {
      // Leave the last known value - a transient network failure shouldn't
      // blank out the badge.
    }
  }
}
