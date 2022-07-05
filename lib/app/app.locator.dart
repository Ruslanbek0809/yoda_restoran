// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/services.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => HiveDbService());
  locator.registerLazySingleton(() => ApiRootService());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => HomeService());
  locator.registerLazySingleton(() => BottomCartService());
  locator.registerLazySingleton(() => MainCatService());
  locator.registerLazySingleton(() => CartService());
  locator.registerLazySingleton(() => MainFilterService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => ToggleButtonService());
  locator.registerLazySingleton(() => CheckoutService());
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => SearchService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => GeolocatorService());
  locator.registerLazySingleton(() => DynamicLinkService());
}
