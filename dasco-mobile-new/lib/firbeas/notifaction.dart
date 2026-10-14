// import 'dart:convert';
// import 'dart:developer' as developer;

// import 'package:dio/dio.dart' as dio;
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:hawwel/constans/token.dart';

// class Notifications {
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'usdt Notifications',
//     description: 'Important notifications for usdt',
//     importance: Importance.max,
//   );

//   /// تهيئة الإشعارات (تُنادى مرة واحدة في main أو بعد الـ splash)
//   static Future<void> init() async {
//     // طلب إذن الإشعارات
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // إنشاء القناة للأندرويد
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(_channel);

//     // تهيئة الـ local notifications
//     const androidSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const initSettings = InitializationSettings(android: androidSettings);

//     await _localNotifications.initialize(
//       initSettings,
//       // اختياري: لو بدك تتعامل مع الضغط على الإشعار
//       // onDidReceiveNotificationResponse: (details) { ... },
//     );

//     // الاستماع للرسائل
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

//     // الرسالة اللي فتحت التطبيق من حالة terminated
//     final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _handleMessageOpenedApp(initialMessage);
//     }

//     // طباعة التوكن للـ debug
//     final token = await FirebaseMessaging.instance.getToken();
//     developer.log('FCM Token: $token');

//     // مهم: استمع لتغيير التوكن (يُنادى عند كل startup + عند التغيير)
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       developer.log('FCM Token Refreshed: $newToken');
//       // هنا ممكن تنادي registerFCMToken لو المستخدم مسجل دخول
//     });
//   }

//   /// معالجة الرسائل في حالة Foreground
//   static void _handleForegroundMessage(RemoteMessage message) {
//     developer.log('Foreground FCM message received → ${message.messageId}');

//     final title =
//         message.notification?.title ?? message.data['title'] as String?;
//     final body = message.notification?.body ?? message.data['body'] as String?;

//     if (title == null || body == null) {
//       developer.log('Message missing title/body → ignored');
//       return;
//     }

//     _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'usdt Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//           icon: '@mipmap/ic_launcher',
//         ),
//       ),
//       payload: jsonEncode(message.data),
//     );
//   }

//   /// عند الضغط على الإشعار (background أو terminated → opened)
//   static void _handleMessageOpenedApp(RemoteMessage message) {
//     developer.log('App opened via notification → ${message.data}');
//     // هنا تضيف التنقل للصفحة المناسبة حسب الـ data
//     // مثال: Get.toNamed('/order-details', arguments: message.data);
//   }

//   /// تسجيل التوكن في الباك إند (تُنادى عادة بعد تسجيل الدخول أو تغيير اللغة)
//   static Future<void> registerFCMToken({
//     required bool loggedIn,
//     required String language,
//   }) async {
//     if (!loggedIn) return;

//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     final authToken = await Functions().getToken();
//     print('AUTH TOKEN => $authToken');
//     print('FCM TOKEN => $fcmToken');

//     if (fcmToken == null || authToken == null) {
//       print('❌ TOKEN NULL');
//       return;
//     }

//     final dioClient = dio.Dio();

//     final response = await dioClient.post(
//       'https://api.7awalaty.com/notifications/register-token',
//       data: {'token': fcmToken, 'language': language, 'platform': 'android'},
//       options: dio.Options(
//         headers: {
//           'Authorization': 'Bearer $authToken',
//           'Content-Type': 'application/json',
//         },
//       ),
//     );
//     print("fcmmmmmmmmmmmmmmmmmmmmmmmmmmmmm$fcmToken");
//     print(response.data);
//     print('✅ FCM TOKEN REGISTERED');
//   }
// }

// /// Background / Terminated handler (يجب أن يكون top-level أو static)
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   final title = message.notification?.title ?? message.data['title'] as String?;
//   final body = message.notification?.body ?? message.data['body'] as String?;

//   if (title == null || body == null) return;

//   final local = FlutterLocalNotificationsPlugin();

//   // القناة بتكون موجودة أصلاً (من الـ init) لكن عشان السلامة
//   await local
//       .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin
//       >()
//       ?.createNotificationChannel(Notifications._channel);

//   await local.show(
//     DateTime.now().millisecondsSinceEpoch ~/ 1000,
//     title,
//     body,
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'high_importance_channel',
//         'usdt Notifications',
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: '@mipmap/ic_launcher',
//       ),
//     ),
//   );
// }
// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer' as developer;

// import 'package:dio/dio.dart' as dio;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:hawwel/constans/token.dart';
// import 'package:hawwel/featue/notifation/notifacation_view.dart';
// import 'package:hawwel/main.dart';

// class Notifications {
//   // هذا الـ Stream هو المسؤول عن إرسال البيانات للشاشات وهي مفتوحة
//   static final StreamController<Map<String, dynamic>> _onMessageStream =
//       StreamController<Map<String, dynamic>>.broadcast();

//   static Stream<Map<String, dynamic>> get onMessageStream =>
//       _onMessageStream.stream;

//   static final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'usdt Notifications',
//     description: 'Important notifications for usdt',
//     importance: Importance.max,
//   );

//   /// ================= INIT =================
//   static Future<void> init() async {
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(_channel);

//     const androidSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const initSettings = InitializationSettings(android: androidSettings);

//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) {
//         if (details.payload == null) return;
//         final data = jsonDecode(details.payload!);
//         _navigateFromData(data);
//       },
//     );

//     // الاستماع للإشعارات والتطبيق مفتوح
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _navigateFromData(message.data);
//     });

//     final token = await FirebaseMessaging.instance.getToken();
//     developer.log('FCM Token: $token');
//   }

//   /// ================= FOREGROUND (هنا التعديل للطباعة) =================
//   static void _handleForegroundMessage(RemoteMessage message) {
//     // 1. طباعة البيانات فور وصولها للتحقق منها في الـ Console
//     print('=========================================');
//     print('🔔 إشعار جديد وصل (Foreground)');
//     print('📦 البيانات (Data Payload): ${message.data}');
//     print('=========================================');

//     // 2. إرسال البيانات عبر الـ Stream لكي تستقبلها شاشة الـ Confirm وتنتقل تلقائياً
//     _onMessageStream.add(message.data);

//     final title =
//         message.notification?.title ?? message.data['title'] ?? 'تنبيه جديد';
//     final body =
//         message.notification?.body ??
//         message.data['body'] ??
//         'لديك تحديث جديد في العملية';

//     _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'usdt Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//           icon: '@mipmap/ic_launcher',
//         ),
//       ),
//       payload: jsonEncode(message.data),
//     );
//   }

//   /// ================= NAVIGATION =================
//   static void _navigateFromData(Map<String, dynamic> data) {
//     // إذا ضغط المستخدم على الإشعار، يتم توجيهه لصفحة الإشعارات العامة
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(builder: (_) => const Notifation()),
//       );
//     });
//   }

//   /// ================= REGISTER TOKEN =================
//   static Future<void> registerFCMToken({
//     required bool loggedIn,
//     required String language,
//   }) async {
//     if (!loggedIn) return;

//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     final authToken = await Functions().getToken();

//     if (fcmToken == null || authToken == null) return;

//     final dioClient = dio.Dio();

//     try {
//       final response = await dioClient.post(
//         'https://api.7awalaty.com/notifications/register-token',
//         data: {'token': fcmToken, 'language': language, 'platform': 'android'},
//         options: dio.Options(
//           headers: {
//             'Authorization': 'Bearer $authToken',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );
//       print("✅ FCM TOKEN REGISTERED SUCCESSFULLY");
//       print("Token: $fcmToken");
//       print("Token: ${response.data}");
//       print("Token: ${response.statusCode}");
//       print("Token: ${response.statusMessage}");
//     } catch (e) {
//       print("❌ Error registering token: $e");
//     }
//   }
// }

// /// ================= BACKGROUND HANDLER =================
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   // طباعة للـ Background (تظهر في الـ Logcat)
//   print('📩 Background Message: ${message.data}');

//   final title = message.notification?.title ?? message.data['title'] ?? 'تنبيه';
//   final body =
//       message.notification?.body ?? message.data['body'] ?? 'تحديث جديد';

//   final local = FlutterLocalNotificationsPlugin();
//   await local.show(
//     DateTime.now().millisecondsSinceEpoch ~/ 1000,
//     title,
//     body,
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'high_importance_channel',
//         'usdt Notifications',
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: '@mipmap/ic_launcher',
//       ),
//     ),
//   );
// }
// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer' as developer;

// import 'package:dio/dio.dart' as dio;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:hawwel/constans/token.dart';
// import 'package:hawwel/featue/notifation/notifacation_view.dart';
// import 'package:hawwel/main.dart';

// class Notifications {
//   static final StreamController<Map<String, dynamic>> _onMessageStream =
//       StreamController<Map<String, dynamic>>.broadcast();

//   static Stream<Map<String, dynamic>> get onMessageStream =>
//       _onMessageStream.stream;

//   static final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'usdt Notifications',
//     description: 'Important notifications for usdt',
//     importance: Importance.max,
//   );

//   /// ================= INIT =================
//   static Future<void> init() async {
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//           alert: false,
//           badge: false,
//           sound: false,
//         );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(_channel);

//     const androidSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const initSettings = InitializationSettings(android: androidSettings);

//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) {
//         if (details.payload == null) return;
//         final data = jsonDecode(details.payload!);
//         _navigateFromData(data);
//       },
//     );

//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(
//       (message) => _navigateFromData(message.data),
//     );

//     final token = await FirebaseMessaging.instance.getToken();
//     developer.log('FCM Token: $token');
//   }

//   /// ================= HELPERS (تنسيق النص للبرداية) =================
//   // static String _formatBody(
//   //   Map<String, dynamic> data, {
//   //   String? notificationBody,
//   // }) {
//   //   // 1. جلب النص الخام (إما من الإشعار نفسه أو من الـ data)
//   //   String body = notificationBody ?? data['body'] ?? "";

//   //   // 2. استخراج القيم من الـ data
//   //   final String amount = data['amount']?.toString() ?? "";
//   //   final String symbol = data['symbol']?.toString() ?? "";
//   //   final String address = data['address']?.toString() ?? "";
//   //   final String network = data['network']?.toString() ?? "";

//   //   // 3. استبدال الأكواد بالقيم الحقيقية
//   //   body = body.replaceAll('{{amount}}', amount);
//   //   body = body.replaceAll('{{symbol}}', symbol);
//   //   body = body.replaceAll('{{address}}', address);
//   //   body = body.replaceAll('{{network}}', network);

//   //   // 4. تنسيق مخصص بناءً على المحتوى (مثال للإيداع)
//   //   if (body.contains("Amount Deposit") || body.contains("إيداع")) {
//   //     return " تم إيداع: $amount $symbol\n الشبكة: $network\n العنوان: $address";
//   //   }

//   //   return body.isEmpty ? "لديك تنبيه جديد" : body;
//   // }
// static String _formatBody(
//     Map<String, dynamic> rawData, {
//     String? notificationBody,
//   }) {
//     // 1. تحديد المصدر الحقيقي للبيانات (amount, symbol, الخ)
//     Map<String, dynamic> nestedData = {};

//     if (rawData.containsKey('data')) {
//       var innerData = rawData['data'];
//       if (innerData is String) {
//         try {
//           nestedData = jsonDecode(innerData); // إذا كانت قادمة كنص JSON
//         } catch (e) {
//           nestedData = rawData;
//         }
//       } else if (innerData is Map) {
//         nestedData = Map<String, dynamic>.from(innerData); // إذا كانت Map جاهزة
//       }
//     } else {
//       nestedData = rawData; // إذا كانت البيانات في المستوى الأول
//     }

//     // 2. جلب النص الخام وتجهيز المتغيرات
//     String body = notificationBody ?? rawData['body'] ?? "";
//     final String amount = (nestedData['amount'] ?? rawData['amount'] ?? "").toString();
//     final String symbol = (nestedData['symbol'] ?? rawData['symbol'] ?? "").toString();
//     final String address = (nestedData['address'] ?? rawData['address'] ?? "").toString();
//     final String network = (nestedData['network'] ?? rawData['network'] ?? "").toString();

//     // 3. عملية الاستبدال (Replace)
//     body = body.replaceAll('{{amount}}', amount);
//     body = body.replaceAll('{{symbol}}', symbol);
//     body = body.replaceAll('{{address}}', address);
//     body = body.replaceAll('{{network}}', network);

//     // 4. التنسيق الشرطي (للتأكد من العرض الجميل في البرداية)
//     if (body.contains("Amount Deposit") || body.contains("إيداع") || amount.isNotEmpty) {
//       return "💰 تم إيداع: $amount $symbol\n🌐 الشبكة: $network\n📍 العنوان: $address";
//     }

//     return body.isEmpty ? "لديك تنبيه جديد" : body;
//   }
//   /// ================= FOREGROUND (أثناء فتح التطبيق) =================
//   static void _handleForegroundMessage(RemoteMessage message) {
//     final data = message.data;
//     _onMessageStream.add(data);

//     _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       message.notification?.title ?? data['title'] ?? 'تنبيه جديد',
//       _formatBody(
//         data,
//         notificationBody: message.notification?.body,
//       ), // تنسيق النص
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'usdt Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//           icon: '@mipmap/ic_launcher',
//           color: Colors.white,
//           largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
//         ),
//       ),
//       payload: jsonEncode(data),
//     );
//   }

//   static void _navigateFromData(Map<String, dynamic> data) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(builder: (_) => const Notifation()),
//       );
//     });
//   }

//   static Future<void> registerFCMToken({
//     required bool loggedIn,
//     required String language,
//   }) async {
//     if (!loggedIn) return;
//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     final authToken = await Functions().getToken();
//     if (fcmToken == null || authToken == null) return;
//     try {
//       await dio.Dio().post(
//         'https://api.7awalaty.com/notifications/register-token',
//         data: {'token': fcmToken, 'language': language, 'platform': 'android'},
//         options: dio.Options(headers: {'Authorization': 'Bearer $authToken'}),
//       );
//       print("✅ FCM TOKEN REGISTERED");
//     } catch (e) {
//       print("❌ Error: $e");
//     }
//   }
// }

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   // منع التكرار (مهم جداً)
//   if (message.notification != null) return;

//   final Map<String, dynamic> rawData = message.data;
//   final local = FlutterLocalNotificationsPlugin();

//   // معالجة النص باستخدام الدالة المطورة
//   final String formattedBody = Notifications._formatBody(
//     rawData,
//     notificationBody: rawData['body'],
//   );

//   const androidDetails = AndroidNotificationDetails(
//     'high_importance_channel',
//     'usdt Notifications',
//     importance: Importance.max,
//     priority: Priority.high,
//     icon: '@mipmap/ic_launcher',
//     // هذا السطر هو السر ليظهر النص كاملاً (أكثر من سطر) في الخلفية
//     styleInformation: BigTextStyleInformation(''),
//   );

//   await local.show(
//     DateTime.now().millisecondsSinceEpoch ~/ 1000,
//     rawData['title'] ?? 'Transfer Process',
//     formattedBody,
//     const NotificationDetails(android: androidDetails),
//     payload: jsonEncode(rawData),
//   );
// }

/// ================= BACKGROUND HANDLER (عند إغلاق التطبيق) =================
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   final data = message.data;
//   final local = FlutterLocalNotificationsPlugin();

//   await local.show(
//     DateTime.now().millisecondsSinceEpoch ~/ 1000,
//     message.notification?.title ?? data['title'] ?? 'تنبيه',
//     Notifications._formatBody(data, notificationBody: message.notification?.body), // تنسيق النص في الخلفية
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'high_importance_channel',
//         'usdt Notifications',
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: '@mipmap/ic_launcher',
//         color: Colors.white,
//         largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
//       ),
//     ),
//     payload: jsonEncode(data),
//   );
// }
//////////////////////////////////////////////////////////////
library;

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer' as developer;

// import 'package:dio/dio.dart' as dio;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:hawwel/constans/token.dart';
// import 'package:hawwel/featue/notifation/notifacation_view.dart';
// import 'package:hawwel/main.dart';

// class Notifications {
//   static final StreamController<Map<String, dynamic>> _onMessageStream =
//       StreamController<Map<String, dynamic>>.broadcast();

//   static Stream<Map<String, dynamic>> get onMessageStream =>
//       _onMessageStream.stream;

//   static final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'usdt Notifications',
//     description: 'Important notifications for usdt',
//     importance: Importance.max,
//   );

//   static Future<void> init() async {
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//           alert: false,
//           badge: false,
//           sound: false,
//         );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(_channel);

//     const androidSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const initSettings = InitializationSettings(android: androidSettings);

//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) {
//         if (details.payload == null) return;
//         final data = jsonDecode(details.payload!);
//         _navigateFromData(data);
//       },
//     );

//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(
//       (message) => _navigateFromData(message.data),
//     );

//     final token = await FirebaseMessaging.instance.getToken();
//     developer.log('FCM Token: $token');
//   }

//   static String _formatBody(
//     Map<String, dynamic> rawData, {
//     String? notificationBody,
//   }) {
//     // 1. استخراج البيانات المختبئة (nested data)
//     Map<String, dynamic> nestedData = {};
//     if (rawData.containsKey('data')) {
//       var inner = rawData['data'];
//       if (inner is String) {
//         try {
//           nestedData = jsonDecode(inner);
//         } catch (e) {
//           nestedData = rawData;
//         }
//       } else if (inner is Map) {
//         nestedData = Map<String, dynamic>.from(inner);
//       }
//     } else {
//       nestedData = rawData;
//     }

//     // 2. النص الخام
//     String body = notificationBody ?? rawData['body'] ?? "";

//     // 3. القيم (دعم المباشر والفرعي)
//     final String amount = (nestedData['amount'] ?? rawData['amount'] ?? "")
//         .toString();
//     final String symbol = (nestedData['symbol'] ?? rawData['symbol'] ?? "")
//         .toString();
//     final String address = (nestedData['address'] ?? rawData['address'] ?? "")
//         .toString();
//     final String network = (nestedData['network'] ?? rawData['network'] ?? "")
//         .toString();

//     // 4. الاستبدال
//     body = body.replaceAll('{{amount}}', amount);
//     body = body.replaceAll('{{symbol}}', symbol);
//     body = body.replaceAll('{{address}}', address);
//     body = body.replaceAll('{{network}}', network);

//     // 5. التنسيق الجمالي
//     if (body.contains("Amount Deposit") ||
//         body.contains("إيداع") ||
//         amount.isNotEmpty) {
//       return " تم إيداع: $amount $symbol\n الشبكة: $network\n العنوان: $address";
//     }

//     return body.isEmpty ? "لديك تنبيه جديد" : body;
//   }

//   static void _handleForegroundMessage(RemoteMessage message) {
//     final data = message.data;
//     _onMessageStream.add(data);

//     _localNotifications.show(
//       message.hashCode,
//       message.notification?.title ?? data['title'] ?? 'تنبيه جديد',
//       _formatBody(data, notificationBody: message.notification?.body),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'usdt Notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//           icon: '@mipmap/ic_launcher',
//           styleInformation: BigTextStyleInformation(''),
//         ),
//       ),
//       payload: jsonEncode(data),
//     );
//   }

//   static void _navigateFromData(Map<String, dynamic> data) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(builder: (_) => const Notifation()),
//       );
//     });
//   }

//   static Future<void> registerFCMToken({
//     required bool loggedIn,
//     required String language,
//   }) async {
//     if (!loggedIn) return;
//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     final authToken = await Functions().getToken();
//     if (fcmToken == null || authToken == null) return;
//     try {
//       await dio.Dio().post(
//         'https://api.7awalaty.com/notifications/register-token',
//         data: {'token': fcmToken, 'language': language, 'platform': 'android'},
//         options: dio.Options(headers: {'Authorization': 'Bearer $authToken'}),
//       );
//     } catch (e) {
//       developer.log("❌ Error: $e");
//     }
//   }
// }

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   // ملاحظة: بما أننا لا نتحكم في السيرفر، سيظهر إشعار النظام بالأكواد أولاً.
//   // سنحاول هنا عرض إشعار "فوقه" بالبيانات المنسقة.

//   final Map<String, dynamic> rawData = message.data;
//   final local = FlutterLocalNotificationsPlugin();

//   final String formattedBody = Notifications._formatBody(
//     rawData,
//     notificationBody: message.notification?.body ?? rawData['body'],
//   );

//   await local.show(
//     message.hashCode, // استخدام نفس الهاش لمحاولة تحديث الإشعار الظاهر
//     message.notification?.title ?? rawData['title'] ?? 'Transfer Process',
//     formattedBody,
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'high_importance_channel',
//         'usdt Notifications',
//         importance: Importance.max,
//         priority: Priority.high,
//         icon: '@mipmap/ic_launcher',
//         styleInformation: BigTextStyleInformation(''),
//       ),
//     ),
//     payload: jsonEncode(rawData),
//   );
// }
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io'; // تم إضافة مكتبة الـ IO لمعرفة المنصة

import 'package:dio/dio.dart' as dio;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/featue/notifation/notifacation_view.dart';
import 'package:hawwel/featue/notifation/notification_navigation.dart';
import 'package:hawwel/featue/support_chat/data/unread_chat_state.dart';
import 'package:hawwel/featue/support_chat/support_chat_view.dart';
import 'package:hawwel/constans/widgets/floating_chat_button.dart'
    show CurrentRouteObserver;
import 'package:hawwel/main.dart';

class Notifications {
  static final StreamController<Map<String, dynamic>> _onMessageStream =
      StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get onMessageStream =>
      _onMessageStream.stream;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel_v2',
    'usdt Notifications',
    description: 'Important notifications for usdt',
    importance: Importance.max,
    playSound: true, // أضف هذا السطر
    enableVibration: true,
  );

  static void _safeLog(String message) {
    if (kDebugMode) {
      developer.log(message);
    }
  }

  static Future<String?> _safeGetFcmToken() async {
    try {
      if (!kIsWeb && Platform.isIOS) {
        // On iOS, APNS token can arrive a bit later than app startup.
        for (var i = 0; i < 8; i++) {
          final apns = await FirebaseMessaging.instance.getAPNSToken();
          if (apns != null && apns.isNotEmpty) break;
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
      }
      return await FirebaseMessaging.instance.getToken();
    } on FirebaseException catch (e) {
      if (e.code == 'apns-token-not-set') {
        _safeLog('APNS token is not ready yet; skipping FCM token for now.');
        return null;
      }
      rethrow;
    } catch (e) {
      // Some plugin versions may throw PlatformException-like errors here.
      if (e.toString().contains('apns-token-not-set')) {
        _safeLog('APNS token is not ready yet; skipping FCM token for now.');
        return null;
      }
      rethrow;
    }
  }

  static Future<void> init() async {
    // 1. طلب تصاريح الـ iOS
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. تفعيل الإشعارات والتطبيق مفتوح (Foreground) للـ iOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true, // غيرتها لـ true عشان يظهر الإشعار والتطبيق مفتوح في iOS
          badge: true,
          sound: true,
        );

    // إعدادات الأندرويد
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    if (!kIsWeb && Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // 3. إعدادات الـ iOS (Darwin)
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings, // إضافة إعدادات آيفون هنا
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == null) return;
        final data = jsonDecode(details.payload!);
        _navigateFromData(data);
      },
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _navigateFromData(message.data),
    );
    // FCM rotates tokens (reinstall, restore, periodic refresh); push the
    // new one straight to the server or every notification bounces.
    FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      registerFCMToken(
        loggedIn: Functions.loginStateNotifier.value,
        language: 'ar',
      );
    });
  }

  static String _formatBody(
    Map<String, dynamic> rawData, {
    String? notificationBody,
  }) {
    Map<String, dynamic> nestedData = {};
    if (rawData.containsKey('data')) {
      var inner = rawData['data'];
      if (inner is String) {
        try {
          nestedData = jsonDecode(inner);
        } catch (e) {
          nestedData = rawData;
        }
      } else if (inner is Map) {
        nestedData = Map<String, dynamic>.from(inner);
      }
    } else {
      nestedData = rawData;
    }

    final String rawBody = notificationBody ?? rawData['body'] ?? "";

    final String amount = (nestedData['amount'] ?? rawData['amount'] ?? "")
        .toString();
    final String paid = (nestedData['paid'] ?? rawData['paid'] ?? "")
        .toString();
    final String symbol = (nestedData['symbol'] ?? rawData['symbol'] ?? "")
        .toString();
    final String address = (nestedData['address'] ?? rawData['address'] ?? "")
        .toString();
    final String network = (nestedData['network'] ?? rawData['network'] ?? "")
        .toString();
    // Each KYC decision stores its reason under its own key; take whichever
    // one this notification carries.
    String blockingReason = "";
    for (final key in const [
      'blockingReason',
      'rejectionReason',
      'removeVerifyingReason',
    ]) {
      final value = (nestedData[key] ?? rawData[key] ?? "").toString().trim();
      if (value.isNotEmpty) {
        blockingReason = value;
        break;
      }
    }

    // The body sent from the backend is usually a translation key (e.g.
    // "notification_underpaid_deposit"), not literal text - resolve it the
    // same way the in-app notification list does, so the two never show
    // different wording for the same event.
    // getTextStatic (not getText) because this runs outside any widget's
    // build method, where Provider's context.watch would throw.
    final ctx = navigatorKey.currentContext;
    String body = ctx != null
        ? AppTranslations.getTextStatic(ctx, rawBody)
        : rawBody;

    body = body.replaceAll('{{amount}}', amount);
    body = body.replaceAll('{{paid}}', paid);
    body = body.replaceAll('{{symbol}}', symbol);
    body = body.replaceAll('{{address}}', address);
    body = body.replaceAll('{{network}}', network);
    if (body.contains('{{reasonClause}}')) {
      final isArabic =
          ctx != null && Localizations.localeOf(ctx).languageCode == 'ar';
      final reasonClause = blockingReason.isEmpty
          ? ''
          : (isArabic
              ? ' السبب: $blockingReason.'
              : ' Reason: $blockingReason.');
      body = body.replaceAll('{{reasonClause}}', reasonClause);
    }

    if (body.isEmpty && (rawBody.contains("Amount Deposit") || amount.isNotEmpty)) {
      return "تم استلام دفع خارجي: $amount $symbol\nالشبكة: $network\nالعنوان: $address";
    }

    return body.isEmpty ? "لديك تنبيه جديد" : body;
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    _safeLog('Notification received (foreground)');
    final data = message.data;
    _onMessageStream.add(data);

    // Re-derive the true count from the server rather than bump()-ing it -
    // the backend now sends this push for every chat message regardless of
    // whether the customer's socket is also live, so a bump() here could
    // double-count a message the socket already bumped for. Only valid to
    // do this synchronously here because the foreground handler runs in
    // the same isolate as the rest of the app; a background/terminated
    // push runs in a separate isolate with no access to this notifier, so
    // its count is picked up by the next resume-triggered refresh instead.
    if ((data['type'] ?? '') == 'chat_message') {
      ChatUnreadState.refreshFromServer();
      // The user is already looking at the live conversation - the socket
      // already rendered this message, so the OS banner would just be a
      // redundant alert for something on-screen.
      if (CurrentRouteObserver.currentRouteName.value ==
          SupportChatView.routeName) {
        return;
      }
    }

    _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? data['title'] ?? 'تنبيه جديد',
      _formatBody(data, notificationBody: message.notification?.body),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',

          styleInformation: const BigTextStyleInformation(''),
        ),
        // إضافة تفاصيل الـ iOS هنا لعرض الإشعار في الـ Foreground
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  static Future<void> _navigateFromData(Map<String, dynamic> data) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = navigatorKey.currentContext;
      if (ctx == null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const Notifation()),
        );
        return;
      }
      NotificationNavigation.openFromNotificationData(ctx, data).then((opened) {
        if (!opened) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => const Notifation()),
          );
        }
      });
    });
  }

  static Future<void> registerFCMToken({
    required bool loggedIn,
    required String language,
  }) async {
    if (!loggedIn) {
      return;
    }

    if (kIsWeb) {
      return;
    }

    _safeLog('FCM token registration attempted');

    try {
      final fcmToken = await _safeGetFcmToken();
      final authToken = await Functions().getToken();
      final platform = Platform.isIOS ? 'ios' : 'android';

      if (fcmToken == null || authToken == null) {
        _safeLog('FCM token registration failed');
        return;
      }

      final response = await dio.Dio().post(
        '${ApiService.baseURL}/notifications/register-token',
        data: {'token': fcmToken, 'language': language, 'platform': platform},
        options: dio.Options(
          headers: {'Authorization': 'Bearer $authToken'},
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _safeLog('FCM token registration succeeded');
      } else {
        _safeLog('FCM token registration failed');
      }
    } catch (_) {
      _safeLog('FCM token registration failed');
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final Map<String, dynamic> rawData = message.data;
  final local = FlutterLocalNotificationsPlugin();

  final String formattedBody = Notifications._formatBody(
    rawData,
    notificationBody: message.notification?.body ?? rawData['body'],
  );

  await local.show(
    message.hashCode,
    message.notification?.title ?? rawData['title'] ?? 'Transfer Process',
    formattedBody,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel_v2',
        'usdt Notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
        styleInformation: const BigTextStyleInformation(''),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
    payload: jsonEncode(rawData),
  );
}
