import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/constans/widgets/floating_chat_button.dart'
    show CurrentRouteObserver;
import 'package:hawwel/featue/support_chat/data/model.dart';
import 'package:hawwel/featue/support_chat/data/chat_socket_service.dart';
import 'package:hawwel/featue/support_chat/data/cubite/cubite_state.dart';
import 'package:hawwel/featue/support_chat/support_chat_view.dart'
    show SupportChatView;

// Delegates the actual socket connection to [ChatSocketService], which is
// shared app-wide and lives for the whole logged-in session. This cubit
// only fetches the conversation history over REST and subscribes to that
// shared stream for as long as the chat screen is open.
class ChatCubit extends Cubit<ChatState> {
  final ApiService api;
  StreamSubscription<ChatMessageModel>? _sub;
  StreamSubscription<String>? _readSub;

  // Bumped on every connect() and disconnectSocket(). connect() has two
  // network awaits before it subscribes; if the screen is closed in that
  // window, dispose() cancels a subscription that doesn't exist yet and the
  // late-arriving one leaks for the rest of the session - marking every
  // future admin message read while nobody is looking. Checking the
  // generation after each await makes that stale continuation bail out.
  int _connectGeneration = 0;

  ChatCubit(this.api) : super(ChatInitial());

  bool get _isChatScreenVisible =>
      CurrentRouteObserver.currentRouteName.value == SupportChatView.routeName;

  Future<void> connect() async {
    final generation = ++_connectGeneration;
    emit(ChatConnecting());

    final token = await Functions().getToken();
    if (generation != _connectGeneration) return;
    if (token == null || token.isEmpty) {
      emit(ChatError('unauthorized'));
      return;
    }

    try {
      final response = await api.get(endpoint: '/chat/conversation');
      if (generation != _connectGeneration) return;
      final data = Map<String, dynamic>.from(response.data['data']);
      final conversationId = (data['conversation']['_id'] ?? '').toString();
      final messages = ((data['messages'] as List?) ?? [])
          .map((m) => ChatMessageModel.fromJson(Map<String, dynamic>.from(m)))
          .toList();
      emit(ChatLoaded(conversationId: conversationId, messages: messages));
    } catch (e) {
      if (generation != _connectGeneration) return;
      emit(ChatError(e.toString()));
      return;
    }

    await ChatSocketService.instance.ensureConnected();
    if (generation != _connectGeneration) return;

    await _sub?.cancel();
    _sub = ChatSocketService.instance.messages.listen((msg) {
      final current = state;
      if (current is ChatLoaded && msg.conversationId == current.conversationId) {
        emit(current.copyWith(messages: [...current.messages, msg]));
        if (msg.senderType == 'admin') markRead();
      }
    });

    // Support read our messages: flip every unread customer bubble to ✓✓.
    await _readSub?.cancel();
    _readSub = ChatSocketService.instance.readEvents.listen((by) {
      final current = state;
      if (by != 'admin' || current is! ChatLoaded) return;
      final now = DateTime.now();
      emit(current.copyWith(
        messages: [
          for (final m in current.messages)
            (m.senderType == 'customer' && !m.isRead)
                ? m.copyWith(readAt: now)
                : m,
        ],
      ));
    });

    markRead();
  }

  void sendMessage(String body) {
    final trimmed = body.trim();
    final current = state;
    if (trimmed.isEmpty || current is! ChatLoaded) return;

    emit(current.copyWith(sending: true));
    ChatSocketService.instance.sendMessage(trimmed, ack: (_) {
      final latest = state;
      if (latest is ChatLoaded) emit(latest.copyWith(sending: false));
    });
  }

  // Only a visible chat screen may send a read receipt - a stray listener
  // must never clear the unread count on the user's behalf.
  void markRead() {
    if (!_isChatScreenVisible) return;
    ChatSocketService.instance.markRead();
  }

  Future<void> disconnectSocket() async {
    _connectGeneration++;
    await _sub?.cancel();
    _sub = null;
    await _readSub?.cancel();
    _readSub = null;
  }

  @override
  Future<void> close() {
    _connectGeneration++;
    _sub?.cancel();
    _readSub?.cancel();
    return super.close();
  }
}
