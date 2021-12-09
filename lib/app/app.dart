import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/services/home_service.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/services/user_api_service.dart';
import 'package:yoda_res/ui/home/home_view.dart';
import 'package:yoda_res/ui/restaurant/restaurant_details/restaurant_details_view.dart';
import 'package:yoda_res/ui/startup/startup_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: RestaurantDetailsView),
    // MaterialRoute(page: HomeView),
    // MaterialRoute(page: HomeView),
    // MaterialRoute(page: HomeView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: ApiRootService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: UserApiService),
    LazySingleton(classType: HomeService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
