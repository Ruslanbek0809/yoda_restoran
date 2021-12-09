import 'package:dio/dio.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/api_root_service.dart';
import 'package:yoda_res/utils/utils.dart';

class ApiService {
  final log = getLogger('ApiService');

  final _apiRootService = locator<ApiRootService>();

  //------------------ HOME APIS ---------------------//

  Future<List<SliderModel>> getSliders() async {
    List<SliderModel> _sliders = [];
    try {
      Response response = await _apiRootService.dio.get('api/sliders/');
      log.i('RESPONSE: api/slider/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_slider) {
          _sliders.add(SliderModel.fromJson(_slider));
        });
      }
      return _sliders;
    } catch (error) {
      printLog('ERROR on api/slider/ :$error');
      rethrow;
    }
  }

  Future<List<MainCategory>> getMainCategories() async {
    List<MainCategory> _mainCategories = [];
    try {
      Response response = await _apiRootService.dio.get('api/maincategories/');
      log.i('RESPONSE: api/maincategories/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_mainCategory) {
          _mainCategories.add(MainCategory.fromJson(_mainCategory));
        });
      }
      return _mainCategories;
    } catch (error) {
      printLog('ERROR on api/slider/ :$error');
      rethrow;
    }
  }
}
