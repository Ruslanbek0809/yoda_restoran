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

  List<AboutUsModel>? _aboutUsList = [];
  List<AboutUsModel>? get aboutUsList => _aboutUsList;

  bool _isAboutUsTermSelected = false;
  bool get isAboutUsTermSelected => _isAboutUsTermSelected;

  @override
  Future<void> futureToRun() async {
    _aboutUsList = await _userService.getAboutUs();
    log.v('_aboutUsList!.length: ${_aboutUsList!.length}');
  }

  /// UPDATES _isAboutUsTermSelected
  void updateIsAboutUsTermSelected() {
    _isAboutUsTermSelected = !_isAboutUsTermSelected;
    notifyListeners();
  }

//------------------------ NAVIGATIONS ----------------------------//

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);
}
