import 'package:stacked/stacked.dart';

import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../services/services.dart';

class ToggleButtonViewModel extends ReactiveViewModel {
  final log = getLogger('ToggleButtonViewModel');

  final _toggleButtonService = locator<ToggleButtonService>();

  bool get isDelivery => _toggleButtonService.isDelivery;

  //*UPDATES isDelivery to FALSE (USES _toggleButtonService)
  void updateToggleToDelivery() =>
      _toggleButtonService.updateToggleToDelivery();

  //*UPDATES isDelivery to TRUE (USES _toggleButtonService)
  void updateToggleToSelfPickUp() =>
      _toggleButtonService.updateToggleToSelfPickUp();

  //*SWITCHES isDelivery (USES _toggleButtonService)
  void switchToggleButton() => _toggleButtonService.switchToggleButton();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_toggleButtonService];
}
