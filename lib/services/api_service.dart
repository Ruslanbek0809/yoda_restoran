import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/services/api_root_service.dart';

class ApiService {
  final _apiRootService = locator<ApiRootService>();

  // Future<User> getUserProfile(int userId) async {
  //   var response = await _apiRootService.dio.get('$endpoint/users/$userId');
  //   return User.fromJson(json.decode(response.body));
  // }
}
