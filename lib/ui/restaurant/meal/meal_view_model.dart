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

  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here I retrieved bottomCartStatus for log ONLY

  bool _isButtonToggled = false;
  bool get isButtonToggled => _isButtonToggled;

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

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_bottomCartService];
}
