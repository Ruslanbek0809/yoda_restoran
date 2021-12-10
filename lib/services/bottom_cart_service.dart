import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/utils/utils.dart';

class BottomCartService {
  final log = getLogger('BottomCartService');

  BottomCartStatus _bottomCartStatus = BottomCartStatus.idle;
  BottomCartStatus get bottomCartStatus => _bottomCartStatus;

  /// Function to update isBottomCartShown
  void updateBottomCartStatus() {
    log.i('');
    switch (_bottomCartStatus) {
      case BottomCartStatus.idle:
        _bottomCartStatus = BottomCartStatus.forward;
        break;
      case BottomCartStatus.forward:
        _bottomCartStatus = BottomCartStatus.reverse;
        break;
      case BottomCartStatus.reverse:
        _bottomCartStatus = BottomCartStatus.forward;
        break;
      default:
        _bottomCartStatus = BottomCartStatus.idle;
        break;
    }
  }
}
