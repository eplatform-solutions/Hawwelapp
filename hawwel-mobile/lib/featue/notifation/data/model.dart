// class NotificationModel {
//   final String id;
//   final String title;
   
//   final String body;
//   final bool isRead;
//   final DateTime createdAt;
//   final NotificationExtraData? data;

//   NotificationModel({
//     required this.id,
    
//     required this.title,
//     required this.body,
//     required this.isRead,
//     required this.createdAt,
//     this.data,
//   });

//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       id: json['_id'],
      
//       title: json['title'],
//       body: json['body'],
//       isRead: json['isRead'],
//       createdAt: DateTime.parse(json['createdAt']),
//       data:
//           json['data'] != null
//               ? NotificationExtraData.fromJson(json['data'])
//               : null,
//     );
//   }
// }
// class NotificationExtraData {
//   final String transferId;
//   final String amount;
//   final String paid;
//   final String status;

//   final String symbol;   // 👈 جديد
//   final String address;  // 👈 جديد
//   final String network;  // 👈 جديد

//   final String fullName;
//   final String toCountry;
//   final String city;
//   final String area;
//   final String paymentMethod;

//   NotificationExtraData({
//     required this.transferId,
//     required this.amount,
//     required this.paid,
//     required this.status,
//     required this.symbol,
//     required this.address,
//     required this.network,
//     required this.fullName,
//     required this.toCountry,
//     required this.city,
//     required this.area,
//     required this.paymentMethod,
//   });

//   factory NotificationExtraData.fromJson(Map<String, dynamic> json) {
//     return NotificationExtraData(
//       transferId: json['transferId'],
//       amount: json['amount'].toString(),
//       paid: json['paid'].toString(),
//       status: json['status'],

//       symbol: json['symbol'] ?? '',
//       address: json['address'] ?? '',
//       network: json['network'] ?? '',

//       fullName: json['fullName'] ?? '',
//       toCountry: json['toCountry'] ?? '',
//       city: json['city'] ?? '',
//       area: json['area'] ?? '',
//       paymentMethod: json['paymentMethod'] ?? '',
//     );
//   }
// }

 
// class NotificationsResponse {
//   final List<NotificationModel> notifications;
//   final int totalCount;
//   final int unreadCount;

//   NotificationsResponse({
//     required this.notifications,
//     required this.totalCount,
//     required this.unreadCount,
//   });
// }
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final NotificationExtraData? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? NotificationExtraData.fromJson(json['data'])
          : null,
    );
  }
}

class NotificationExtraData {
  final String transferId;
  final String amount;
  final String paid;
  final String status;
  final String symbol;
  final String address;
  final String network;
  final String fullName;
  final String toCountry;

  // الحقول المترجمة مفصولة (عربي / إنجليزي)
  final String cityAr;
  final String cityEn;
  final String areaAr;
  final String areaEn;
  final String paymentMethodAr;
  final String paymentMethodEn;

  NotificationExtraData({
    required this.transferId,
    required this.amount,
    required this.paid,
    required this.status,
    required this.symbol,
    required this.address,
    required this.network,
    required this.fullName,
    required this.toCountry,
    required this.cityAr,
    required this.cityEn,
    required this.areaAr,
    required this.areaEn,
    required this.paymentMethodAr,
    required this.paymentMethodEn,
  });

  factory NotificationExtraData.fromJson(Map<String, dynamic> json) {
    return NotificationExtraData(
      transferId: json['transferId']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0',
      paid: json['paid']?.toString() ?? '0',
      status: json['status']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      network: json['network']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      toCountry: json['toCountry']?.toString() ?? '',

      // الوصول للبيانات من داخل الـ Map لكل حقل مترجم
      cityAr: json['city'] != null ? (json['city']['ar'] ?? '') : '',
      cityEn: json['city'] != null ? (json['city']['en'] ?? '') : '',
      
      areaAr: json['area'] != null ? (json['area']['ar'] ?? '') : '',
      areaEn: json['area'] != null ? (json['area']['en'] ?? '') : '',
      
      paymentMethodAr: json['paymentMethod'] != null ? (json['paymentMethod']['ar'] ?? '') : '',
      paymentMethodEn: json['paymentMethod'] != null ? (json['paymentMethod']['en'] ?? '') : '',
    );
  }

  // دالة مساعدة اختيارية للحصول على المدينة حسب اللغة
  String getCity(String lang) => lang == 'ar' ? cityAr : cityEn;
}

class NotificationsResponse {
  final List<NotificationModel> notifications;
  final int totalCount;
  final int unreadCount;

  NotificationsResponse({
    required this.notifications,
    required this.totalCount,
    required this.unreadCount,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    // نتأكد أننا نقرأ من داخل مفتاح data
    final dataMap = json['data'] ?? {};
    return NotificationsResponse(
      notifications: (dataMap['notifications'] as List? ?? [])
          .map((e) => NotificationModel.fromJson(e))
          .toList(),
      totalCount: dataMap['notificationsCount'] ?? 0,
      unreadCount: dataMap['unreadNotificationsCount'] ?? 0,
    );
  }
}