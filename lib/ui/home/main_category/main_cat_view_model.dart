import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class MainCatViewModel extends ReactiveViewModel {
  final log = getLogger('MainCatViewModel');

  final _bottomSheetService = locator<BottomSheetService>();
  final _homeService = locator<HomeService>();
  final _mainCatService = locator<
      MainCatService>(); // To update _selectedMainCats in realtime(reactive)
  final _mainFilterService = locator<MainFilterService>();

  List<MainCategory>? get mainCats => _homeService.mainCats;

  List<int> get selectedMainCats => _mainCatService.selectedMainCats;

  /// CHECKS whether this mainCat selected or NOT
  bool isMainCatSelected(int? mainCatId) =>
      selectedMainCats.contains(mainCatId);

  /// ADDS or REMOVES mainCatId to/from _selectedMainCats IDs
  Future<void> updateSelectedMainCats(int? mainCatId) async {
    log.i(
        'updateSelectedMainCats() _selectedMainCats length: ${selectedMainCats.length}');

    _mainCatService.updateSelectedMainCats(
        mainCatId); // UPDATES _selectedMainCats (CALLED from _mainCatService)

    notifyListeners(); // This notifyListeners() is put here instead of last line because of Yandex like animation before starting fetch
    await Future.delayed(
        Duration(milliseconds: 300)); // For Yandex like animation

    bool isSelectedFetched = await _homeService.getSelectedMainCats(
      selectedMainCats,
      false,
      false,
    ); // FETCHS HOME to SHOW RESULT of selectedMainCats (CALLED from _homeService)

    if (!isSelectedFetched)
      _mainCatService.updateSelectedMainCats(
          mainCatId); // UPDATES _selectedMainCats (CALLED from _mainCatService)

    // _mainFilterService.updateMainAnimationFilterStatus(
    //     _mainCatService.selectedSort,
    //     _mainCatService
    //         .selectedMainCats); // UPDATES main filter animation status (CALLED from _mainFilterService)

    // notifyListeners();
  }

  //------------------------ MEAL BOTTOM SHEET PART ----------------------------//

  /// CALLS MainCategoryBottomSheetView
  Future showCustomBottomSheet() async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.mainCategory,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_mainCatService, _mainFilterService];
}
