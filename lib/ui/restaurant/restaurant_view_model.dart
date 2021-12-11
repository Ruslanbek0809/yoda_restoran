import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/models.dart';

class RestaurantViewModel extends BaseViewModel {
  final log = getLogger('RestaurantViewModel');

  final _navService = locator<NavigationService>();

  bool _isFavorited = false;
  bool get isFavorited => _isFavorited;

  void updateResFavorite() {
    _isFavorited = !_isFavorited;
    log.i('_isFavorited: $_isFavorited');
    notifyListeners();
  }

  void navToResDetailsView(Restaurant restaurant) => _navService.navigateTo(
        Routes.restaurantDetailsView,
        arguments: RestaurantDetailsViewArguments(restaurant: restaurant),
      );
}
