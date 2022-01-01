import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../models/models.dart';

class ResViewModel extends BaseViewModel {
  final log = getLogger('ResViewModel');

  final _navService = locator<NavigationService>();

  bool _isFavorited = false;
  bool get isFavorited => _isFavorited;

  void updateResFavorite() {
    _isFavorited = !_isFavorited;
    log.i('_isFavorited: $_isFavorited');
    notifyListeners();
  }

  void navToResDetailsView(Restaurant restaurant) => _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(restaurant: restaurant),
      );
}
