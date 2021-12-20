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
      MainCatService>(); // To update multiSelectionList in realtime(reactive)

  List<int> get _selectedMainCats => _mainCatService.selectedMainCats;

  List<MainCategory>? get mainCats => _homeService.mainCats;

  CategoryFilter? get selectedSort => _mainCatService.selectedSort;
  SortAnimationStatus get sortAnimationStatus =>
      _mainCatService.sortAnimationStatus;

  /// Function to check wether this mainCegory selected or NOT
  bool isMainCategorySelected(int? mainCategoryId) =>
      _selectedMainCats.contains(mainCategoryId);

  /// ADD or REMOVE mainCategory to/from _multiSelectionList
  Future<void> updateSelectedMainCats(int? mainCatId) async {
    _mainCatService.updateSelectedMainCats(mainCatId);
    if (_selectedMainCats.isNotEmpty)
      await _homeService.getSelectedMainCats(
          _selectedMainCats); // FETCH HOME to SHOW RESULT of selectedMainCats
    _mainCatService.updateSortAnimationStatus();
    log.i(_selectedMainCats);
    notifyListeners();
  }

  /// Function to UPDATE _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    _mainCatService.updateSelectedSort(newSelectedSort);
    log.i(selectedSort!.name);
    _mainCatService.updateSortAnimationStatus();
    notifyListeners();
  }

  /// Function to update _sortAnimationStatus
  // void updateSortAnimationStatus() {
  //   log.i(sortAnimationStatus);
  //   notifyListeners();
  // }

  //------------------------ MEAL BOTTOM SHEET PART ----------------------------//

  /// Function to call MainCategoryBottomSheetView
  Future showCustomBottomSheet() async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.mainCategory,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_mainCatService];
}
