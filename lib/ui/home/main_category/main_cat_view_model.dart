import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

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

  /// CHECKS whether this mainCat selected or NOT
  bool isMainCatSelected(int? mainCatId) =>
      selectedMainCats.contains(mainCatId);

  /// ADDS or REMOVES mainCatId to/from _selectedMainCats IDs
  Future<void> updateSelectedMainCats(int? mainCatId) async {
    log.i(
        'updateSelectedMainCats() _selectedMainCats length: ${selectedMainCats.length}');

    _mainCatService.updateSelectedMainCats(
        mainCatId); // UPDATES _selectedMainCats (CALLED from _mainCatService)

    await _homeService.getSelectedMainCats(
        selectedMainCats); // FETCHS HOME to SHOW RESULT of selectedMainCats (CALLED from _homeService)

    // _mainFilterService.updateMainAnimationFilterStatus(
    //     _mainCatService.selectedSort,
    //     _mainCatService
    //         .selectedMainCats); // UPDATES main filter animation status (CALLED from _mainFilterService)

    notifyListeners();
  }

  /// UPDATES _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    log.i('updateSelectedSort(): ${selectedSort!.name}');

    _mainCatService.updateSelectedSort(
        newSelectedSort); // UPDATES selectedSort (CALLED from _mainCatService)

    // _mainFilterService.updateMainAnimationFilterStatus(
    //     _mainCatService.selectedSort,
    //     _mainCatService
    //         .selectedMainCats); // UPDATES main filter animation status (CALLED from _mainFilterService)

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

  List<int> _tempSelectedMainCats = [];
  List<int> get tempSelectedMainCats => _tempSelectedMainCats;

  /// ASSIGNS _tempSelectedMainCats (Used in onModelReady)
  void assignTempList() {
    _tempSelectedMainCats = _mainCatService.selectedMainCats;
  }

  /// CHECKS whether this mainCat selected or NOT
  bool isTempMainCatSelected(int? mainCatId) =>
      _tempSelectedMainCats.contains(mainCatId);

  /// ADDS or REMOVES mainCatId to/from _tempSelectedMainCats Ids
  Future<void> updateTempSelectedMainCats(int? mainCatId) async {
    log.i(
        'updateTempSelectedMainCats() _tempSelectedMainCats length: ${_tempSelectedMainCats.length}');

    if (_tempSelectedMainCats.contains(mainCatId))
      _tempSelectedMainCats.remove(mainCatId);
    else
      _tempSelectedMainCats.add(mainCatId!);

    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_mainCatService, _mainFilterService];
}
