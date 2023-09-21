import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/ui/drawer/my_credit_cards/my_credit_cards_add_edit/my_credit_card_add_view.dart';
import 'package:yoda_res/ui/drawer/my_credit_cards/my_credit_cards_view.dart';
import 'package:yoda_res/ui/home/moments/moment_story_view.dart';
import 'package:yoda_res/ui/home/moments/moments_all/moments_all_view.dart';

import '../services/services.dart';
import '../ui/cart/cart_view.dart';
import '../ui/cart/order/order_success_view.dart';
import '../ui/cart/order/orders_view.dart';
import '../ui/drawer/about_us/about_us_view.dart';
import '../ui/drawer/addresses/addresses.dart';
import '../ui/drawer/contact_us/contact_us_view.dart';
import '../ui/drawer/login/login_view.dart';
import '../ui/drawer/otp/otp_view.dart';
import '../ui/drawer/profile/profile_view.dart';
import '../ui/home/home_exclusives/single_ex_view.dart';
import '../ui/home/home_search/home_search_view.dart';
import '../ui/home/home_view.dart';
import '../ui/home/restaurants/restaurants_view.dart';
import '../ui/home/slider/slider_webview.dart';
import '../ui/restaurant/restaurant_details/res_details_view.dart';
import '../ui/restaurant/restaurant_search/restaurant_search_view.dart';
import '../ui/startup/onboarding/onboarding_view.dart';
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
    MaterialRoute(page: OrderSuccessView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: AddressesView),
    MaterialRoute(page: AddressAddView),
    MaterialRoute(page: AddressEditView),
    MaterialRoute(page: HomeSearchView),
    MaterialRoute(page: ContactUsView),
    MaterialRoute(page: AboutUsView),
    MaterialRoute(page: OnBoardingView),
    MaterialRoute(page: SingleExView),
    MaterialRoute(page: SliderWebview),
    MaterialRoute(page: RestaurantsView),
    MaterialRoute(page: MyCreditCardsView),
    MaterialRoute(page: MyCreditCardAddView),
    MaterialRoute(page: MomentStoryView),
    MaterialRoute(page: MomentsAllView),
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
    LazySingleton(classType: MainCatService),
    LazySingleton(classType: CartService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: ToggleButtonService),
    LazySingleton(classType: CheckoutService),
    LazySingleton(classType: OrderService),
    LazySingleton(classType: ConnectivityService),
    LazySingleton(classType: SearchService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: GeolocatorService),
    LazySingleton(classType: DynamicLinkService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
