import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';

class MainCategoryViewModel extends BaseViewModel {
  final log = getLogger('MainCategoryViewModel');
  List<int> _multiSelectionList = [];

  /// Function to check wether this mainCegory selected or NOT
  bool isMainCategorySelected(int? mainCategoryId) =>
      _multiSelectionList.contains(mainCategoryId);

  /// Function to ADD or REMOVE mainCategory to/from _multiSelectionList
  void updateMainCategoryItem(int? mainCategoryId) {
    if (_multiSelectionList.contains(mainCategoryId)) {
      _multiSelectionList.remove(mainCategoryId);
    } else {
      _multiSelectionList.add(mainCategoryId!);
    }
    log.i(_multiSelectionList);
    notifyListeners();

    // TODO: showCategoriesFilterBottomSheet
    // if (pos == homeCatLength - 1) {
    //   _onFilterCategoryClicked(additionalCategories);
    // }
  }

  // void _onFilterCategoryClicked(List<CategoryUI> additionalCategories) {
  //   showCategoriesFilterBottomSheet(context, additionalCategories);
  // }
}
