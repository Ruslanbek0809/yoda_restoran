import 'package:stacked/stacked.dart';
import '../app/app.logger.dart';
import '../utils/utils.dart';

// 1 For Reactive Views
class BottomCartService with ReactiveServiceMixin {
  final log = getLogger('BottomCartService');

  BottomCartService() {
    // 3
    listenToReactiveValues([_bottomCartStatus, _isUpdateQuantity]);
  }

  // 2
  ReactiveValue<BottomCartStatus> _bottomCartStatus =
      ReactiveValue<BottomCartStatus>(BottomCartStatus.idle);
  BottomCartStatus get bottomCartStatus => _bottomCartStatus.value;

  // To update quantity of bottomCart
  ReactiveValue<bool> _isUpdateQuantity = ReactiveValue<bool>(false);
  bool get isUpdateQuantity => _isUpdateQuantity.value;

  //*HIDES BottomCart
  void hideBottomCart() {
    switch (_bottomCartStatus.value) {
      case BottomCartStatus.forward:
        _bottomCartStatus.value = BottomCartStatus.reverse;
        break;
      case BottomCartStatus.reverse:
        break;
      default:
        _bottomCartStatus.value = BottomCartStatus.reverse;
        break;
    }
    log.i(_bottomCartStatus.value);
  }

  //*SHOWS BottomCart
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

  //*UPDATE ResDetailsBottomCart QUANTITY (Workaround)
  Future<void> updateResBottomCartQuantity() async {
    _isUpdateQuantity.value = true;
    await Future.delayed(Duration(seconds: 1));
    _isUpdateQuantity.value = false;
  }
}
