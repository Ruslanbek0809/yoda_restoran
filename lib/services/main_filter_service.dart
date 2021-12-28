import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/utils/utils.dart';

// 1 For Reactive Views
class MainFilterService with ReactiveServiceMixin {
  final log = getLogger('MainFilterService');

  MainFilterService() {
    // 3
    listenToReactiveValues([_bottomCartStatus]);
  }

  // 2
  ReactiveValue<BottomCartStatus> _bottomCartStatus =
      ReactiveValue<BottomCartStatus>(BottomCartStatus.idle);
  BottomCartStatus get bottomCartStatus => _bottomCartStatus.value;

  /// SHOWS BottomCart
  void showBottomCart() {
    switch (_bottomCartStatus.value) {
      case BottomCartStatus.idle:
        _bottomCartStatus.value = BottomCartStatus.forward;
        break;
      case BottomCartStatus.reverse:
        _bottomCartStatus.value = BottomCartStatus.forward;
        break;
      case BottomCartStatus.forward:
        break;
      default:
        _bottomCartStatus.value = BottomCartStatus.forward;
        break;
    }
    log.i(_bottomCartStatus.value);
  }

  /// HIDES BottomCart
  void hideBottomCart() {
    switch (_bottomCartStatus.value) {
      case BottomCartStatus.forward:
        _bottomCartStatus.value = BottomCartStatus.reverse;
        break;
      case BottomCartStatus.reverse:
        _bottomCartStatus.value = BottomCartStatus.idle;
        break;
      default:
        _bottomCartStatus.value = BottomCartStatus.idle;
        break;
    }
    log.i(_bottomCartStatus.value);
  }
}
