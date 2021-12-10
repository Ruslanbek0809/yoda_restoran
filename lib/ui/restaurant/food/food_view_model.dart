import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

/// ReactiveViewModel is used to "react"
class FoodViewModel extends ReactiveViewModel {
  final log = getLogger('FoodViewModel');

  final _bottomCartService = locator<BottomCartService>();

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

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_bottomCartService];
}
