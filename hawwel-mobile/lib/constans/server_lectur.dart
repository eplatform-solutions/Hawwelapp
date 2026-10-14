import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hawwel/constans/api_servise.dart';
  
final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<Dio>(
    Dio(),
  );

  getIt.registerSingleton(ApiService(
    dio: getIt.get<Dio>(),
  ));
}
