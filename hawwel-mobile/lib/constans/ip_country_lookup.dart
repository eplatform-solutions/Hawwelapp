import 'package:dio/dio.dart';

/// تقدير دولة الجهاز عبر عنوان IP (خدمات خارجية؛ قد تختلف الدقة مع VPN/بروكسي).
class IpCountryLookup {
  IpCountryLookup._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
      headers: const {'Accept': 'application/json'},
      validateStatus: (s) => s != null && s >= 200 && s < 500,
    ),
  );

  static String? _normalizeIso2(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().trim().toUpperCase();
    if (s.length == 2 && RegExp(r'^[A-Z]{2}$').hasMatch(s)) return s;
    return null;
  }

  /// ISO 3166-1 alpha-2 أو null عند الفشل.
  static Future<String?> fetchCountryIso2() async {
    final attempts = <Future<String?>>[
      _tryIpApiCo(),
      _tryGeoJs(),
      _tryIpWhoIs(),
    ];
    for (final a in attempts) {
      try {
        final c = await a;
        if (c != null) return c;
      } catch (_) {}
    }
    return null;
  }

  static Future<String?> _tryIpApiCo() async {
    final r = await _dio.get<dynamic>('https://ipapi.co/json/');
    final data = r.data;
    if (data is Map) {
      return _normalizeIso2(data['country_code'] ?? data['country']);
    }
    return null;
  }

  static Future<String?> _tryGeoJs() async {
    final r = await _dio.get<dynamic>('https://get.geojs.io/v1/ip/country.json');
    final data = r.data;
    if (data is Map) {
      return _normalizeIso2(data['country'] ?? data['country_code']);
    }
    return null;
  }

  static Future<String?> _tryIpWhoIs() async {
    final r = await _dio.get<dynamic>('https://ipwho.is/');
    final data = r.data;
    if (data is Map && data['success'] == true) {
      return _normalizeIso2(data['country_code']);
    }
    return null;
  }
}
