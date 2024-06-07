import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoda_res/services/sentry/sentry_module.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

import '../app/app.logger.dart';
import '../utils/utils.dart';

//*ApiRootService is used to initializeDio in both ApiService and UserApiService
class ApiRootService {
  final log = getLogger('ApiRootService');

  Dio dio = Dio();

  Future initDio() async {
    log.v('====== DIO STARTED initialising ======');
    Map<String, dynamic> _headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    //*Reason for usage of SharedPreferences is that ERROR is occuring in _userService.currentUser.accessToken (Stacked itself error related to services)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString(Constants.accessToken);
    log.v('ApiRootService ACCESS TOKEN: $accessToken');

    final _savedLocale =
        prefs.getString(Constants.savedLocale) ?? 'en_US'; // GETS saved locale.

    log.v('ApiRootService _savedLocale: $_savedLocale');

    if (accessToken != null)
      _headers["Authorization"] = "Bearer " + accessToken;

    dio.options.baseUrl =
        _savedLocale == 'en_US' ? Constants.baseUrlTk : Constants.baseUrlRu;
    dio.options.headers = _headers;

    dio.httpClientAdapter = NativeAdapter();

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // Do something before request is sent
      log.v(
          'REQUEST[${options.method}] => PATH: ${Constants.baseUrlTk}${options.path}');
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioException` object eg: `handler.reject(DioException)`
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioException` object eg: `handler.reject(DioException)`
    }, onError: (DioException error, handler) {
      log.v(
        'API Error: ${error.response?.statusCode} - ${error.response?.data}',
      );

      reportDioExceptionToSentry(
        error,
        additionalInfo: 'MY ERROR SENTRY => DIO INTERCEPTOR onError',
      );

      //TODO: Do any additional error handling if required
      return handler.next(error);
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    }));

    log.v('====== DIO ENDED initialising ====== => ${dio.options.baseUrl}');
  }
}
