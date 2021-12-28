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
        [_selectedMainCats, selectedSort, _sortAnimationStatus]);
  }

  // 2
  ReactiveValue<List<int>> _selectedMainCats = ReactiveValue<List<int>>([]);
  List<int> get selectedMainCats => _selectedMainCats.value;

  ReactiveValue<CategoryFilter> _selectedSort =
      ReactiveValue<CategoryFilter>(mainCatSortList[0]);
  CategoryFilter get selectedSort => _selectedSort.value;

  ReactiveValue<SortAnimationStatus> _sortAnimationStatus =
      ReactiveValue<SortAnimationStatus>(SortAnimationStatus.idle);
  SortAnimationStatus get sortAnimationStatus => _sortAnimationStatus.value;

  /// Function to ADD or REMOVE mainCategory to/from _multiSelectionList
  void updateSelectedMainCats(int? mainCatId) {
    if (_selectedMainCats.value.contains(mainCatId))
      _selectedMainCats.value.remove(mainCatId);
    else
      _selectedMainCats.value.add(mainCatId!);
  }

  /// Function to UPDATE _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    _selectedSort.value = newSelectedSort!;
  }

  /// Function to update _sortAnimationStatus
  void updateSortAnimationStatus() {
    log.v(
        '_selectedMainCats.value: ${_selectedMainCats.value.length} and _selectedSort.value: ${_selectedSort.value.name}');
    switch (_sortAnimationStatus.value) {
      case SortAnimationStatus.idle:
        if (_selectedMainCats.value.isNotEmpty ||
            _selectedSort.value != mainCatSortList[0]) {
          _sortAnimationStatus.value = SortAnimationStatus.forward;
        }
        break;
      case SortAnimationStatus.forward:
        if (_selectedMainCats.value.isEmpty &&
            _selectedSort.value == mainCatSortList[0]) {
          _sortAnimationStatus.value = SortAnimationStatus.reverse;
        }
        break;
      case SortAnimationStatus.reverse:
        if (_selectedMainCats.value.isNotEmpty ||
            _selectedSort.value != mainCatSortList[0]) {
          _sortAnimationStatus.value = SortAnimationStatus.forward;
        }
        break;
      default:
        _sortAnimationStatus.value = SortAnimationStatus.idle;
        break;
    }
  }

  /// CLEAR __selectedMainCats.value (CALLED from _homeService)
  void clearSelectedMainCats() {
    _selectedMainCats.value.clear();
  }
}
