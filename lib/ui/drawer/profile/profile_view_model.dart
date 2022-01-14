import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class ProfileViewModel extends BaseViewModel {
  final log = getLogger('ProfileViewModel');

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();

  HiveUser? get currentUser => _userService.currentUser;
  bool get hasLoggedInUser => _userService.hasLoggedInUser;

  String? _name;
  String? get name => _name;

  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;

  String? _gender;
  String? get gender => _gender;

  String? _email;
  String? get email => _email;

  String? _phone;
  String? get phone => _phone;

  /// LOGOUTS a user from app
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.accessToken);
    await _userService.logoutUser();
    await _hiveDbService.clearCart();
    await navToHomeByRemovingAll();
  }

  /// ASSIGNS currentUser value
  void assignCurrentUserValues() {
    log.v('assignCurrentUserValues()');

    _name = currentUser?.firstName;

    _birthDate = currentUser?.birthday;

    _gender = currentUser?.gender;

    _email = currentUser?.email;

    _phone = currentUser!.mobile;
  }

  /// UPDATES _name
  String? updateName(String? value) {
    log.v('updateName value: $value');
    // if (value!.isEmpty) {
    //   return 'Ady giriziň';
    // }

    _name = value;
    notifyListeners();
  }

  /// UPDATES _birthDate
  String? updateBirthDate(DateTime? value) {
    log.v('updateBirthDate value: $value');
    // if (value!.isEmpty) {
    //   return 'Doglan senäňizi giriziň';
    // }

    _birthDate = value;
    notifyListeners();
  }

  /// UPDATES _gender
  String? updateGender(String? value) {
    log.v('updateGender value: $value');
    // if (value!.isEmpty) {
    //   return 'Jynsy giriziň';
    // }

    _gender = value;
    notifyListeners();
  }

  /// UPDATES _email
  String? updateEmail(String? value) {
    log.v('updateEmail value: $value');
    // if (value!.isEmpty) {
    //   return 'Elektron poçtaňyzy giriziň';
    // }

    _email = value;
    notifyListeners();
  }

  /// UPDATES _email
  String? updatePhone(String? value) {
    log.v('updatePhone value: $value');
    if (value == null || value.isEmpty || value.length < 11) {
      return 'Nomeri doly giriziň';
    }

    _phone = value;
    notifyListeners();
  }

  /// UPDATES user info
  Future<void> onUpdateUserPressed() async {
    log.v('onUpdateUserPressed()');
    try {
      await runBusyFuture(_userService.updateUser(
        _name,
        _birthDate,
        _gender,
        _email,
        _phone,
      ));
    } catch (err) {
      throw err;
    }
  }

//------------------------ NAVIGATIONS ----------------------------//

  void navBack() => _navService.back();

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);
}
