import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

class MainCatBottomViewModel extends ReactiveViewModel {
  final log = getLogger('MainCatBottomViewModel');

  final _navService = locator<NavigationService>();
  final _homeService = locator<HomeService>();
  final _mainCatService = locator<
      MainCatService>(); // To update _selectedMainCats in realtime(reactive)
  final _geolocatorService = locator<GeolocatorService>();

  Position? get locationPosition => _geolocatorService.locationPosition;

  List<MainCategory>? get mainCats => _homeService.mainCats;

  List<int> get selectedMainCats => _mainCatService.selectedMainCats;
  FilterSort? get selectedSort => _mainCatService.selectedSort;
  bool get isByOpenRestaurantsChecked =>
      _mainCatService.isByOpenRestaurantsChecked;
  bool get isFilterApplied => _mainCatService.isFilterApplied;

  List<int> _tempSelectedMainCats = [];
  List<int> get tempSelectedMainCats => _tempSelectedMainCats;

  //*ASSIGNS _tempSelectedMainCats (Used in onModelReady)
  void assignTempCats() {
    _tempSelectedMainCats = [...selectedMainCats];
    // _tempSelectedMainCats = selectedMainCats; //*DON'T ASSIGN reactive value directly. Which makes temp value reactive as well.

    log.i(
        'assignTempList() _tempSelectedMainCats length: ${_tempSelectedMainCats.length}');
  }

  //*CHECKS whether this mainCat selected or NOT
  bool isTempMainCatSelected(int? mainCatId) =>
      _tempSelectedMainCats.contains(mainCatId);

  //*ADDS or REMOVES mainCatId to/from _tempSelectedMainCats Ids
  void updateTempSelectedMainCats(int? mainCatId) async {
    if (_tempSelectedMainCats.contains(mainCatId))
      _tempSelectedMainCats.remove(mainCatId);
    else
      _tempSelectedMainCats.add(mainCatId!);
    log.i(
        'updateTempSelectedMainCats() _tempSelectedMainCats length: ${_tempSelectedMainCats.length}');

    notifyListeners();
  }

  //*UPDATES _isByOpenRestaurantsChecked
  void updateIsOpenByRestaurants(bool newValue) {
    log.i('updateIsOpenByRestaurants(): $isByOpenRestaurantsChecked');

    _mainCatService.updateIsOpenByRestaurants(
        newValue); // UPDATES isByOpenRestaurantsChecked (CALLED from _mainCatService)
    notifyListeners();
  }

  //*UPDATES _selectedSort
  void updateSelectedSort(FilterSort? newSelectedSort) {
    log.i('updateSelectedSort(): ${selectedSort?.name ?? ''}');

    _mainCatService.updateSelectedSort(
        newSelectedSort); // UPDATES selectedSort (CALLED from _mainCatService)
    notifyListeners();
  }

  //*ADDS or REMOVES mainCatId to/from _selectedMainCats IDs
  Future<void> fireFilterAPI() async {
    log.i('fireFilterAPI()');

    bool _byAlphabet = false;
    bool _byRating = false;
    bool _byOpenRestaurants = false;
    if (selectedSort!.id == 2) _byAlphabet = true;
    if (selectedSort!.id == 3) _byRating = true;
    if (isByOpenRestaurantsChecked) _byOpenRestaurants = true;

    await runBusyFuture(
      _homeService.getFilterResult(
        _tempSelectedMainCats,
        _byAlphabet,
        _byRating,
        _byOpenRestaurants,
      ),
    ); // FETCHS HOME to SHOW RESULT of selectedMainCats (CALLED from _homeService))

    _mainCatService.assignTempSelectedMainCats(
        _tempSelectedMainCats); // ASSINGS all _tempSelectedMainCats to  _selectedMainCats (CALLED from _mainCatService)

    //*CHECKS whether isFilterApplied var SET to TRUE before or NOT
    if (!isFilterApplied) _mainCatService.filterApplied();
  }

//*----------------------- NAVIGATION ----------------------------//
  void navBack() => _navService.back();

  @override
  List<ListenableServiceMixin> get listenableServices => [_mainCatService];
}
