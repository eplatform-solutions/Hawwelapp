import 'package:hawwel/featue/support_chat/data/model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatConnecting extends ChatState {}

class ChatLoaded extends ChatState {
  final String conversationId;
  final List<ChatMessageModel> messages;
  final bool sending;

  ChatLoaded({
    required this.conversationId,
    required this.messages,
    this.sending = false,
  });

  ChatLoaded copyWith({List<ChatMessageModel>? messages, bool? sending}) {
    return ChatLoaded(
      conversationId: conversationId,
      messages: messages ?? this.messages,
      sending: sending ?? this.sending,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
