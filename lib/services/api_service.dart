import 'package:dio/dio.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/api_root_service.dart';

class ApiService {
  final log = getLogger('ApiService');

  final _apiRoot = locator<ApiRootService>();

  //------------------ HOME APIS ---------------------//

  Future<List<SliderModel>> getSliders() async {
    List<SliderModel> _sliders = [];
    try {
      Response response = await _apiRoot.dio.get('api/sliders/');
      // log.i('RESPONSE: api/slider/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_slider) {
          _sliders.add(SliderModel.fromJson(_slider));
        });
      }
      return _sliders;
    } catch (error) {
      log.i('ERROR on api/slider/ :$error');
      rethrow;
    }
  }

  Future<List<MainCategory>> getMainCategories() async {
    List<MainCategory> _mainCategories = [];
    try {
      Response response = await _apiRoot.dio.get('api/maincategories/');
      // log.i('RESPONSE: api/maincategories/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_mainCategory) {
          _mainCategories.add(MainCategory.fromJson(_mainCategory));
        });
      }
      return _mainCategories;
    } catch (error) {
      log.i('ERROR on api/maincategories/ :$error');
      rethrow;
    }
  }

  Future<List<Restaurant>> getRandomRestorants() async {
    List<Restaurant> _randomRestaurants = [];
    try {
      Response response = await _apiRoot.dio.get('api/restaurants/');
      // log.i('RESPONSE: api/restaurants/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_randomRestaurant) {
          _randomRestaurants.add(Restaurant.fromJson(_randomRestaurant));
        });
      }
      return _randomRestaurants;
    } catch (error) {
      log.i('ERROR on api/restaurants/ :$error');
      rethrow;
    }
  }

  Future<List<Promoted>> getPromotedRestaurants() async {
    List<Promoted> _promotedList = [];
    try {
      Response response = await _apiRoot.dio.get('api/promoted/');
      // log.i('RESPONSE: api/promoted/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_promoted) {
          _promotedList.add(Promoted.fromJson(_promoted));
        });
      }
      return _promotedList;
    } catch (error) {
      log.i('ERROR on api/promoted/ :$error');
      rethrow;
    }
  }

  //------------------ RESTAURANT APIS ---------------------//

  Future<List<ResCategory>> getResCatsWithMeals(int restaurantId) async {
    List<ResCategory> _resCategories = [];
    try {
      Response response = await _apiRoot.dio
          .get('api/categories', queryParameters: {'restaurant': restaurantId});
      // log.i('RESPONSE: api/categories/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_resCategory) {
          _resCategories.add(ResCategory.fromJson(_resCategory));
        });
      }
      return _resCategories;
    } catch (error) {
      log.i('ERROR on api/categories/ :$error');
      rethrow;
    }
  }
}
