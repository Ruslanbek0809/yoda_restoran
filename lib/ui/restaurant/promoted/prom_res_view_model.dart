import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/models.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';

class PromResViewModel extends BaseViewModel {
  final log = getLogger('PromResViewModel');

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
