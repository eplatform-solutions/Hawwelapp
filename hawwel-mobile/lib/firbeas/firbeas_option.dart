import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// تم إنشاء هذا الملف يدوياً لربط تطبيق USDT بـ Firebase
/// البيانات مأخوذة من ملف google-services.json للأندرويد
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not configured for web in this project.',
      );
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  // هذه البيانات مأخوذة من الـ JSON الذي أرسلته
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAN9NVexz27ixmrAsd7XsBhBVX_c5Mhtpo',
    appId: '1:129918768198:android:ba2567db6e6fb4fb182647',
    messagingSenderId: '129918768198',
    projectId: 'hawel-aefe9',
    storageBucket: 'hawel-aefe9.firebasestorage.app',
  );

  // بيانات الـ iOS (استخدمنا نفس الـ Key والـ Project ID)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAN9NVexz27ixmrAsd7XsBhBVX_c5Mhtpo',
    // تنبيه: هذا الـ App ID هو الوحيد الذي قد يختلف، إذا لم يعمل الإشعار
    // اطلب من المهندس الـ iOS App ID الحقيقي.
    appId: '1:129918768198:ios:76d543e21d8f9c0e2a4b3c',
    messagingSenderId: '129918768198',
    projectId: 'hawel-aefe9',
    storageBucket: 'hawel-aefe9.firebasestorage.app',
    iosBundleId: 'com.hawwel.app', // تأكد أن هذا هو الـ Bundle ID الخاص بك
  );
}
