import 'package:stacked/stacked.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import '../utils/utils.dart';

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

  /// ADDS or REMOVES mainCategory to/from _selectedMainCats
  void updateSelectedMainCats(int? mainCatId) {
    if (_selectedMainCats.value.contains(mainCatId))
      _selectedMainCats.value.remove(mainCatId);
    else
      _selectedMainCats.value.add(mainCatId!);
  }

  /// UPDATES _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    _selectedSort.value = newSelectedSort!;
  }

  /// CLEARS _selectedMainCats.value (CALLED from _homeService)
  void clearSelectedMainCats() {
    _selectedMainCats.value.clear();
  }

  /// ASSIGNS tempSelectedMainCats to _selectedMainCats
  void assignTempSelectedMainCats(List<int>? tempSelectedMainCats) {
    _selectedMainCats.value = tempSelectedMainCats!;
  }
}
