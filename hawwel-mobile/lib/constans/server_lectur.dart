import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:usdt/constans/api_servise.dart';
  
final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<Dio>(
    Dio(),
  );

  getIt.registerSingleton(ApiService(
    dio: getIt.get<Dio>(),
  ));
}
