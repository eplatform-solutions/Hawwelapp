import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hawwel/constans/token.dart';

class ApiService {
  static const isStoreReview = bool.fromEnvironment(
    'IS_STORE_REVIEW',
    defaultValue: false,
  );

  // Production default.
  // Override explicitly for local/staging when needed, e.g.:
  // --dart-define=API_BASE_URL=https://api-stage.7awalaty.com
  static const baseURL = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.7awalaty.com',
  );

  /// Base URL of the **dashboard** API (where admin uploads live under `assets/`).
  /// Order payment-proof images are stored on the dashboard disk, not the mobile API.
  /// Build with: `--dart-define=DASHBOARD_API_URL=https://your-dash-api.example.com`
  static const dashboardBaseURL = String.fromEnvironment(
    'DASHBOARD_API_URL',
    defaultValue: 'https://admin-api.7awalaty.com',
  );

  /// Resolves a relative `assets/...` path to a full URL. Paths under
  /// `assets/images/orders/` or legacy `assets/images/transfers/` use [dashboardBaseURL] when it is set.
  static String resolveAssetUrl(String relativePath) {
    final t = relativePath.trim();
    if (t.isEmpty) return t;
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    final p = t.replaceFirst(RegExp(r'^/+'), '');
    final bool proofOnDashboard =
        p.startsWith('assets/images/orders/') ||
        p.startsWith('assets/images/transfers/') ||
        p.startsWith('assets/images/payment_methods/');
    final String rawBase = (proofOnDashboard && dashboardBaseURL.isNotEmpty)
        ? dashboardBaseURL
        : baseURL;
    final base = rawBase.replaceAll(RegExp(r'/$'), '');
    return '$base/$p';
  }

  final Dio dio;

  void _safeLog(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  Future<Map<String, dynamic>> _buildAuthHeaders({
    required bool needtoken,
    Map<String, dynamic>? extra,
    String? endpoint,
  }) async {
    final headers = <String, dynamic>{...?extra};
    headers['X-App-Review-Mode'] = isStoreReview ? 'true' : 'false';
    if (!needtoken) return headers;
    final token = await Functions().getToken();
    if (token == null || token.isEmpty) {
      _safeLog('Missing token for protected request: ${endpoint ?? "unknown"}');
      return headers;
    }
    headers['Authorization'] = 'Bearer $token';
    return headers;
  }

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
    _safeLog('GET $endpoint');
    final headers = await _buildAuthHeaders(
      needtoken: needtoken,
      endpoint: endpoint,
    );

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
    _safeLog('GET (search) $endpoint');
    final headers = await _buildAuthHeaders(
      needtoken: needtoken,
      endpoint: endpoint,
    );

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
    CancelToken? cancelToken,
    Duration? timeout,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appversion = packageInfo.version;
    _safeLog('POST $endpoint');

    final headers = await _buildAuthHeaders(
      needtoken: needtoken,
      endpoint: endpoint,
      extra: {'app-version': appversion},
    );

    final payload = _sanitizePayload(data);

    final response = await dio.post(
      endpoint,
      data: payload,
      options: Options(
        headers: headers,
        sendTimeout: timeout,
        receiveTimeout: timeout,
      ),
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<dynamic> postdata2({
    required String endpoint,
    required dynamic data,
    required bool needtoken,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appversion = packageInfo.version;
    _safeLog('POST multipart $endpoint');

    final headers = await _buildAuthHeaders(
      needtoken: needtoken,
      endpoint: endpoint,
      extra: {'app-version': appversion},
    );

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
    return response;
  }

  // 🔹 PUT
  Future<dynamic> put1({required String endpoint, required Map data}) async {
    final payload = _sanitizePayload(data);
    final headers = await _buildAuthHeaders(needtoken: true, endpoint: endpoint);
    final response = await dio.put(
      endpoint,
      data: payload,
      options: Options(headers: headers),
    );
    return response;
  }

  Future<dynamic> put({
    required String endpoint,
    required dynamic data,
    bool isFormData = false,
  }) async {
    final payload = _sanitizePayload(data);
    final headers = await _buildAuthHeaders(needtoken: true, endpoint: endpoint);

    final response = await dio.put(
      endpoint,
      data: payload,
      options: Options(
        contentType: isFormData || payload is FormData
            ? 'multipart/form-data'
            : 'application/json',
        headers: headers,
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
    final packageInfo = await PackageInfo.fromPlatform();
    final appversion = packageInfo.version;
    _safeLog('PATCH $endpoint');

    final headers = await _buildAuthHeaders(
      needtoken: needtoken,
      endpoint: endpoint,
      extra: {'app-version': appversion},
    );

    final payload = _sanitizePayload(data);

    final response = await dio.patch(
      endpoint,
      data: payload,
      options: Options(headers: headers),
    );
    return response;
  }

  Future<dynamic> delete({
    required String endpoint,
    dynamic data, // اختياري في حال كان السيرفر يتطلب body
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appversion = packageInfo.version;
    _safeLog('DELETE $endpoint');

    final payload = _sanitizePayload(data);

    final headers = await _buildAuthHeaders(
      needtoken: true,
      endpoint: endpoint,
      extra: {'app-version': appversion},
    );
    final response = await dio.delete(
      endpoint,
      data: payload,
      options: Options(headers: headers),
    );
    return response;
  }
}
