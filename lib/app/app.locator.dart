// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/services.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => ApiRootService());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => UserApiService());
  locator.registerLazySingleton(() => HomeService());
  locator.registerLazySingleton(() => BottomCartService());
  locator.registerLazySingleton(() => RestaurantService());
  locator.registerLazySingleton(() => MainCategoryService());
}
