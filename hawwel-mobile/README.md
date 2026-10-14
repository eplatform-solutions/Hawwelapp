# Hawwel Mobile App

Flutter app for Hawwel (`com.hawwel.app`).

## Environments

### Production run

```bash
flutter run \
  --dart-define=API_BASE_URL=https://api.7awalaty.com \
  --dart-define=DASHBOARD_API_URL=https://admin-api.7awalaty.com
```

### Staging run

```bash
flutter run \
  --dart-define=API_BASE_URL=https://api-stage.7awalaty.com \
  --dart-define=DASHBOARD_API_URL=https://api-admin-dash-stage.7awalaty.com
```

## Store release builds

Production defaults are already set in `ApiService`. Still pass them explicitly for release builds:

### Android App Bundle

Requires `android/key.properties` + production keystore (no debug-signing fallback).

```bash
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://api.7awalaty.com \
  --dart-define=DASHBOARD_API_URL=https://admin-api.7awalaty.com
```

### iOS IPA

1. In Xcode: set your Apple `DEVELOPMENT_TEAM` for the Runner target.
2. Enable Push Notifications capability if not already active.
3. Add real `ios/Runner/GoogleService-Info.plist` from Firebase Console (see example file).
4. Align `lib/firbeas/firbeas_option.dart` iOS `appId` with `GOOGLE_APP_ID`.
5. Upload APNs Auth Key (`.p8`) to Firebase Cloud Messaging.

```bash
flutter build ipa --release \
  --dart-define=API_BASE_URL=https://api.7awalaty.com \
  --dart-define=DASHBOARD_API_URL=https://admin-api.7awalaty.com
```

### Store-review mode (optional)

```bash
--dart-define=IS_STORE_REVIEW=true
```

## Brand assets / icons / splash

Source files live under `asset/brand/`.

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Security notes

- Do not hardcode secrets or staging URLs in widgets/repositories.
- Keep API URLs in `dart-define` values per environment.
- Never commit `.env`, private keys, `key.properties`, or service-account credentials.
- Keep a secure offline backup of the Play upload keystore.
