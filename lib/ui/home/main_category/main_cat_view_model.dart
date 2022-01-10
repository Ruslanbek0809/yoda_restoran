import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class MainCatViewModel extends ReactiveViewModel {
  final log = getLogger('MainCatViewModel');

  final _navService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _homeService = locator<HomeService>();
  final _mainCatService = locator<
      MainCatService>(); // To update _selectedMainCats in realtime(reactive)
  final _mainFilterService = locator<MainFilterService>();

  List<MainCategory>? get mainCats => _homeService.mainCats;

  List<int> get selectedMainCats => _mainCatService.selectedMainCats;

  CategoryFilter? get selectedSort => _mainCatService.selectedSort;

  MainFilterAnimationStatus get mainFilterAnimationStatus =>
      _mainFilterService.mainFilterAnimationStatus;

  /// CHECKS whether this mainCat selected or NOT
  bool isMainCatSelected(int? mainCatId) =>
      selectedMainCats.contains(mainCatId);

  /// ADDS or REMOVES mainCatId to/from _selectedMainCats IDs
  Future<void> updateSelectedMainCats(int? mainCatId) async {
    log.i(
        'updateSelectedMainCats() _selectedMainCats length: ${selectedMainCats.length}');

    _mainCatService.updateSelectedMainCats(
        mainCatId); // UPDATES _selectedMainCats (CALLED from _mainCatService)

    await _homeService.getSelectedMainCats(
      selectedMainCats,
      false,
      false,
    ); // FETCHS HOME to SHOW RESULT of selectedMainCats (CALLED from _homeService)

    // _mainFilterService.updateMainAnimationFilterStatus(
    //     _mainCatService.selectedSort,
    //     _mainCatService
    //         .selectedMainCats); // UPDATES main filter animation status (CALLED from _mainFilterService)

    notifyListeners();
  }

  /// UPDATES _selectedSort
  void updateSelectedSort(CategoryFilter? newSelectedSort) {
    log.i('updateSelectedSort(): ${selectedSort!.name}');

    _mainCatService.updateSelectedSort(
        newSelectedSort); // UPDATES selectedSort (CALLED from _mainCatService)

    // _mainFilterService.updateMainAnimationFilterStatus(
    //     _mainCatService.selectedSort,
    //     _mainCatService
    //         .selectedMainCats); // UPDATES main filter animation status (CALLED from _mainFilterService)

    notifyListeners();
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

  List<int> _tempSelectedMainCats = [];
  List<int> get tempSelectedMainCats => _tempSelectedMainCats;

  /// ASSIGNS _tempSelectedMainCats (Used in onModelReady)
  void assignTempList() {
    _tempSelectedMainCats = _mainCatService.selectedMainCats;
  }

  /// CHECKS whether this mainCat selected or NOT
  bool isTempMainCatSelected(int? mainCatId) =>
      _tempSelectedMainCats.contains(mainCatId);

  /// ADDS or REMOVES mainCatId to/from _tempSelectedMainCats Ids
  Future<void> updateTempSelectedMainCats(int? mainCatId) async {
    if (_tempSelectedMainCats.contains(mainCatId))
      _tempSelectedMainCats.remove(mainCatId);
    else
      _tempSelectedMainCats.add(mainCatId!);
    log.i(
        'updateTempSelectedMainCats() _tempSelectedMainCats length: ${_tempSelectedMainCats.length}');

    notifyListeners();
  }

  /// ADDS or REMOVES mainCatId to/from _selectedMainCats IDs
  Future<void> updateAllSelectedTempMainCats() async {
    log.i('updateAllSelectedTempMainCats()');

    bool _byAlphabet = false;
    bool _byRating = false;
    if (selectedSort!.id == 2) _byAlphabet = true;
    if (selectedSort!.id == 3) _byRating = true;

    await runBusyFuture(
      _homeService.getSelectedMainCats(
        _tempSelectedMainCats,
        _byAlphabet,
        _byRating,
      ),
    ); // FETCHS HOME to SHOW RESULT of selectedMainCats (CALLED from _homeService))

    _mainCatService.assignTempSelectedMainCats(
        _tempSelectedMainCats); // ASSINGS all _tempSelectedMainCats to  _selectedMainCats (CALLED from _mainCatService)
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back();

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_mainCatService, _mainFilterService];
}
