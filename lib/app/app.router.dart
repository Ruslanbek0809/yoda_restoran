// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../ui/home/home_view.dart';
import '../ui/restaurant/restaurant_details/restaurant_details_view.dart';
import '../ui/restaurant/restaurant_search/restaurant_search_vew.dart';
import '../ui/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String homeView = '/home-view';
  static const String restaurantDetailsView = '/restaurant-details-view';
  static const String restaurantSearchView = '/restaurant-search-view';
  static const all = <String>{
    startUpView,
    homeView,
    restaurantDetailsView,
    restaurantSearchView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.restaurantDetailsView, page: RestaurantDetailsView),
    RouteDef(Routes.restaurantSearchView, page: RestaurantSearchView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
    RestaurantDetailsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => RestaurantDetailsView(),
        settings: data,
      );
    },
    RestaurantSearchView: (data) {
      var args = data.getArgs<RestaurantSearchViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => RestaurantSearchView(
            bottomCartController: args.bottomCartController),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// RestaurantSearchView arguments holder class
class RestaurantSearchViewArguments {
  final AnimationController bottomCartController;
  RestaurantSearchViewArguments({required this.bottomCartController});
}
