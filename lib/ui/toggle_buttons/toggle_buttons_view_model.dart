import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/services/services.dart';

class ToggleButtonViewModel extends ReactiveViewModel {
  final log = getLogger('ToggleButtonViewModel');

  final _toggleButtonService = locator<ToggleButtonService>();

  bool get isDelivery => _toggleButtonService.isDelivery;

  /// UPDATES isDelivery var (USES _toggleButtonService)
  void updateToggleButton() {
    _toggleButtonService.updateToggleButton();
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_toggleButtonService];
}
