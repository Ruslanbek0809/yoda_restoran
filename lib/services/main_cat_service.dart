import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';

// 1 For Reactive Views
class MainCatService with ReactiveServiceMixin {
  final log = getLogger('MainCatService');

  MainCatService() {
    // 3
    listenToReactiveValues(
        [_multiSelectionList, selectedSort, _sortAnimationStatus]);
  }

  // 2
  ReactiveValue<List<int>> _multiSelectionList = ReactiveValue<List<int>>([]);
  List<int> get multiSelectionList => _multiSelectionList.value;

  ReactiveValue<CategoryFilter> _selectedSort =
      ReactiveValue<CategoryFilter>(mainCatSortList[0]);
  // CategoryFilter _selectedSort = mainCatSortList[0];
  CategoryFilter get selectedSort => _selectedSort.value;

  ReactiveValue<SortAnimationStatus> _sortAnimationStatus =
      ReactiveValue<SortAnimationStatus>(SortAnimationStatus.idle);
  SortAnimationStatus get sortAnimationStatus => _sortAnimationStatus.value;

  /// Function to ADD or REMOVE mainCategory to/from _multiSelectionList
  void updateMainCategoryItem(int? mainCategoryId) {
    if (_multiSelectionList.value.contains(mainCategoryId))
      _multiSelectionList.value.remove(mainCategoryId);
    else
      _multiSelectionList.value.add(mainCategoryId!);
  }

  /// Function to UPDATE _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    _selectedSort.value = newSelectedSort!;
  }

  /// Function to update _sortAnimationStatus
  void updateSortAnimationStatus() {
    switch (_sortAnimationStatus.value) {
      case SortAnimationStatus.idle:
        if (_multiSelectionList.value.isNotEmpty ||
            _selectedSort.value != mainCatSortList[0]) {
          _sortAnimationStatus.value = SortAnimationStatus.forward;
        }
        break;
      case SortAnimationStatus.forward:
        if (_multiSelectionList.value.isEmpty &&
            _selectedSort.value == mainCatSortList[0]) {
          _sortAnimationStatus.value = SortAnimationStatus.reverse;
        }
        break;
      case SortAnimationStatus.reverse:
        if (_multiSelectionList.value.isNotEmpty ||
            _selectedSort.value != mainCatSortList[0]) {
          _sortAnimationStatus.value = SortAnimationStatus.forward;
        }
        break;
      default:
        _sortAnimationStatus.value = SortAnimationStatus.idle;
        break;
    }
  }
}
