import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../services/services.dart';

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
