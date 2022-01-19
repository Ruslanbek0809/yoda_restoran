import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';

class RestaurantSearchViewModel extends BaseViewModel {
  final log = getLogger('RestaurantSearchViewModel');
  final int resId;
  RestaurantSearchViewModel(this.resId);

  final _searchService = locator<SearchService>();
  final _navService = locator<NavigationService>();
  final _hiveDbService = locator<HiveDbService>();

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

  String? _searchText = '';
  String? get searchText => _searchText;

  List<Meal?> _searchMealss = [];
  List<Meal?> get searchMealss => _searchMealss;

  /// SEARCHES for meals and GETS result
  Future<void> searchMeals(String? searchText) async {
    log.i('searchMeals() searchText: $searchText');
    _searchText = searchText;

    if (_searchText!.isEmpty) clearSearch();

    if (searchText!.isEmpty || searchText.length < 3) return;

    dynamic result =
        await runBusyFuture(_searchService.searchMeals(searchText, resId));
    log.v(
        'searchMeals() result: $result and _searchMealss: ${_searchMealss.length}');
    if (result != null) {
      _searchMealss.clear();
      _searchMealss = result;
    }
  }

  /// CLEARS Search
  void clearSearch() {
    log.i('clearSearch()');
    _searchText = '';
    _searchMealss = [];
    notifyListeners();
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back(result: true);

  void navToResDetailsView(Restaurant restaurant) => _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(restaurant: restaurant),
      );
}
