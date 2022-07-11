import 'package:stacked/stacked.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import '../utils/utils.dart';

// 1 For Reactive Views
class MainCatService with ReactiveServiceMixin {
  final log = getLogger('MainCatService');

  MainCatService() {
    // 3
    listenToReactiveValues([_selectedMainCats, selectedSort, _isFilterApplied]);
  }

  // 2
  ReactiveValue<List<int>> _selectedMainCats = ReactiveValue<List<int>>([]);
  List<int> get selectedMainCats => _selectedMainCats.value;

  ReactiveValue<FilterSort> _selectedSort =
      ReactiveValue<FilterSort>(mainCatSortList[0]);
  FilterSort get selectedSort => _selectedSort.value;

  ReactiveValue<bool> _isFilterApplied = ReactiveValue<bool>(false);
  bool get isFilterApplied => _isFilterApplied.value;

  //------------------ SELECTED MAIN CATS PART ---------------------//

  /// ADDS or REMOVES mainCategory to/from _selectedMainCats
  void updateSelectedMainCats(int mainCatId) {
    log.v('updateSelectedMainCats');
    if (_selectedMainCats.value.contains(mainCatId)) {
      /// This Method 1 DOES NOT WORK to update UI. Stacked reactivity thing
      // _selectedMainCats.value.remove(mainCatId);

      /// This Method 2 WORKS to update UI. Stacked reactivity thing
      var _tempSelectedMainCats = _selectedMainCats.value;
      _tempSelectedMainCats.remove(mainCatId);
      _selectedMainCats.value = [];
      _selectedMainCats.value = [..._tempSelectedMainCats];
    } else {
      /// This Method 1 DOES NOT WORK to update UI. Stacked reactivity thing
      // _selectedMainCats.value.add(mainCatId);

      /// This Method 2 WORKS to update UI. Stacked reactivity thing
      _selectedMainCats.value = [..._selectedMainCats.value, mainCatId];
    }
  }

  /// CLEARS _selectedMainCats.value (CALLED from _homeService)
  void clearSelectedMainCats() {
    _selectedMainCats.value.clear();
  }

  /// ASSIGNS tempSelectedMainCats to _selectedMainCats
  void assignTempSelectedMainCats(List<int>? tempSelectedMainCats) {
    _selectedMainCats.value = tempSelectedMainCats!;
  }

  //------------------ SELECTED SORT PART ---------------------//

  /// UPDATES _selectedSort
  void updateSelectedSort(FilterSort? newSelectedSort) {
    _selectedSort.value = newSelectedSort!;
    log.v('_selectedSort.value.id: ${_selectedSort.value.id}');
  }

  //------------------ FILTER PART ---------------------//

  /// SETS _isFilterApplied to TRUE
  void filterApplied() {
    if (!_isFilterApplied.value) {
      log.v('filterApplied FIRED');
      _isFilterApplied.value = true;
    }
  }

  /// SETS _isFilterApplied to FALSE
  void filterDisabled() {
    if (_isFilterApplied.value) {
      log.v('filterDisabled FIRED');
      _isFilterApplied.value = false;
    }
  }

  // /// SETS _isFilterApplied to FALSE
  // void filterDisabled() => _isFilterApplied.value = false;
}
