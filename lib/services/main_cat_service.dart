import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';

// 1 For Reactive Views
class MainCatService with ReactiveServiceMixin {
  final log = getLogger('MainCatService');

  MainCatService() {
    // 3
    listenToReactiveValues([_selectedMainCats, selectedSort]);
  }

  // 2
  ReactiveValue<List<int>> _selectedMainCats = ReactiveValue<List<int>>([]);
  List<int> get selectedMainCats => _selectedMainCats.value;

  ReactiveValue<CategoryFilter> _selectedSort =
      ReactiveValue<CategoryFilter>(mainCatSortList[0]);
  CategoryFilter get selectedSort => _selectedSort.value;

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

  /// CLEARS __selectedMainCats.value (CALLED from _homeService)
  void clearSelectedMainCats() {
    _selectedMainCats.value.clear();
  }
}
