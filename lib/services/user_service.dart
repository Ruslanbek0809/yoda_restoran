import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/utils/utils.dart';

class UserService {
  final log = getLogger('UserService');

  // User? _currentUser;

  // User get currentUser => _currentUser!;

  // bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;

  /// INITIALIZE in StartUpViewModel
  Future initUser() async {
    log.v('====== UserService STARTED opening boxes ======');

    await Hive.openBox<HiveUser>(Constants.cartResBox);

    log.v('====== UserService ENDED opening boxes ======');
  }
}
