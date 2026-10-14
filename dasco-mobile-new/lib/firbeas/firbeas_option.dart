import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Firebase options for Hawwel.
/// Android values must match `android/app/google-services.json`.
/// iOS values must be replaced from a real `GoogleService-Info.plist`
/// after registering the iOS app in Firebase Console.
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAN9NVexz27ixmrAsd7XsBhBVX_c5Mhtpo',
    appId: '1:129918768198:android:2750bb4e6ac17b65182647',
    messagingSenderId: '129918768198',
    projectId: 'hawel-aefe9',
    storageBucket: 'hawel-aefe9.firebasestorage.app',
  );

  /// TODO(store-release): Replace [appId] from Firebase Console /
  /// `ios/Runner/GoogleService-Info.plist` (GOOGLE_APP_ID) before App Store push QA.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAN9NVexz27ixmrAsd7XsBhBVX_c5Mhtpo',
    appId: '1:129918768198:ios:76d543e21d8f9c0e2a4b3c',
    messagingSenderId: '129918768198',
    projectId: 'hawel-aefe9',
    storageBucket: 'hawel-aefe9.firebasestorage.app',
    iosBundleId: 'com.hawwel.app',
  );
}
