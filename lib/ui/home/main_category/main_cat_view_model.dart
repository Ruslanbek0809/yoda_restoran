import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class MainCatViewModel extends ReactiveViewModel {
  final log = getLogger('MainCatViewModel');

  final _bottomSheetService = locator<BottomSheetService>();
  final _homeService = locator<HomeService>();
  final _mainCatService = locator<
      MainCatService>(); // To update _selectedMainCats in realtime(reactive)
  final _mainFilterService = locator<MainFilterService>();

  List<MainCategory>? get mainCats => _homeService.mainCats;

  List<int> get selectedMainCats => _mainCatService.selectedMainCats;

  CategoryFilter? get selectedSort => _mainCatService.selectedSort;

  MainFilterAnimationStatus get mainFilterAnimationStatus =>
      _mainFilterService.mainFilterAnimationStatus;

  /// CHECKS whether this mainCegory selected or NOT
  bool isMainCategorySelected(int? mainCategoryId) =>
      selectedMainCats.contains(mainCategoryId);

  /// ADDS or REMOVES mainCatId to/from _selectedMainCats IDs
  Future<void> updateSelectedMainCats(int? mainCatId) async {
    log.i(
        'updateSelectedMainCats() _selectedMainCats length: ${selectedMainCats.length}');

    _mainCatService.updateSelectedMainCats(
        mainCatId); // UPDATES _selectedMainCats (CALLED from _mainCatService)

    await _homeService.getSelectedMainCats(
        selectedMainCats); // FETCHS HOME to SHOW RESULT of selectedMainCats (CALLED from _homeService)

    _mainFilterService.updateMainAnimationFilterStatus(
        _mainCatService.selectedSort,
        _mainCatService
            .selectedMainCats); // UPDATES main filter animation status (CALLED from _mainFilterService)

    notifyListeners();
  }

  /// UPDATES _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    log.i('updateSelectedSort(): ${selectedSort!.name}');

    _mainCatService.updateSelectedSort(
        newSelectedSort); // UPDATES selectedSort (CALLED from _mainCatService)

    _mainFilterService.updateMainAnimationFilterStatus(
        _mainCatService.selectedSort,
        _mainCatService
            .selectedMainCats); // UPDATES main filter animation status (CALLED from _mainFilterService)

    notifyListeners();
  }

  //------------------------ MEAL BOTTOM SHEET PART ----------------------------//

  /// CALLS MainCategoryBottomSheetView
  Future showCustomBottomSheet() async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.mainCategory,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_mainCatService, _mainFilterService];
}
