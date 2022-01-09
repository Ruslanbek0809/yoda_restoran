import 'package:carousel_slider/carousel_controller.dart';
import 'package:stacked/stacked.dart';

class SliderViewModel extends BaseViewModel {
  int _activeIndex = 0;
  int get activeIndex => _activeIndex;

  CarouselController? _carouselController;
  CarouselController? get carouselController => _carouselController;

  void updateActiveIndex(int index) {
    _activeIndex = index;
    notifyListeners();
  }
}
