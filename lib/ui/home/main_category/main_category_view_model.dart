import 'package:stacked/stacked.dart';

class MainCategoryViewModel extends BaseViewModel {
  bool _isUpdated = false;

  bool get isUpdated => _isUpdated;

  void updateMainCategoryItem() {
    _isUpdated = !_isUpdated;
    // if (pos == homeCatLength - 1) {
    //   _onFilterCategoryClicked(additionalCategories);
    // }
    notifyListeners();
  }

  // void _onFilterCategoryClicked(List<CategoryUI> additionalCategories) {
  //   showCategoriesFilterBottomSheet(context, additionalCategories);
  // }
}
