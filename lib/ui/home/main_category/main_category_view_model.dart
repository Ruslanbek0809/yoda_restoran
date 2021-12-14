import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class MainCategoryViewModel extends ReactiveViewModel {
  final log = getLogger('MainCategoryViewModel');

  final _bottomSheetService = locator<BottomSheetService>();
  final _homeService = locator<HomeService>();
  final _mainCatService = locator<
      MainCategoryService>(); // To update multiSelectionList in realtime(reactive)

  List<int> get _multiSelectionList => _mainCatService.multiSelectionList;

  List<MainCategory>? get mainCats => _homeService.mainCats;

  // List<MainCategory>? get mainBSCats => _homeService.mainCats;
  // _homeService.mainCats!..removeAt(0);

  CategoryFilter? get selectedSort => _mainCatService.selectedSort;
  SortAnimationStatus get sortAnimationStatus =>
      _mainCatService.sortAnimationStatus;

  /// Function to check wether this mainCegory selected or NOT
  bool isMainCategorySelected(int? mainCategoryId) =>
      _multiSelectionList.contains(mainCategoryId);

  /// Function to ADD or REMOVE mainCategory to/from _multiSelectionList
  void updateMainCategoryItem(int? mainCategoryId) {
    _mainCatService.updateMainCategoryItem(mainCategoryId);
    log.i(_multiSelectionList);
    notifyListeners();
    updateSortAnimationStatus();
  }

  /// Function to LOAD restaurants by mainCategoryID
  Future updateMainCategory() async {
    await _homeService.updateMainCategory();
  }

  /// Function to UPDATE _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    _mainCatService.updateSelectedSort(newSelectedSort);
    log.i(selectedSort!.name);
    notifyListeners();
    updateSortAnimationStatus();
  }

  /// Function to update _sortAnimationStatus
  void updateSortAnimationStatus() {
    _mainCatService.updateSortAnimationStatus();
    log.i(sortAnimationStatus);
    notifyListeners();
  }

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
