import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';

class HomeSearchViewModel extends BaseViewModel {
  final log = getLogger('HomeSearchViewModel');

  final _searchService = locator<SearchService>();
  final _navService = locator<NavigationService>();

  String? _searchText = '';
  String? get searchText => _searchText;

  List<SearchRestaurant?> _searchRestaurants = [];
  List<SearchRestaurant?> get searchRestaurants => _searchRestaurants;

  /// STARTS MAIN SEARCH and GETS result
  Future<void> startMainSearch(String? searchText) async {
    log.i('startMainSearch() searchText: $searchText');
    _searchText = searchText;

    if (_searchText!.isEmpty) clearSearch();

    if (searchText!.isEmpty || searchText.length < 3) return;

    _searchRestaurants =
        await runBusyFuture(_searchService.startMainSearch(searchText));
    log.i('startMainSearch() RESULT: ${_searchRestaurants.length}');
  }

  /// CLEARS Search
  void clearSearch() {
    log.i('clearSearch()');
    _searchText = '';
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
