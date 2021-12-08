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
    dio.options.baseUrl = Constants.baseUrlTm;
    dio.options.headers = _headers;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          print(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.resolve(response);
        },
        onError: (DioError err, ErrorInterceptorHandler handler) async {
          print(
              'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
          return handler.reject(err);
        },
      ),
    );
    log.i('DIO initialised');
  }
}
