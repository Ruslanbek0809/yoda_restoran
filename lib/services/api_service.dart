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
      // log.v('RESPONSE: api/slider/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_slider) {
          _sliders.add(SliderModel.fromJson(_slider));
        });
      }
      return _sliders;
    } catch (error) {
      log.v('ERROR on api/slider/ :$error');
      rethrow;
    }
  }

  Future<List<MainCategory>> getMainCats() async {
    List<MainCategory> _mainCategories = [];
    try {
      Response response = await _apiRoot.dio.get('api/maincategories/');
      // log.v('RESPONSE: api/maincategories/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_mainCategory) {
          _mainCategories.add(MainCategory.fromJson(_mainCategory));
        });
      }
      return _mainCategories;
    } catch (error) {
      log.v('ERROR on api/maincategories/ :$error');
      rethrow;
    }
  }

  Future<List<Restaurant>> getRandomRess() async {
    List<Restaurant> _randomRestaurants = [];
    try {
      Response response = await _apiRoot.dio.get('api/restaurants/');
      // log.v('RESPONSE: api/restaurants/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_randomRestaurant) {
          _randomRestaurants.add(Restaurant.fromJson(_randomRestaurant));
        });
      }
      return _randomRestaurants;
    } catch (error) {
      log.v('ERROR on api/restaurants/ :$error');
      rethrow;
    }
  }

  Future<List<Promoted>> getProms() async {
    List<Promoted> _promotedList = [];
    try {
      Response response = await _apiRoot.dio.get('api/promoted/');
      // log.v('RESPONSE: api/promoted/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_promoted) {
          _promotedList.add(Promoted.fromJson(_promoted));
        });
      }
      return _promotedList;
    } catch (error) {
      log.v('ERROR on api/promoted/ :$error');
      rethrow;
    }
  }

  Future<List<Restaurant>> getSelectedMainCats(
      List<int> _selectedMainCats) async {
    List<Restaurant> _selectedMainCatRestaurants = [];
    Map<String, dynamic> _queryPars = {};
    _queryPars = {
      for (int _selectedMainCat in _selectedMainCats)
        'mainCat': _selectedMainCat
    }; // CREATES new map list => 'mainCat': 1, 'mainCat': 2

    try {
      Response response = await _apiRoot.dio
          .get('api/restaurants/', queryParameters: _queryPars);

      if (response.data != null) {
        response.data.forEach((_promoted) {
          _selectedMainCatRestaurants.add(Restaurant.fromJson(_promoted));
        });
      }
      return _selectedMainCatRestaurants;
    } catch (error) {
      log.v('ERROR on api/promoted/ :$error');
      rethrow;
    }
  }

  //------------------ RESTAURANT APIS ---------------------//

  Future<List<ResCategory>> getResCatsWithMeals(int restaurantId) async {
    List<ResCategory> _resCategories = [];
    try {
      // Response response =
      //     await _apiRoot.dio.get('api/categories?restaurant=$restaurantId');
      Response response = await _apiRoot.dio.get('api/categories/',
          queryParameters: {'restaurant': restaurantId});
      // log.v('RESPONSE: api/categories/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_resCategory) {
          _resCategories.add(ResCategory.fromJson(_resCategory));
        });
      }
      return _resCategories;
    } on DioError catch (error) {
      log.v(error);
      // log.v(
      //     'ERROR on api/categories/ :${error.response!.statusCode} and ${error.response!.data}');
      rethrow;
    }
  }
}
