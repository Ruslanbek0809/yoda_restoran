import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';

// 1 For Reactive Views
class MainFilterService with ReactiveServiceMixin {
  final log = getLogger('MainFilterService');

  MainFilterService() {
    // 3
    listenToReactiveValues([_mainFilterAnimationStatus]);
  }

  ReactiveValue<MainFilterAnimationStatus> _mainFilterAnimationStatus =
      ReactiveValue<MainFilterAnimationStatus>(MainFilterAnimationStatus.idle);
  MainFilterAnimationStatus get mainFilterAnimationStatus =>
      _mainFilterAnimationStatus.value;

  /// UPDATES _mainFilterAnimationStatus
  void updateMainAnimationFilterStatus(
      CategoryFilter? selectedSort, List<int> selectedMainCats) {
    log.v(
        'selectedMainCats length: ${selectedMainCats.length} and selectedSort: ${selectedSort!.name}');
        
    switch (_mainFilterAnimationStatus.value) {
      case MainFilterAnimationStatus.idle:
        if (selectedMainCats.isNotEmpty || selectedSort != mainCatSortList[0]) {
          _mainFilterAnimationStatus.value = MainFilterAnimationStatus.forward;
        }
        break;
      case MainFilterAnimationStatus.forward:
        if (selectedMainCats.isEmpty && selectedSort == mainCatSortList[0]) {
          _mainFilterAnimationStatus.value = MainFilterAnimationStatus.reverse;
        }
        break;
      case MainFilterAnimationStatus.reverse:
        if (selectedMainCats.isNotEmpty || selectedSort != mainCatSortList[0]) {
          _mainFilterAnimationStatus.value = MainFilterAnimationStatus.forward;
        }
        break;
      default:
        _mainFilterAnimationStatus.value = MainFilterAnimationStatus.idle;
        break;
    }
    log.v(
        '_mainFilterAnimationStatus.value: ${_mainFilterAnimationStatus.value}');
  }
}
