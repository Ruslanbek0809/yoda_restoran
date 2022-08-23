import 'package:dio/dio.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/services/services.dart';
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';

class ApiService {
  final log = getLogger('ApiService');

  final _apiRoot = locator<ApiRootService>();
  final _geolocatorService = locator<GeolocatorService>();

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

  // Future<List<Restaurant>> getRandomRess() async {
  //   log.v('My loc: ${_geolocatorService.locationPosition}');
  //   List<Restaurant> _randomRestaurants = [];
  //   try {
  //     Response response;
  //     if (_geolocatorService.locationPosition != null) {
  /// DEPRECATED after 2.3.0+35
  //       await _geolocatorService.getUserCurrentLocationOnly();
  //       response = await _apiRoot.dio.get(
  //         'api/restaurants/',
  //         queryParameters: {
  //           'markerY': _geolocatorService.locationPosition!.longitude,
  //           'markerX': _geolocatorService.locationPosition!.latitude,
  //         },
  //       );
  //     } else
  //       response = await _apiRoot.dio.get('api/restaurants/');
  //     // log.v('RESPONSE: api/restaurants/ => ${response.data}');

  //     if (response.data != null) {
  //       response.data.forEach((_randomRestaurant) {
  //         _randomRestaurants.add(Restaurant.fromJson(_randomRestaurant));
  //       });
  //     }
  //     return _randomRestaurants;
  //   } catch (error) {
  //     log.v('ERROR on api/restaurants/ :$error');
  //     rethrow;
  //   }
  // }

  /// HOME RESS PAG
  Future<void> getPaginatedRess(
    int page,
    Function(List<Restaurant>?, String?)? onSuccess,
  ) async {
    log.v('My loc: ${_geolocatorService.locationPosition}');
    List<Restaurant> _paginatedRestaurants = [];
    try {
      Response response;
      if (_geolocatorService.locationPosition != null) {
        /// DEPRECATED after 2.3.0+35
        // await _geolocatorService.getUserCurrentLocationOnly();
        response = await _apiRoot.dio.get(
          'api/paginatedRestaurants/',
          queryParameters: {
            'markerY': _geolocatorService.locationPosition!.longitude,
            'markerX': _geolocatorService.locationPosition!.latitude,
            'page': page,
          },
        );
      } else
        response =
            await _apiRoot.dio.get('api/paginatedRestaurants?page=$page');
      // log.v('RESPONSE: api/paginatedRestaurants/ => ${response.data}');

      if (response.data['results'] != null) {
        for (final _randomRestaurant in response.data['results'])
          _paginatedRestaurants.add(Restaurant.fromJson(_randomRestaurant));
      }
      onSuccess!(_paginatedRestaurants, response.data['next']);
    } catch (error) {
      log.v('ERROR on api/paginatedRestaurants/ :$error');
      rethrow;
    }
  }

  Future<List<Promoted>> getProms() async {
    log.v('My loc: ${_geolocatorService.locationPosition}');
    List<Promoted> _promotedList = [];
    try {
      Response response;
      if (_geolocatorService.locationPosition != null) {
        /// DEPRECATED after 2.3.0+35
        // await _geolocatorService.getUserCurrentLocationOnly();
        response = await _apiRoot.dio.get(
          'api/promoted/',
          queryParameters: {
            'markerY': _geolocatorService.locationPosition!.longitude,
            'markerX': _geolocatorService.locationPosition!.latitude,
          },
        );
      } else
        response = await _apiRoot.dio.get('api/promoted/');
      // log.v('RESPONSE: api/promoted/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_promoted) {
          _promotedList.add(Promoted.fromJson(_promoted));
        });
      }
      return _promotedList;
    } on DioError catch (error) {
      log.v('ERROR on api/promoted/ :${error.response}');
      rethrow;
    }
  }

  Future<List<Exclusive>> getExclusives() async {
    List<Exclusive> _exclusives = [];
    try {
      Response response = await _apiRoot.dio.get('api/groupexclusive/');
      // log.v('RESPONSE: api/groupexclusive/ => ${response.data}');

      if (response.data != null) {
        response.data.forEach((_exclusive) {
          _exclusives.add(Exclusive.fromJson(_exclusive));
        });
      }
      return _exclusives;
    } on DioError catch (error) {
      log.v('ERROR on api/groupexclusive/ :${error.response}');
      rethrow;
    }
  }

  Future<dynamic> getFilterResult(
    List<int> selectedMainCats,
    bool alphabet,
    bool rating,
    bool openRestaurants,
  ) async {
    log.v('My loc: ${_geolocatorService.locationPosition}');
    List<Restaurant> _selectedMainCatRestaurants = [];

    String _queryPars = '';

    /// IF selectedMainCats IS NOT EMPTY
    if (selectedMainCats.isNotEmpty) {
      _queryPars = 'mainCat=${selectedMainCats[0]}';
      for (int i = 1; i < selectedMainCats.length; i++)
        _queryPars += '&mainCat=${selectedMainCats[i]}'; // Workaround

      if (alphabet) _queryPars += '&alphabetical=True'; // Workaround
      if (rating) _queryPars += '&rating=True'; // Workaround
      if (openRestaurants) _queryPars += '&open=True'; // Workaround

      /// Favourite add part
      if (selectedMainCats.contains(14))
        _queryPars += '&favourite=True'; // Workaround
    } else {
      if (alphabet) _queryPars += 'alphabetical=True'; // Workaround
      if (rating) _queryPars += 'rating=True'; // Workaround
      if (openRestaurants && (alphabet || rating))
        _queryPars += '&open=True'; // Workaround
      else
        _queryPars += 'open=True';
    }

    log.v(
        'ApiService - $_queryPars, alphabetical: $alphabet, rating: $rating, open: $openRestaurants');
    try {
      Response response;

      if (_geolocatorService.locationPosition != null) {
        /// DEPRECATED after 2.3.0+35
        // await _geolocatorService.getUserCurrentLocationOnly();
        response = await _apiRoot.dio.get(
          'api/restaurants?$_queryPars',
          queryParameters: {
            'markerY': _geolocatorService.locationPosition!.longitude,
            'markerX': _geolocatorService.locationPosition!.latitude,
          },
        );
      } else
        response = await _apiRoot.dio.get('api/restaurants?$_queryPars');
      // log.v('RESPONSE: api/restaurants? => ${response.data}');

      if (response.data != null)
        response.data.forEach((_promoted) {
          _selectedMainCatRestaurants.add(Restaurant.fromJson(_promoted));
        });

      return _selectedMainCatRestaurants;
    } on DioError catch (error) {
      log.v('ERROR on api/promoted/ :${error.response}');
      return error;
    }
  }

  //------------------ SINGLE EXCLUSIVE APIS ---------------------//

  Future<void> getSingleExRiches({
    required int singleExId,
    Function(List<EsRich>)? onSuccess,
  }) async {
    log.v('My loc: ${_geolocatorService.locationPosition}');
    List<EsRich> _seRiches = [];
    try {
      Response response;
      if (_geolocatorService.locationPosition != null) {
        /// DEPRECATED after 2.3.0+35
        // await _geolocatorService.getUserCurrentLocationOnly();
        response = await _apiRoot.dio.get(
          'api/richRes/',
          queryParameters: {
            'exclusive': singleExId,
            'markerY': _geolocatorService.locationPosition!.longitude,
            'markerX': _geolocatorService.locationPosition!.latitude,
          },
        );
      } else
        response = await _apiRoot.dio
            .get('api/richRes/', queryParameters: {'exclusive': singleExId});

      // log.v('RESPONSE: api/richRes/ => ${response.data}');

      if (response.data != null && response.statusCode == 200) {
        response.data.forEach((_resCategory) {
          _seRiches.add(EsRich.fromJson(_resCategory));
        });

        onSuccess!(_seRiches);
      }
    } on DioError catch (error) {
      log.v('ERROR on api/richRes?exclusive=$singleExId :${error.response}');
      throw DioErrorType.response;
    }
  }

  //------------------ RESTAURANT APIS ---------------------//

  Future<void> getResCatsWithMeals({
    required int restaurantId,
    Function(List<ResCategory>)? onSuccess,
    Function()? onFail,
  }) async {
    List<ResCategory> _resCategories = [];
    try {
      Response response = await _apiRoot.dio.get('api/categories/',
          queryParameters: {'restaurant': restaurantId});
      // log.v('RESPONSE: api/categories/ => ${response.data}');

      if (response.data != null && response.statusCode == 200) {
        response.data.forEach((_resCategory) {
          _resCategories.add(ResCategory.fromJson(_resCategory));
        });

        onSuccess!(_resCategories);
      } else {
        onFail!();
      }
    } on DioError catch (error) {
      log.v('ERROR on api/categories/ :${error.response}');
      onFail!();
      throw DioErrorType.response;
    }
  }

  //------------------ CART APIS ---------------------//

  Future<List<Meal>> getMoreMeals(int resId, List<HiveMeal> cartMeals) async {
    List<Meal> _moreMeals = [];

    String _queryPars = 'restaurant=$resId';
    for (int i = 0; i < cartMeals.length; i++)
      _queryPars += '&another=${cartMeals[i].id}'; // Workaround

    try {
      Response response =
          await _apiRoot.dio.get('api/restaurantMeals/?$_queryPars');
      // log.v('RESPONSE: api/restaurantMeals/?$_queryPars => ${response.data}');

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

  Future<Promocode?> searchPromocode(
      String searchText, int resId, int getTotalCartSum) async {
    List<Promocode?> _promocodeList = [];
    try {
      Response response =
          await _apiRoot.dio.get('api/promocode/', queryParameters: {
        'search': searchText,
        'restaurant': resId,
        'amount': getTotalCartSum,
      });
      log.v('RESPONSE: api/promocode/ => ${response.data}');

      if (response.data != null)
        for (final _promocode in response.data)
          _promocodeList.add(Promocode.fromJson(_promocode));
      log.v(
          'RESPONSE: api/promocode/ _promocodeList[0] => ${_promocodeList[0]}');

      return _promocodeList[0];
    } on DioError catch (error) {
      log.v(error);
      log.v(
          'ERROR on api/promocode/ :${error.response!.statusCode} and ${error.response!.data}');
      rethrow;
    }
  }

  //------------------ SEARCH APIS ---------------------//

  Future<List<SearchRestaurant?>> startMainSearch(String searchText) async {
    List<SearchRestaurant?> _searchRestaurants = [];
    try {
      Response response = await _apiRoot.dio
          .get('api/restaurants/', queryParameters: {'search': searchText});
      // log.v('RESPONSE: api/restaurants/ => ${response.data}');

      if (response.data != null && response.statusCode == 200) {
        response.data.forEach((_searchRestaurant) {
          _searchRestaurants.add(SearchRestaurant.fromJson(_searchRestaurant));
        });
      }
      log.v('RESPONSE: _searchRestaurants => ${_searchRestaurants.length}');

      return _searchRestaurants;
    } on DioError catch (error) {
      log.v(error);
      // log.v(
      //     'ERROR on api/restaurants/ :${error.response!.statusCode} and ${error.response!.data}');
      rethrow;
    }
  }

  //------------------ SEARCH APIS ---------------------//

  Future<List<Meal?>> searchMeals(String searchText, int resId) async {
    List<Meal?> _searchMeals = [];
    try {
      Response response =
          await _apiRoot.dio.get('api/restaurantMeals/', queryParameters: {
        'restaurant': resId,
        'search': searchText,
      });
      // log.v('RESPONSE: api/restaurantMeals/ => ${response.data}');

      if (response.data != null && response.statusCode == 200) {
        response.data.forEach((_searchMeal) {
          _searchMeals.add(Meal.fromJson(_searchMeal));
        });
      }
      log.v('RESPONSE: _searchMeals => ${_searchMeals.length}');

      return _searchMeals;
    } on DioError catch (error) {
      log.v('ERROR on api/restaurantMeals/: ${error.response!.data}');
      rethrow;
    }
  }
}
