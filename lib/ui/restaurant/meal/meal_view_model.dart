import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/meal.dart';
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

  /// Function to update updateBottomCartStatus
  void updateBottomCartStatus() {
    _bottomCartService.updateBottomCartStatus();

    log.i('bottomCartStatus: $bottomCartStatus');
    notifyListeners();
  }

  /// Function to update isButtonToggled
  void updateButtonToggle() {
    _isButtonToggled = !_isButtonToggled;
    log.i('_isButtonToggled: $_isButtonToggled');
    notifyListeners();
  }

  /// Function to call MealBottomSheet
  Future showCustomMealBottomSheet(Meal meal) async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.meal,
      enableDrag: true,
      isScrollControlled: true,
      data: meal,
    );
  }

  // AdditionalFoodModel? selectedAdditional;

  // void _setSelectedAdditionalFood(AdditionalFoodModel? additionalFoodModel) {
  //   setState(() {
  //     selectedAdditional = additionalFoodModel;
  //   });
  // }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_bottomCartService];
}
