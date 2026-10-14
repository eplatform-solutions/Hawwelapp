class ChatMessageModel {
  final String id;
  final String conversationId;
  final String senderType; // "customer" | "admin"
  final String? senderName;
  final String body;
  final DateTime createdAt;

  /// When the other side read this message (null = delivered, not read).
  /// Filled from history and updated live from the `conversation:read`
  /// socket event - drives the ✓ / ✓✓ marks on the customer's own bubbles.
  final DateTime? readAt;

  const ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderType,
    this.senderName,
    required this.body,
    required this.createdAt,
    this.readAt,
  });

  bool get isRead => readAt != null;

  ChatMessageModel copyWith({DateTime? readAt}) {
    return ChatMessageModel(
      id: id,
      conversationId: conversationId,
      senderType: senderType,
      senderName: senderName,
      body: body,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final senderName = (json['senderName'] ?? '').toString().trim();
    return ChatMessageModel(
      id: (json['_id'] ?? '').toString(),
      conversationId: (json['conversation'] ?? '').toString(),
      senderType: (json['senderType'] ?? '').toString(),
      senderName: senderName.isEmpty ? null : senderName,
      body: (json['body'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString())
              ?.toLocal() ??
          DateTime.now(),
      readAt: json['readAt'] == null
          ? null
          : DateTime.tryParse(json['readAt'].toString())?.toLocal(),
    );
  }
}
