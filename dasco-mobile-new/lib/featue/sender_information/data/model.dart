class ReceiversDisplayModel {
  final String id;
  final String userId;
  final String fullName;
  final String mobilePhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReceiversDisplayModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.mobilePhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReceiversDisplayModel.fromJson(Map<String, dynamic> json) {
    return ReceiversDisplayModel(
      id: json['_id'],
      userId: json['userId'],
      fullName: json['fullName'],
      mobilePhone: json['mobilePhone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
