import 'package:common_utilities/common_utilities.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants.dart';
import '../../data/network/api/api_service.dart';
import '../../data/network/api/multipart_api_service.dart';
import '../../data/network/interceptors/authorization_interceptor.dart';
import '../../data/network/interceptors/custom_log_interceptor.dart';
import '../../main.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(
    AuthorizationInterceptor authorizationInterceptor,
  ) {
    final Dio dio = Dio(
      BaseOptions(
        contentType: 'application/json',
        connectTimeout: 20000,
        sendTimeout: 20000,
      ),
    );

    dio.interceptors.add(authorizationInterceptor);
    dio.interceptors.add(CustomLogInterceptor(responseBody: true, logPrint: logger.d));

    return dio;
  }

  @lazySingleton
  ApiService apiService(Dio dio) => ApiService(dio);

  @lazySingleton
  MultipartApiService multipartApiService(Dio dio, EventBus eventBus) => MultipartApiService(
        dio,
        Constants.apiUrl,
        eventBus,
      );
}
