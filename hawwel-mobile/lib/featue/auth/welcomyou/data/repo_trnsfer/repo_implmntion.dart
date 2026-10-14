import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/failear.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_ressponse_transfer.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_transfer.dart';
import 'package:usdt/featue/auth/welcomyou/data/repo_trnsfer/repo.dart';

class TransferRepoImpl implements TransferRepo {
  final ApiService _apiService;

  TransferRepoImpl({required ApiService apiService}) : _apiService = apiService;

  // Future<Either<Failur, TransferResponseModel>> sendTransfer(
  //   TransferRequestModel model,
  // ) async {
  //   print('--- ⚡ بدء إرسال عملية  طلب جديدة ---');
  //   print('📦 بيانات الإرسال (model.toJson()): ${model.toJson()}');
  //   try {
  //     print('📤 إرسال طلب POST إلى /transfers/create...');
  //     final response = await _apiService.postdata(
  //       endpoint: '/transfers/by-parameter',
  //       data: model.toJson(),
  //       needtoken: true,
  //     );
  //     print('✅ استجابة API ناجحة:');
  //     print('الحالة (status code): ${response.statusCode}');
  //     print('البيانات الكاملة (response.data): ${response.data}');
  //     // التحقق من وجود "data" في الاستجابة
  //     final responseData = response.data['data'];
  //     if (responseData == null) {
  //       print('⚠️ خطأ: الحقل "data" غير موجود في الاستجابة!');
  //       return Left(
  //         ServierFailur('Invalid response: missing "data" field', 500),
  //       );
  //     }
  //     print('  بدء  طلب الاستجابة إلى TransferResponseModel...');
  //     print('البيانات المرسلة لـ fromJson: $responseData');
  //     final transfer = TransferResponseModel.fromJson(responseData);
  //     print('✅ تم إنشاء TransferResponseModel بنجاح:');
  //     print('  - رقم  الطلب: ${transfer.transferNumber}');
  //     print('  - الكمية: ${transfer.amount} ${transfer.symbol}');
  //     print('  - الحالة: ${transfer.status}');
  //     if (transfer.blockchainWallets?.isNotEmpty == true) {
  //       print('  - عناوين البلوك تشين:');
  //       for (var wallet in transfer.blockchainWallets!) {
  //         print('    • ${wallet.network}: ${wallet.address}');
  //       }
  //     }
  //     return Right(transfer);
  //   } catch (e, stackTrace) {
  //     print('💥 حدث خطأ أثناء إرسال  طلب:');
  //     print('الخطأ: $e');
  //     print('تتبع الخطأ (stack trace):\n$stackTrace');
  //     if (e is DioException) {
  //       print('نوع الخطأ: DioException');
  //       if (e.response != null) {
  //         print('كود الاستجابة: ${e.response?.statusCode}');
  //         print('بيانات الخطأ: ${e.response?.data}');
  //       }
  //       if (e.requestOptions != null) {
  //         print('الـ URL المطلوب: ${e.requestOptions.uri}');
  //         print('بيانات الطلب المرسلة: ${e.requestOptions.data}');
  //       }
  //       final failure = ServierFailur.fromDioError(e);
  //       print(
  //         '📤 إرجاع فشل من نوع DioException: ${failure.errMassage} (كود: ${failure.statusCode})',
  //       );
  //       return Left(failure);
  //     }
  //     final failure = ServierFailur(
  //       'Failed to send transfer: ${e.toString()}',
  //       500,
  //     );
  //     print('📤 إرجاع فشل عام: ${failure.errMassage}');
  //     return Left(failure);
  //   }
  // }
  String resolveMessage(dynamic msg, String lang) {
    if (msg == null) return 'حدث خطأ غير متوقع';

    // إذا الرسالة Map (ar / en)
    if (msg is Map) {
      return msg[lang] ?? msg['ar'] ?? msg['en'] ?? 'حدث خطأ غير متوقع';
    }

    // إذا الرسالة String
    if (msg is String) {
      return msg;
    }

    return 'حدث خطأ غير متوقع';
  }

  Future<Either<Failur, TransferResponseModel>> sendTransfer(
    TransferRequestModel model,
  ) async {
    print('--- ⚡ بدء إرسال عملية  طلب جديدة ---');
    print('📦 بيانات الإرسال (model.toJson()): ${model.toJson()}');

    try {
      print('📤 إرسال طلب POST إلى /transfers/by-parameter...');
      final response = await _apiService.postdata(
        endpoint: '/transfers/by-parameter',
        data: model.toJson(),
        needtoken: true,
      );

      print('✅ استجابة API وصلت');
      print('الحالة: ${response.statusCode}');
      print('البيانات: ${response.data}');

      // 🌐 جلب لغة التطبيق
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString("app_language") ?? "ar";
      print('🌐 لغة التطبيق: $lang');

      // ❌ في حال error = true
      if (response.data["error"] == true) {
        final errorMessage = resolveMessage(response.data["msg"], lang);

        print('❌ خطأ من السيرفر: $errorMessage');

        return Left(ServierFailur(errorMessage, response.statusCode ?? 400));
      }

      // ⚠️ التحقق من data
      final responseData = response.data["data"];
      if (responseData == null) {
        final errorMessage = resolveMessage(response.data["msg"], lang);

        print('⚠️ data غير موجودة');

        return Left(ServierFailur(errorMessage, 500));
      }

       
      print('🔄 طلب البيانات إلى TransferResponseModel...');
      final transfer = TransferResponseModel.fromJson(responseData);

      print('🎉 تم إنشاء الطلب بنجاح');
      print('رقم الطلب: ${transfer.transferNumber}');
      print('الكمية: ${transfer.amount} ${transfer.symbol}');
      print('الحالة: ${transfer.status}');

      if (transfer.blockchainWallets?.isNotEmpty == true) {
        print('عناوين البلوك تشين:');
        for (var wallet in transfer.blockchainWallets!) {
          print('• ${wallet.network}: ${wallet.address}');
        }
      }

      return Right(transfer);
    } catch (e, stackTrace) {
      print('💥 استثناء أثناء إرسال الطلب');
      print('الخطأ: $e');
      print('StackTrace:\n$stackTrace');

      if (e is DioException) {
        print('❌ DioException');

        // 🌐 جلب لغة التطبيق
        final prefs = await SharedPreferences.getInstance();
        final lang = prefs.getString("app_language") ?? "ar";

        String errorMessage = 'حدث خطأ غير متوقع';

        if (e.response?.data != null) {
          final msg = e.response?.data["msg"];

          // 🧠 نفس المنطق الذكي
          if (msg is Map) {
            errorMessage = msg[lang] ?? msg['ar'] ?? msg['en'] ?? errorMessage;
          } else if (msg is String) {
            errorMessage = msg;
          }
        }

        print('📛 رسالة الخطأ المترجمة: $errorMessage');

        return Left(ServierFailur(errorMessage, e.response?.statusCode ?? 400));
      }

      final failure = ServierFailur('Failed to send transfer', 500);

      return Left(failure);
    }
  }
}
