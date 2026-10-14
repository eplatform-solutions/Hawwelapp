import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/featue/support_chat/data/model.dart';
import 'package:hawwel/featue/support_chat/data/unread_chat_state.dart';

// Owns the ONE support-chat socket connection for the whole app session -
// connected as soon as the user is logged in (not just while the chat
// screen happens to be open) so an incoming message updates
// [ChatUnreadState] in real time no matter which screen is on top.
// ChatCubit no longer owns a socket of its own: it fetches history over
// REST and then just subscribes to [messages] for the duration of the
// chat screen, exactly like any other listener.
class ChatSocketService {
  ChatSocketService._();
  static final ChatSocketService instance = ChatSocketService._();

  socket_io.Socket? _socket;
  final _controller = StreamController<ChatMessageModel>.broadcast();
  // Emits the reader ("admin") each time the other side reads the
  // conversation - lets open chat screens flip their ✓ to ✓✓ live.
  final _readController = StreamController<String>.broadcast();

  Stream<ChatMessageModel> get messages => _controller.stream;
  Stream<String> get readEvents => _readController.stream;

  void init() {
    if (Functions.loginStateNotifier.value) {
      ensureConnected();
    }
    Functions.loginStateNotifier.addListener(() {
      if (Functions.loginStateNotifier.value) {
        ensureConnected();
      } else {
        _disconnect();
      }
    });
  }

  // [force] bypasses the `.connected` check. That flag only reflects the
  // client's last-known belief about the connection - after the app sits
  // backgrounded for a while, socket.io's keep-alive stops running, the OS
  // can tear down the transport underneath it, and `.connected` is left
  // stuck at `true` for a socket that is actually dead. Call this with
  // `force: true` on every app resume so a stale connection can't silently
  // swallow every message for the rest of the session.
  Future<void> ensureConnected({bool force = false}) async {
    if (!force && _socket != null && _socket!.connected) return;

    final token = await Functions().getToken();
    if (token == null || token.isEmpty) return;

    _socket?.dispose();
    _socket = socket_io.io(
      '${ApiService.baseURL}/chat/customer',
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!.on('message:new', (raw) {
      final msg = ChatMessageModel.fromJson(Map<String, dynamic>.from(raw));
      if (msg.senderType == 'admin' && !_controller.hasListener) {
        ChatUnreadState.bump();
      }
      _controller.add(msg);
    });

    _socket!.on('conversation:read', (raw) {
      final by = raw is Map ? (raw['by'] ?? '').toString() : '';
      if (by.isNotEmpty) _readController.add(by);
    });

    _socket!.on('disconnect', (_) {
      // ignore: avoid_print
      print('ChatSocketService: socket disconnected');
    });
    _socket!.on('connect_error', (err) {
      // ignore: avoid_print
      print('ChatSocketService: connect error - $err');
    });

    _socket!.connect();
  }

  void _disconnect() {
    _socket?.dispose();
    _socket = null;
  }

  void sendMessage(String body, {void Function(dynamic)? ack}) {
    _socket?.emitWithAck('message:send', {'body': body}, ack: ack ?? (_) {});
  }

  void markRead() {
    // readUpTo lets the server ignore a late read receipt for messages that
    // arrived after this moment (see markConversationRead on the backend).
    _socket?.emit('message:read', {
      'readUpTo': DateTime.now().toUtc().toIso8601String(),
    });
    ChatUnreadState.reset();
  }
}
