import 'package:dio/dio.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/utils/utils.dart';

/// ApiRootService is used to initializeDio in both ApiService and UserApiService
class ApiRootService {
  final log = getLogger('ApiRootService');
  Dio dio = Dio();

  Future initDio() async {
    log.i('Initialise DIO');
    Map<String, dynamic> _headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    // if (token != null) headers['Authorization'] = "Bearer $token";
    // dio.options.baseUrl =
    //     lang == 'tm' ? MyConstants.baseUrlTm : MyConstants.baseUrlRu;
    dio.options.baseUrl = Constants.baseUrlTk;
    dio.options.headers = _headers;

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // Do something before request is sent
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

    log.i('DIO initialised => ${dio.options.baseUrl}');
  }
}
