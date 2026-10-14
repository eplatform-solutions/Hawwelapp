import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:usdt/constans/token.dart';

class ApiService {
  // Dev sync default:
  // Mobile API (shared DB with dashboard via npm run dev:sync) => 127.0.0.1:3030
  // Override to staging when needed:
  // --dart-define=API_BASE_URL=https://api-stage.7awalaty.com
  static const baseURL = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.7awalaty.com',
  );

  /// Base URL of the **dashboard** API (where admin uploads live under `assets/`).
  /// Transfer payment-proof images are stored on the dashboard disk, not the mobile API.
  /// Build with: `--dart-define=DASHBOARD_API_URL=https://your-dash-api.example.com`
  static const dashboardBaseURL = String.fromEnvironment(
    'DASHBOARD_API_URL',
    defaultValue: 'https://admin-api.7awalaty.com',
  );

  /// Resolves a relative `assets/...` path to a full URL. Paths under
  /// `assets/images/transfers/` use [dashboardBaseURL] when it is set.
  static String resolveAssetUrl(String relativePath) {
    final t = relativePath.trim();
    if (t.isEmpty) return t;
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    final p = t.replaceFirst(RegExp(r'^/+'), '');
    final bool proofOnDashboard = p.startsWith('assets/images/transfers/');
    final String rawBase = (proofOnDashboard && dashboardBaseURL.isNotEmpty)
        ? dashboardBaseURL
        : baseURL;
    final base = rawBase.replaceAll(RegExp(r'/$'), '');
    return '$base/$p';
  }

  final Dio dio;

  dynamic _sanitizePayload(dynamic data) {
    if (data == null) return {};
    if (data is Map) {
      final cleaned = <String, dynamic>{};
      data.forEach((key, value) {
        if (value != null) cleaned[key.toString()] = value;
      });
      return cleaned;
    }
    return data;
  }

  Map<String, dynamic>? _sanitizeQuery(Map<String, dynamic>? query) {
    if (query == null) return null;
    final cleaned = <String, dynamic>{};
    query.forEach((key, value) {
      if (value != null) cleaned[key] = value;
    });
    return cleaned.isEmpty ? null : cleaned;
  }

  ApiService({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: baseURL,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    );
  }

  // 🔹 GET
  Future<dynamic> get({required String endpoint, bool needtoken = true}) async {
    String? token = await Functions().getToken();

    log('🔹 GET $baseURL$endpoint');

    final headers = <String, dynamic>{};
    if (needtoken && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await dio.get(
      endpoint,
      options: Options(headers: headers),
    );

    return response;
  }

  Future<dynamic> getsearch({
    required String endpoint,
    bool needtoken = true,
    Map<String, dynamic>? queryParameters, // إضافة هذا السطر
  }) async {
    String? token = await Functions().getToken();

    // تسجيل الرابط مع البراميترز للتأكد من صحتها في الـ Log
    log('🔹 GET $baseURL$endpoint | Params: $queryParameters');

    final headers = <String, dynamic>{};
    if (needtoken && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final cleanedQuery = _sanitizeQuery(queryParameters);

    final response = await dio.get(
      endpoint,
      queryParameters: cleanedQuery, // تمرير البراميترز هنا لـ Dio
      options: Options(headers: headers),
    );

    return response;
  }

  // 🔹 POST
  Future<dynamic> postdata({
    required String endpoint,
    required dynamic data,
    required bool needtoken,
  }) async {
    String? token = await Functions().getToken();
    final packageInfo = await PackageInfo.fromPlatform();
    final appversion = packageInfo.version;

    log("📤 POST → $baseURL$endpoint");
    log("📦 DATA → $data");

    final headers = {
      'app-version': appversion,
      if (needtoken) 'Authorization': 'Bearer $token',
    };

    final payload = _sanitizePayload(data);

    final response = await dio.post(
      endpoint,
      data: payload,
      options: Options(headers: headers),
    );

    log("✅ RESPONSE: ${response.data}");
    return response;
  }

  Future<dynamic> postdata2({
    required String endpoint,
    required dynamic data,
    required bool needtoken,
  }) async {
    String? token = await Functions().getToken();
    final packageInfo = await PackageInfo.fromPlatform();
    final appversion = packageInfo.version;

    log("📤 POST → $baseURL$endpoint");
    log("📦 DATA → $data");

    final headers = {
      'app-version': appversion,
      if (needtoken) 'Authorization': 'Bearer $token',
    };

    final payload = _sanitizePayload(data);

    final response = await dio.post(
      endpoint,
      data: payload,
      options: Options(
        headers: headers,
        // 🔥 هذا هو الإصلاح الأساسي
        contentType: payload is FormData
            ? 'multipart/form-data'
            : 'application/json',
      ),
    );

    log("✅ RESPONSE: ${response.data}");
    return response;
  }

  // 🔹 PUT
  Future<dynamic> put1({required String endpoint, required Map data}) async {
    String? token = await Functions().getToken();
    final payload = _sanitizePayload(data);
    final response = await dio.put(
      endpoint,
      data: payload,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    log("✅ RESPONSE: ${response.data}");
    return response;
  }

  Future<dynamic> put({
    required String endpoint,
    required dynamic data,
    bool isFormData = false,
  }) async {
    String? token = await Functions().getToken();

    final payload = _sanitizePayload(data);

    final response = await dio.put(
      endpoint,
      data: payload,
      options: Options(
        contentType: isFormData || payload is FormData
            ? 'multipart/form-data'
            : 'application/json',
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return response;
  }

  // 🔹 PATCH (الإضافة الجديدة)
  Future<dynamic> patchdata({
    required String endpoint,
    required dynamic data,
    required bool needtoken,
  }) async {
    String? token = await Functions().getToken();
    final packageInfo = await PackageInfo.fromPlatform();
    final appversion = packageInfo.version;

    log("📤 PATCH → $baseURL$endpoint");
    log("📦 DATA → $data");

    final headers = {
      'app-version': appversion,
      if (needtoken) 'Authorization': 'Bearer $token',
    };

    final payload = _sanitizePayload(data);

    final response = await dio.patch(
      endpoint,
      data: payload,
      options: Options(headers: headers),
    );

    log("✅ PATCH RESPONSE: ${response.data}");
    return response;
  }

  Future<dynamic> delete({
    required String endpoint,
    dynamic data, // اختياري في حال كان السيرفر يتطلب body
  }) async {
    String? token = await Functions().getToken();
    final packageInfo = await PackageInfo.fromPlatform();
    final appversion = packageInfo.version;

    log("🗑️ DELETE → $baseURL$endpoint");
    if (data != null) log("📦 DATA → $data");

    final payload = _sanitizePayload(data);

    final response = await dio.delete(
      endpoint,
      data: payload,
      options: Options(
        headers: {'Authorization': 'Bearer $token', 'app-version': appversion},
      ),
    );

    log("✅ DELETE RESPONSE: ${response.data}");
    return response;
  }
}
