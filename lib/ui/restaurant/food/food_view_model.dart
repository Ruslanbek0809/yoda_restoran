import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class FoodViewModel extends BaseViewModel {
  final log = getLogger('FoodViewModel');

  final _bottomCartService = locator<BottomCartService>();
  BottomCartStatus get bottomCartStatus => _bottomCartService
      .bottomCartStatus; // Here I retrieved bottomCartStatus for log ONLY

  /// Function to update updateBottomCartStatus
  void updateBottomCartStatus() {
    _bottomCartService.updateBottomCartStatus();

    log.i('bottomCartStatus: $bottomCartStatus');
    notifyListeners();
  }
}
