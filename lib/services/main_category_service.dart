import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';

// 1 For Reactive Views
class MainCategoryService with ReactiveServiceMixin {
  final log = getLogger('MainCategoryService');

  MainCategoryService() {
    // 3
    listenToReactiveValues([_multiSelectionList]);
  }

  // 2
  ReactiveValue<List<int>> _multiSelectionList = ReactiveValue<List<int>>([]);
  List<int> get multiSelectionList=> _multiSelectionList.value;

  /// Function to ADD or REMOVE mainCategory to/from _multiSelectionList
  void updateMainCategoryItem(int? mainCategoryId) {
    log.i('');
    if (_multiSelectionList.value.contains(mainCategoryId)) {
      _multiSelectionList.value.remove(mainCategoryId);
    } else {
      _multiSelectionList.value.add(mainCategoryId!);
    }
  }

  // ReactiveValue<BottomCartStatus> _bottomCartStatus =
  //     ReactiveValue<BottomCartStatus>(BottomCartStatus.idle);
  // BottomCartStatus get bottomCartStatus => _bottomCartStatus.value;

  /// Function to update isBottomCartShown
  // void updateBottomCartStatus() {
  //   switch (_bottomCartStatus.value) {
  //     case BottomCartStatus.idle:
  //       _bottomCartStatus.value = BottomCartStatus.forward;
  //       break;
  //     case BottomCartStatus.forward:
  //       _bottomCartStatus.value = BottomCartStatus.reverse;
  //       break;
  //     case BottomCartStatus.reverse:
  //       _bottomCartStatus.value = BottomCartStatus.forward;
  //       break;
  //     default:
  //       _bottomCartStatus.value = BottomCartStatus.idle;
  //       break;
  //   }
  //   log.i(_bottomCartStatus.value);
  // }
}
