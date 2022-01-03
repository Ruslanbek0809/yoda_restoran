import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/ui/cart/order/order_success_screen.dart';
import 'package:yoda_res/ui/cart/order/orders_view.dart';

import '../services/services.dart';
import '../ui/cart/cart_view.dart';
import '../ui/home/home_view.dart';
import '../ui/profile/login/login_view.dart';
import '../ui/profile/otp/otp_view.dart';
import '../ui/restaurant/restaurant_details/res_details_view.dart';
import '../ui/restaurant/restaurant_search/restaurant_search_vew.dart';
import '../ui/startup/startup_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: ResDetailsView),
    MaterialRoute(page: RestaurantSearchView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: OtpView),
    MaterialRoute(page: CartView),
    MaterialRoute(page: OrdersView),
    // MaterialRoute(page: OrderSuccessView),
  ],
  dependencies: [
    LazySingleton(classType: HiveDbService),
    LazySingleton(classType: ApiRootService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: PushNotificationService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: HomeService),
    LazySingleton(classType: BottomCartService),
    LazySingleton(classType: ResService),
    LazySingleton(classType: MainCatService),
    LazySingleton(classType: CartService),
    LazySingleton(classType: MainFilterService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: ToggleButtonService),
    LazySingleton(classType: CheckoutService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
