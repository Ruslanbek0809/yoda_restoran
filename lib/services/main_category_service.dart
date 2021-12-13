import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';

// 1 For Reactive Views
class MainCategoryService with ReactiveServiceMixin {
  final log = getLogger('MainCategoryService');

  MainCategoryService() {
    // 3
    listenToReactiveValues(
        [_multiSelectionList, selectedSort, _sortAnimationStatus]);
  }

  // 2
  ReactiveValue<List<int>> _multiSelectionList = ReactiveValue<List<int>>([]);
  List<int> get multiSelectionList => _multiSelectionList.value;

  CategoryFilter _selectedSort = mainCategorySortList[0];
  CategoryFilter get selectedSort => _selectedSort;

  ReactiveValue<SortAnimationStatus> _sortAnimationStatus =
      ReactiveValue<SortAnimationStatus>(SortAnimationStatus.idle);
  SortAnimationStatus get sortAnimationStatus => _sortAnimationStatus.value;

  /// Function to ADD or REMOVE mainCategory to/from _multiSelectionList
  void updateMainCategoryItem(int? mainCategoryId) {
    log.i('');
    if (_multiSelectionList.value.contains(mainCategoryId)) {
      _multiSelectionList.value.remove(mainCategoryId);
    } else {
      _multiSelectionList.value.add(mainCategoryId!);
    }
    // updateSortAnimationStatus();
  }

  /// Function to UPDATE _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    log.i('');
    _selectedSort = newSelectedSort!;
    // updateSortAnimationStatus();
  }

  /// Function to update _sortAnimationStatus
  void updateSortAnimationStatus() {
    log.i('');
    switch (_sortAnimationStatus.value) {
      case SortAnimationStatus.idle:
        if (_multiSelectionList.value.isNotEmpty ||
            _selectedSort != mainCategorySortList[0]) {
          _sortAnimationStatus.value = SortAnimationStatus.forward;
        }
        break;
      case SortAnimationStatus.forward:
        if (_multiSelectionList.value.isEmpty &&
            _selectedSort == mainCategorySortList[0]) {
          _sortAnimationStatus.value = SortAnimationStatus.reverse;
        }
        break;
      case SortAnimationStatus.reverse:
        if (_multiSelectionList.value.isNotEmpty ||
            _selectedSort != mainCategorySortList[0]) {
          _sortAnimationStatus.value = SortAnimationStatus.forward;
        }
        break;
      default:
        _sortAnimationStatus.value = SortAnimationStatus.idle;
        break;
    }
  }

  /// Function to update isBottomCartShown
  // void updateBottomCartStatus() {
  //   switch (_bottomCartStatus.value) {
  //     case BottomCartStatus.idle:
  //       _bottomCartStatus.value = BottomCartStatus.forward;
  //       break;
  //     case BottomCartStatus.forward:
  //       _bottomCartStatus.value = BottomCartStatus.reverse;
  //       break;
  //     case BottomCartStatus.reverse:
  //       _bottomCartStatus.value = BottomCartStatus.forward;
  //       break;
  //     default:
  //       _bottomCartStatus.value = BottomCartStatus.idle;
  //       break;
  //   }
  //   log.i(_bottomCartStatus.value);
  // }
}
