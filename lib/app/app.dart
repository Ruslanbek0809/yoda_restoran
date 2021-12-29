import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/ui/cart/cart_view.dart';
import 'package:yoda_res/ui/home/home_view.dart';
import 'package:yoda_res/ui/profile/login/login_view.dart';
import 'package:yoda_res/ui/profile/otp/otp_view.dart';
import 'package:yoda_res/ui/restaurant/restaurant_details/res_details_view.dart';
import 'package:yoda_res/ui/restaurant/restaurant_search/restaurant_search_vew.dart';
import 'package:yoda_res/ui/startup/startup_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: ResDetailsView),
    MaterialRoute(page: RestaurantSearchView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: OtpView),
    MaterialRoute(page: CartView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: ApiRootService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: UserApiService),
    LazySingleton(classType: HomeService),
    LazySingleton(classType: BottomCartService),
    LazySingleton(classType: ResService),
    LazySingleton(classType: MainCatService),
    LazySingleton(classType: PushNotificationService),
    LazySingleton(classType: HiveDbService),
    LazySingleton(classType: CartService),
    LazySingleton(classType: MainFilterService),
    LazySingleton(classType: UserService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
