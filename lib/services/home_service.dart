import 'package:stacked/stacked.dart';
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'api_service.dart';

// 1 For Reactive View
class HomeService with ReactiveServiceMixin {
  final log = getLogger('HomeService');

  HomeService() {
    // 3
    listenToReactiveValues([_fetchingSelectedMainCats]);
  }

  final _api = locator<ApiService>();

  List<SliderModel>? _sliders = [];
  List<SliderModel>? get sliders => _sliders;

  List<MainCategory>? _mainCats = [];
  List<MainCategory>? get mainCats => _mainCats;

  List<Restaurant>? _randomRess = [];
  List<Restaurant>? get randomRess => _randomRess;

  List<Promoted>? _proms = [];
  List<Promoted>? get proms => _proms;

  bool get hasSliders => _sliders != null && _sliders!.isNotEmpty;

  bool get hasMainCats => _mainCats != null && _mainCats!.isNotEmpty;

  bool get hasRandomRess => _randomRess != null && _randomRess!.isNotEmpty;

  bool get hasProms => _proms != null && _proms!.isNotEmpty;

  // ------- SELECTECTED MAIN CAT RESTAURANTS --------//
  List<Restaurant>? _selectedMainCatRestaurants = [];
  List<Restaurant>? get selectedMainCatRestaurants =>
      _selectedMainCatRestaurants;

  bool get hasSelectedMainCatRestaurants =>
      _selectedMainCatRestaurants != null &&
      _selectedMainCatRestaurants!.isNotEmpty;

  // 2
  ReactiveValue<bool> _fetchingSelectedMainCats =
      ReactiveValue<bool>(false); // Custom busy for HomeView
  bool get fetchingSelectedMainCats => _fetchingSelectedMainCats.value;

  Future<List<SliderModel>?> getSliders() async {
    _sliders = await _api.getSliders();
    log.v(_sliders!.length);
    return _sliders;
  }

  Future<List<MainCategory>?> getMainCategs() async {
    _mainCats = await _api.getMainCats();
    _mainCats!.sort((prev, next) => prev.order!.compareTo(next.order!));
    log.v(_mainCats!.length);
    return _mainCats;
  }

  Future<List<Restaurant>?> getRandomRess() async {
    _randomRess = await _api.getRandomRess();
    log.v(_randomRess!.length);
    return _randomRess;
  }

  Future<List<Promoted>?> getProms() async {
    _proms = await _api.getProms();
    log.v(_proms!.length);
    return _proms;
  }

  Future<void> getSelectedMainCats(List<int> selectedMainCats) async {
    if (selectedMainCats.isNotEmpty) {
      _fetchingSelectedMainCats.value = true;
      _selectedMainCatRestaurants =
          await _api.getSelectedMainCats(selectedMainCats);
      _fetchingSelectedMainCats.value = false;
      log.v(
          '_selectedMainCatRestaurants!.length: ${_selectedMainCatRestaurants!.length}');
    } else {
      _fetchingSelectedMainCats.value = true;
      _selectedMainCatRestaurants!.clear();
      await Future.delayed(Duration(seconds: 1));
      _fetchingSelectedMainCats.value = false;
      log.v(
          '_selectedMainCatRestaurants!.length: ${_selectedMainCatRestaurants!.length}');
    }
  }

  void clearSelectedMainCatRess() {
    _selectedMainCatRestaurants!.clear();
    log.v(
        '_selectedMainCatRestaurants!.length: ${_selectedMainCatRestaurants!.length}');
  }
}
