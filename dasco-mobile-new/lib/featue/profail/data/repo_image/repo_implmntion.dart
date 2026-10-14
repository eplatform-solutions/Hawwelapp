import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/failear.dart';
import 'package:hawwel/featue/profail/data/repo_image/repo.dart';

 
class ImplementChangeImageRepo implements RepoChangeImage {
  final ApiService _api;

  ImplementChangeImageRepo({required ApiService apiService})
      : _api = apiService;

  @override
  Future<Either<Failur, String>> changeProfileImage(String filePath) async {
    try {
      final file = await MultipartFile.fromFile(filePath);

      final formData = FormData.fromMap({
        "profileImage": file,
      });

      final response = await _api.put(
        endpoint: "/users/change-profile-image",
        data: formData,
        isFormData: true,
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("DATA: ${response.data}");

      return const Right("Image Updated");
    } catch (e) {
      if (e is DioException) {
        return Left(ServierFailur.fromDioError(e));
      }
      return Left(ServierFailur(e.toString(), 500));
    }
  }
}
