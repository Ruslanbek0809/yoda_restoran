import 'package:firebase_core/firebase_core.dart';
import 'package:flash/flash.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/utils/utils.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../services/services.dart';

class StartUpViewModel extends StreamViewModel<ConnectivityStatus> {
  final log = getLogger('StartUpViewModel');

  final _apiRootService = locator<ApiRootService>();
  final _navService = locator<NavigationService>();
  final _pushNotificationService = locator<PushNotificationService>();
  final _hiveDbService = locator<HiveDbService>();
  final _userService = locator<UserService>();
  final _connectivityService = locator<ConnectivityService>();

  ConnectivityStatus? _connectivityStatus = ConnectivityStatus.Idle;
  ConnectivityStatus? get connectivityStatus => data;

  FlashController<Object?>? flashController;

  // bool _isFlashPersistent = false;
  // bool get startAnimation => _startAnimation;

  bool _startAnimation = false;
  bool get startAnimation => _startAnimation;

  Future<void> runStartupLogic() async {
    log.i('===== StartUpViewModel STARTED =====');
    // _startAnimation = true;
    // notifyListeners();

    /// FIREBASE initialization. This second Firebase.initializeApp() is used to initialize Firebase again in case network is down
    await Firebase.initializeApp()
        .then((value) => _pushNotificationService.initialise());

    await _apiRootService.initDio();
    await _hiveDbService.initDB();
    await _userService.initUser();

    _hiveDbService.getCartMeals(); // GETS all CART meals inside cartMealBox
    _hiveDbService.getCartRes(); // GETS CART restaurant inside cartResBox

    _navService.replaceWith(Routes.homeView);
    // await Future.delayed(Duration(milliseconds: 3009)).then((value) {
    //   if (connectivityStatus == ConnectivityStatus.Offline) {
    //     log.v('NO INTERNET SNACKBAR COMING: $data');
    //   } else if (connectivityStatus == null) {
    //     log.v('NO INTERNET NULLLLLLL: $data');
    //   } else {
    //     {
    //       log.v('HAVE AN INTERNET: $data');
    //       // _navService.replaceWith(Routes.homeView);
    //     }
    //   }
    // });
    // await Future.delayed(Duration(milliseconds: 6500)).then((value) {
    //   _navService.replaceWith(Routes.homeView);
    //   // _navService.replaceWith(Routes.ordersView);

    //   /// NAV next View based on condition
    //   // if (_userService.hasLoggedInUser) {
    //   //   log.v(
    //   //       'USER FOUND: ${_userService.currentUser!.mobile}, ${_userService.currentUser!.accessToken}');
    //   //   _navService.replaceWith(Routes.homeView);
    //   // } else {
    //   //   log.v('USER NOTTTTT FOUND');
    //   //   _navService.replaceWith(Routes.loginView);
    //   // }
    // });

    log.i('===== StartUpViewModel ENDED =====');
  }

  Future<void> navToHomeWithConnection() async {
    log.i('navToHomeWithConnection: $connectivityStatus');

    await Future.delayed(Duration(milliseconds: 1500));
    await runStartupLogic();
    await _navService.replaceWith(Routes.homeView);

    // await Future.delayed(Duration(milliseconds: 1500)).then((value) async{
    //   await runStartupLogic();
    //   await _navService.replaceWith(Routes.homeView);
    // });
  }

  Future<void> dismissFlashController() async {
    await flashController!.dismiss();
  }

  void updateConnectivityStatusIfIdle() {
    _connectivityStatus = ConnectivityStatus.Offline;
  }

  @override
  Stream<ConnectivityStatus> get stream =>
      _connectivityService.connectionStatusController.stream;
}
