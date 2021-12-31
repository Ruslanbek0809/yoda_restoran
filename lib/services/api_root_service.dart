import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/utils/utils.dart';

/// ApiRootService is used to initializeDio in both ApiService and UserApiService
class ApiRootService {
  final log = getLogger('ApiRootService');

  Dio dio = Dio();

  Future initDio() async {
    log.v('====== DIO STARTED initialising ======');
    Map<String, dynamic> _headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    /// Reason for usage of SharedPreferences is that ERROR is occuring in _userService.currentUser.accessToken (Stacked itself error related to services)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString(Constants.accessToken);

    if (accessToken != null)
      _headers["Authorization"] = "Bearer " + accessToken;

    // dio.options.baseUrl =
    //     lang == 'tm' ? MyConstants.baseUrlTk : MyConstants.baseUrlRu;
    dio.options.baseUrl = Constants.baseUrlTk;
    dio.options.headers = _headers;

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // Do something before request is sent
      log.v(
          'REQUEST[${options.method}] => PATH: ${Constants.baseUrlTk}${options.path}');
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError e, handler) {
      // Do something with response error
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    }));

    log.v('====== DIO ENDED initialising ====== => ${dio.options.baseUrl}');
  }
}
