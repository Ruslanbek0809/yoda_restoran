import 'package:stacked/stacked.dart';

import '../app/app.logger.dart';

// 1 Here ReactiveServiceMixin is used when any of these values change the listeners registered with this service will be notified to update their UI
class ToggleButtonService with ReactiveServiceMixin {
  final log = getLogger('ToggleButtonService');

  ToggleButtonService() {
    // 3
    listenToReactiveValues([_isDelivery]);
  }

  // 2
  ReactiveValue<bool> _isDelivery = ReactiveValue<bool>(true);

  bool get isDelivery => _isDelivery.value;

  void updateToggleToDelivery() {
    _isDelivery.value = true;
    log.i('_isDelivery.value: ${_isDelivery.value}');
  }

  void updateToggleToSelfPickUp() {
    _isDelivery.value = false;
    log.i('_isDelivery.value: ${_isDelivery.value}');
  }

  void switchToggleButton() {
    _isDelivery.value = !_isDelivery.value;
    log.i('_isDelivery.value: ${_isDelivery.value}');
  }
}
