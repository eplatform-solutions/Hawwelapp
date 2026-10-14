import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/auth/forgeat_password/data/repo/forget_repo.dart';

class ImplmentRepoforgetpassword extends RepoForgetpassword {
  final ApiService _apiService;

  ImplmentRepoforgetpassword({required ApiService apiService})
    : _apiService = apiService;

  // @override
  // Future<Either<Failur, String>> forgetpassword({required String email}) async {
  //   try {
  //     log("📱 Forget attempt -> Email: $email");

  //     Response response = await _apiService.postdata(
  //       endpoint: "/auth/forget-password",
  //       data: {"email": email},
  //       needtoken: false,
  //     );

  //     log("✅ Response Status: ${response.statusCode}");
  //     log("✅ Response Data: ${response.data}");

  //     // 🔥 العملية ناجحة فعلياً
  //     if (response.statusCode == 200 && response.data["error"] == false) {
  //       // السيرفر يرجع session وليس token
  //       String? session = response.data["data"]?["session"];

  //       if (session == null || session.isEmpty) {
  //         return left(
  //           ServierFailur("لم يتم استلام رقم الجلسة من السيرفر", 400),
  //         );
  //       }

  //       log("🟢 Session received: $session");

  //       // فيك تخزّن السيشن إذا بدك
  //       // await Functions().setSession(session);

  //       return right(session); // رجّع session للـ Cubit
  //     }

  //     // ❌ العملية فشلت
  //     String errorMessage =
  //         response.data["msg"]?["ar"] ?? "حدث خطأ أثناء معالجة الطلب";

  //     return left(ServierFailur(errorMessage, response.statusCode ?? 500));
  //   } on DioException catch (e) {
  //     return left(ServierFailur.fromDioError(e));
  //   } catch (e) {
  //     return left(ServierFailur(e.toString(), 600));
  //   }
  // }
  // تعديل: إرجاع Map يحتوي msg و session
  @override
  Future<Either<Failur, Map<String, dynamic>>> forgetpassword({
    required String email,
  }) async {
    try {
      final value = email.trim();

final isPhone = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value);
final Map<String, dynamic> requestData = {
  if (isPhone) "mobilePhone": value else "email": value,
   
};
      Response response = await _apiService.postdata(
        endpoint: "/auth/forget-password",
        data: requestData,
        needtoken: false,
      );

      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";

      if (response.statusCode == 200 && response.data["error"] == false) {
        final session = response.data["data"]?["session"];
        return right({
          "msg": response.data["msg"]?[lang] ?? response.data["msg"]?["ar"],
          "session": session ?? "",
        });
      }

      return left(
        ServierFailur(
          response.data["msg"]?[lang] ?? "حدث خطأ",
          response.statusCode ?? 500,
        ),
      );
    } on DioException catch (e) {
      return left(ServierFailur.fromDioError(e));
    } catch (e) {
      return left(ServierFailur(e.toString(), 600));
    }
  }
}
