import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

class MainCatViewModel extends ReactiveViewModel {
  final log = getLogger('MainCatViewModel');

  final _homeService = locator<HomeService>();
  final _mainCatService = locator<
      MainCatService>(); // To update _selectedMainCats in realtime(reactive)

  List<MainCategory>? get mainCats => _homeService.mainCats;

  List<int> get selectedMainCats => _mainCatService.selectedMainCats;
  bool get isFilterApplied => _mainCatService.isFilterApplied;

  //*CHECKS whether this mainCat selected or NOT
  bool isMainCatSelected(int? mainCatId) =>
      selectedMainCats.contains(mainCatId);

  //*ADDS or REMOVES mainCatId to/from _selectedMainCats IDs
  Future<void> updateSelectedMainCats(int mainCatId) async {
    log.i(
        'updateSelectedMainCats() BEFORE _selectedMainCats length: ${selectedMainCats.length}');

    _mainCatService.updateSelectedMainCats(
        mainCatId); // UPDATES _selectedMainCats (CALLED from _mainCatService)
    log.i(
        'AFTER updateSelectedMainCats() _selectedMainCats length: ${selectedMainCats.length}');

    await Future.delayed(
        Duration(milliseconds: 300)); // For Yandex like animation

    //* FETCHS HOME to SHOW RESULT of selectedMainCats (CALLED from _homeService)
    bool isSelectedFetched = await _homeService.getFilterResult(
      selectedMainCats,
      false,
      false,
      false,
    );

    //*If selected cat is not FETCHED bc of ERROR, then remove last added mainCat from the existing list
    if (!isSelectedFetched)
      _mainCatService.updateSelectedMainCats(
          mainCatId); // UPDATES _selectedMainCats (CALLED from _mainCatService)
    else
      _mainCatService.filterApplied();

    log.i(
        'updateSelectedMainCats() AFTER selectedMainCats length: ${selectedMainCats.length}');

    //*If selectedMainCats list empty and ERROR occurs then DISABLE isFilterApplied
    if (isFilterApplied && selectedMainCats.isEmpty)
      _mainCatService.filterDisabled();

    log.i('LAST selectedMainCats length: ${selectedMainCats.length}');
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_mainCatService];
}
