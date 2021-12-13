import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class MainCategoryViewModel extends BaseViewModel {
  final log = getLogger('MainCategoryViewModel');

  final _bottomSheetService = locator<BottomSheetService>();
  final _homeService = locator<HomeService>();
  final _mainCatService = locator<MainCategoryService>();

  List<int> _multiSelectionList = [];

  CategoryFilter? _selectedSort = mainCategorySortList[0];
  SortAnimationStatus _sortAnimationStatus = SortAnimationStatus.idle;

  CategoryFilter? get selectedSort => _selectedSort;
  List<MainCategory>? get mainCategories => _homeService.mainCategories;
  SortAnimationStatus get sortAnimationStatus => _sortAnimationStatus;

  /// Function to check wether this mainCegory selected or NOT
  bool isMainCategorySelected(int? mainCategoryId) =>
      _multiSelectionList.contains(mainCategoryId);

  /// Function to ADD or REMOVE mainCategory to/from _multiSelectionList
  void updateMainCategoryItem(int? mainCategoryId) {
    _mainCatService.
    log.i(_multiSelectionList);
    updateBottomCartStatus();
    notifyListeners();
  }

  /// Function to UPDATE _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    _selectedSort = newSelectedSort;
    log.i(_selectedSort!.name);
    updateBottomCartStatus();
    notifyListeners();
  }

  /// Function to update _sortAnimationStatus
  void updateBottomCartStatus() {
    switch (_sortAnimationStatus) {
      case SortAnimationStatus.idle:
        if (_multiSelectionList.isNotEmpty ||
            _selectedSort != mainCategorySortList[0]) {
          _sortAnimationStatus = SortAnimationStatus.forward;
          notifyListeners();
        }
        break;
      case SortAnimationStatus.forward:
        if (_multiSelectionList.isEmpty &&
            _selectedSort == mainCategorySortList[0]) {
          _sortAnimationStatus = SortAnimationStatus.reverse;
          notifyListeners();
        }
        break;
      case SortAnimationStatus.reverse:
        if (_multiSelectionList.isNotEmpty ||
            _selectedSort != mainCategorySortList[0]) {
          _sortAnimationStatus = SortAnimationStatus.forward;
          notifyListeners();
        }
        break;
      default:
        _sortAnimationStatus = SortAnimationStatus.idle;
        break;
    }
    log.i(_sortAnimationStatus);
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
}
