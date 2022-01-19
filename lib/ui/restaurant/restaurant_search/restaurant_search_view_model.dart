import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';

class RestaurantSearchViewModel extends BaseViewModel {
  final log = getLogger('RestaurantSearchViewModel');
  final int resId;
  RestaurantSearchViewModel(this.resId);

  final _searchService = locator<SearchService>();
  final _navService = locator<NavigationService>();

  String? _searchText = '';
  String? get searchText => _searchText;

  List<SearchRestaurant?> _searchRestaurants = [];
  List<SearchRestaurant?> get searchRestaurants => _searchRestaurants;

  /// SEARCHES for meals and GETS result
  Future<void> searchMeals(String? searchText) async {
    log.i('searchMeals() searchText: $searchText');
    _searchText = searchText;

    if (_searchText!.isEmpty) clearSearch();

    if (searchText!.isEmpty || searchText.length < 3) return;

    _searchRestaurants =
        await runBusyFuture(_searchService.searchMeals(searchText, resId));
    log.i('searchMeals() RESULT: ${_searchRestaurants.length}');
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
