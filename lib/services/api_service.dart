import 'package:dio/dio.dart';
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'api_root_service.dart';

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
    List<int> _selectedMainCats,
    bool alphabet,
    bool rating,
  ) async {
    List<Restaurant> _selectedMainCatRestaurants = [];
    String _queryPars = 'mainCat=${_selectedMainCats[0]}';
    for (int i = 1; i < _selectedMainCats.length; i++)
      _queryPars += '&mainCat=${_selectedMainCats[i]}'; // Workaround

    log.v('ApiService - $_queryPars, alphabet: $alphabet, rating: $rating');
    try {
      Response response = await _apiRoot.dio
          .get('api/restaurants? = $_selectedMainCats', queryParameters: {
        'alphabet': alphabet,
        'rating': rating,
      });
      // log.v('RESPONSE: api/restaurants? => ${response.data}');

      if (response.data != null)
        response.data.forEach((_promoted) {
          _selectedMainCatRestaurants.add(Restaurant.fromJson(_promoted));
        });

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

  //------------------ CART APIS ---------------------//

  Future<List<Meal>> getMoreMeals() async {
    List<Meal> _moreMeals = [];
    try {
      Response response = await _apiRoot.dio
          .get('api/restaurantMeals/', queryParameters: {'another': true});
      // log.v('RESPONSE: api/restaurantMeals/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_resCategory) {
          _moreMeals.add(Meal.fromJson(_resCategory));
        });
      }

      return _moreMeals;
    } on DioError catch (error) {
      log.v(error);
      // log.v(
      //     'ERROR on api/restaurantMeals/ :${error.response!.statusCode} and ${error.response!.data}');
      rethrow;
    }
  }

  //------------------ CHECKOUT APIS ---------------------//

  Future<Promocode?> searchPromocode(String searchText, int resId) async {
    List<Promocode?> _promocodeList = [];
    try {
      Response response =
          await _apiRoot.dio.get('api/promocode/', queryParameters: {
        'search': searchText,
        'restaurant': resId,
      });
      log.v('RESPONSE: api/promocode/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_promocode) {
          _promocodeList.add(Promocode.fromJson(_promocode));
        });
      }

      return _promocodeList[0];
      // return _promocodeList.isEmpty ? Promocode(id: -1) : _promocodeList[0];
    } on DioError catch (error) {
      log.v(error);
      // log.v(
      //     'ERROR on api/promocode/ :${error.response!.statusCode} and ${error.response!.data}');
      rethrow;
    }
  }

  //------------------ SEARCH APIS ---------------------//

  Future<Promocode?> startMainSearch(String searchText) async {
    List<Promocode?> _promocodeList = [];
    try {
      Response response = await _apiRoot.dio
          .get('api/restaurants/', queryParameters: {'search': searchText});
      log.v('RESPONSE: api/restaurants/ => ${response.data}');

      // if (response.data != null) {
      //   response.data.forEach((_promocode) {
      //     _promocodeList.add(Promocode.fromJson(_promocode));
      //   });
      // }

      return _promocodeList[0];
    } on DioError catch (error) {
      log.v(error);
      // log.v(
      //     'ERROR on api/restaurants/ :${error.response!.statusCode} and ${error.response!.data}');
      rethrow;
    }
  }
}
