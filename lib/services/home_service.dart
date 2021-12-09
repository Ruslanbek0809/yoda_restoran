import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/api_service.dart';

class HomeService {
  final log = getLogger('HomeService');
  final _api = locator<ApiService>();

  List<SliderModel>? _sliders;
  List<SliderModel>? get sliders => _sliders;

  List<MainCategory>? _mainCategories;
  List<MainCategory>? get mainCategories => _mainCategories;

  List<Restaurant>? _randomRestaurants;
  List<Restaurant>? get randomRestaurants => _randomRestaurants;

  List<Promoted>? _promotedList;
  List<Promoted>? get promotedList => _promotedList;

  bool get hasSliders => _sliders != null && _sliders!.isNotEmpty;

  bool get hasMainCategories =>
      _mainCategories != null && _mainCategories!.isNotEmpty;

  bool get hasRandomRestaurants =>
      _randomRestaurants != null && _randomRestaurants!.isNotEmpty;

  bool get hasPromotedList =>
      _promotedList != null && _promotedList!.isNotEmpty;

  Future<List<SliderModel>?> getSliders() async {
    _sliders = await _api.getSliders();
    log.i(_sliders!.length);
    return _sliders;
  }

  Future<List<MainCategory>?> getMainCategories() async {
    _mainCategories = await _api.getMainCategories();
    log.i(_mainCategories!.length);
    return _mainCategories;
  }

  Future<List<Restaurant>?> getRandomRestorants() async {
    _randomRestaurants = await _api.getRandomRestorants();
    log.i(_randomRestaurants!.length);
    return _randomRestaurants;
  }

  Future<List<Promoted>?> getPromotedRestaurants() async {
    _promotedList = await _api.getPromotedRestaurants();
    log.i(_promotedList!.length);
    return _promotedList;
  }
}
