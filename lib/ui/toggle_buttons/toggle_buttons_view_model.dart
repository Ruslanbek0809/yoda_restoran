import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';

class ToggleButtonViewModel extends BaseViewModel {
  final log = getLogger('ToggleButtonViewModel');
  bool _isDelivery = false;
  bool get isDelivery => _isDelivery;

  void updateToggleType() {
    _isDelivery = !_isDelivery;
    log.i('_isDelivery: $_isDelivery');
    notifyListeners();
  }
}
