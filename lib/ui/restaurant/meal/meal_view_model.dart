import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

/// ReactiveViewModel is used to "react"
class MealViewModel extends ReactiveViewModel {
  final log = getLogger('FoodViewModel');

  final _bottomCartService = locator<BottomCartService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _dialogService = locator<DialogService>();
  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here I retrieved bottomCartStatus for log ONLY

  bool _isButtonToggled = false;
  bool get isButtonToggled => _isButtonToggled;

  int _quantity = 0;
  int get quantity => _quantity;

  /// Function to update isButtonToggled
  void updateButtonToggle() {
    _isButtonToggled = !_isButtonToggled;
    log.i('_isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

  /// Function to update updateBottomCartStatus
  void updateBottomCartStatus() {
    _bottomCartService.updateBottomCartStatus();

    log.i('bottomCartStatus: $bottomCartStatus');
    notifyListeners();
  }

  //----------- HIVE DB PART ------------//

  /// GETS quantity of cartMeal for this meal if this meal exist in CART and TOGGLES _isButtonToggled
  void getMealQuantity(int? mealId) {
    _quantity = _hiveDbService.getMealQuantity(mealId)!;
    if (quantity >= 1) _isButtonToggled = true;
    log.i('_quantity: $_quantity, _isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

//------------------------ MEAL BOTTOM SHEET PART ----------------------------//

  /// Function to call MealBottomSheet
  Future showCustomMealBottomSheet(Meal meal) async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.meal,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
      data: meal,
    );
  }

  List<Volume?> _selectedVolumes = [];
  List<Volume?> get selectedVolumes => _selectedVolumes;

  List<List<int>>? _selectedCustomizables = [];
  List<List<int>>? get selectedCustomizables => _selectedCustomizables;

  /// CHECK wether this selectedCustomizable selected or NOT
  bool isCustomizableSelected(int? mainCustomizablePos, int customizableId) =>
      _selectedCustomizables![mainCustomizablePos!].contains(customizableId);

  /// SETS and CREATES initial list for selectedVolumes and selectedMultiCustomizables
  void setOnModelReadyVolumesCustomizes(
      int gVolumesLength, int gCustomizablesLength) {
    _selectedVolumes = List.generate(
      gVolumesLength,
      (_) => Volume(id: 0, groupId: 0, price: 0, volumeName: ''),
    ); // Here created new list based on mainVolumeLength with all its value null

    _selectedCustomizables = List.generate(gCustomizablesLength, (_) => []);
  }

  /// UPDATES _selectedVolumes's mainVolumePos value to volume
  void updateSelectedVolume(int mainVolumePos, Volume? volume) {
    _selectedVolumes[mainVolumePos] = volume;
    notifyListeners();
  }

  /// ADD or REMOVE selected customizable in _selectedCustomizables![mainVolumePos]
  void updateSelectedCustomizable(int mainVolumePos, int? customizableId) {
    if (_selectedCustomizables![mainVolumePos].contains(customizableId))
      _selectedCustomizables![mainVolumePos].remove(customizableId);
    else
      _selectedCustomizables![mainVolumePos].add(customizableId!);
    notifyListeners();
  }

  /// SHOWS Clear or Navigate Cart Dialog
  Future showClearOrNavigateCartDialog() async {
    log.i('');
    await _dialogService.showCustomDialog(
      variant: DialogType.cart,
      title: 'Sebedi boşadyň',
      description:
          'Sebetde başga restorandan goşulan haryt bar. Täze sargyt etmek üçin ilki restorana sargydyňyzy ugradyň ýa-da sebedi boşadyň.',
      mainButtonTitle: 'Sebedi boşat',
      secondaryButtonTitle: 'Sebede geç',
      showIconInMainButton: false,
      barrierDismissible: true,
    );
  }

//------------------------ NAVIGATIONS ----------------------------//

  void navBack() => _navService.back();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_bottomCartService];
}
