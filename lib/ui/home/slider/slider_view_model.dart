import 'package:carousel_slider/carousel_controller.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';

class SliderViewModel extends BaseViewModel {
  final log = getLogger('SliderViewModel');

  final _navService = locator<NavigationService>();

  int _activeIndex = 0;
  int get activeIndex => _activeIndex;

  CarouselController? _carouselController;
  CarouselController? get carouselController => _carouselController;

  void updateActiveIndex(int index) {
    _activeIndex = index;
    notifyListeners();
  }

  //------------------ NAVIGATION ---------------------//

  void navToResDetailsView(Restaurant restaurant) => _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(restaurant: restaurant),
      );

  void navToSliderWebview(String sliderUrl) => _navService.navigateTo(
        Routes.sliderWebview,
        arguments: SliderWebviewArguments(sliderUrl: sliderUrl),
      );
}
