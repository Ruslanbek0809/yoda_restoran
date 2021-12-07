import 'package:dio/dio.dart';
import 'package:yoda_res/utils/utils.dart';

class ApiRootService {
  Dio dio = Dio();

  Future initDio() async {
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
  }

  // Future<Response> getData(
  //     {required String url, Map<String, dynamic>? queryParams}) async {
  //   await initDio();
  //   Response response = await dio.get(url, queryParameters: queryParams);
  //   return response;
  // }

  // Future<Response> deleteData(
  //     {required String url, Map<String, dynamic>? queryParams}) async {
  //   await initDio();
  //   Response response = await dio.delete(url, data: queryParams);
  //   return response;
  // }

  // Future<Response> patchDataWithForm(
  //     {required String url, FormData? formData}) async {
  //   await initDio();
  //   Response response = await dio.patch(url, data: formData);
  //   return response;
  // }

  // Future<Response> postDataWithForm(
  //     {required String url, FormData? formData}) async {
  //   await initDio();
  //   Response response = await dio.post(url, data: formData);
  //   return response;
  // }

  // Future<Response> putDataWithForm(
  //     {required String url, FormData? formData}) async {
  //   await initDio();
  //   Response response = await dio.put(url, data: formData);
  //   return response;
  // }
}
