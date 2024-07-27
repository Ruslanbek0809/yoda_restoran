import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../generated/locale_keys.g.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

class ToggleButtonViewModel extends ReactiveViewModel {
  final log = getLogger('ToggleButtonViewModel');

  final _toggleButtonService = locator<ToggleButtonService>();

  bool get isDelivery => _toggleButtonService.isDelivery;

  //*UPDATES isDelivery to FALSE (USES _toggleButtonService)
  void updateToggleToDelivery() =>
      _toggleButtonService.updateToggleToDelivery();

  /// UPDATES isDelivery to TRUE (USES _toggleButtonService)
  void updateToggleToSelfPickUp() =>
      _toggleButtonService.updateToggleToSelfPickUp();

  /// SWITCHES isDelivery (USES _toggleButtonService)
  void switchToggleButton() => _toggleButtonService.switchToggleButton();

  FlashController? _flashController;

  Future<void> showCustomFlashBar({
    required BuildContext context,
    String msg = LocaleKeys.errorOccured,
    Duration duration = const Duration(seconds: 2),
  }) async {
    await showCustomFlashBarWithFlashController(
      context: context,
      flashController: _flashController,
      msg: msg,
      duration: duration,
    );
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_toggleButtonService];
}
