import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

class HomeSearchViewModel extends BaseViewModel {
  final log = getLogger('HomeSearchViewModel');

  final _searchService = locator<SearchService>();
  final _navService = locator<NavigationService>();
  final _homeService = locator<HomeService>();

  // String? _searchText = '';
  // String? get searchText => _searchText;
  TextEditingController? _searchController = TextEditingController(text: '');
  TextEditingController? get searchController => _searchController;

  List<MainCategory>? get searchMainCats => _homeService.searchMainCats;

  List<SearchRestaurant?> _searchRestaurants = [];
  List<SearchRestaurant?> get searchRestaurants => _searchRestaurants;

  /// STARTS MAIN SEARCH and GETS result
  Future<void> startMainSearch(String? searchText) async {
    log.i('startMainSearch() searchText: $searchText');
    _searchController!.text = searchText!;

    if (_searchController!.text.isEmpty) clearSearch();

    if (searchText.isEmpty || searchText.length < 3) return;

    dynamic result =
        await runBusyFuture(_searchService.startMainSearch(searchText));
    log.v(
        'startMainSearch() result: $result and _searchRestaurants: ${result.length}');
    if (result != null) {
      _searchRestaurants.clear();
      _searchRestaurants = result;
    }
  }

  /// CLEARS Search
  void clearSearch() {
    log.i('clearSearch()');
    _searchController!.text = '';
    _searchRestaurants = [];
    notifyListeners();
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back();

  void navToResDetailsView(Restaurant restaurant) => _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(restaurant: restaurant),
      );
}
