import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

class AboutUsViewModel extends FutureViewModel {
  final log = getLogger('AboutUsViewModel');

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  List<AdditionalModel>? _additionals = [];
  List<AdditionalModel>? get additionals => _additionals;

  bool _isAboutUsTermSelected = false;
  bool get isAboutUsTermSelected => _isAboutUsTermSelected;

  @override
  Future<void> futureToRun() async {
    _additionals = await _userService.getAdditionals();
    log.v('_additionals!.length: ${_additionals!.length}');
  }

  //*UPDATES _isAboutUsTermSelected
  void updateIsAboutUsTermSelected() {
    _isAboutUsTermSelected = !_isAboutUsTermSelected;
    notifyListeners();
  }

//*----------------------- NAVIGATIONS ----------------------------//

  //*NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);
}
