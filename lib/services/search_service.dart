import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

class SearchService {
  final log = getLogger('SearchService');
  final _api = locator<ApiService>();

  //*STARTS MAIN SEARCH and GETS result
  Future<List<SearchRestaurant?>> startMainSearch(String searchText) async {
    final result = await _api.startMainSearch(searchText);
    return result;
  }

  //*SEARCHES for meals and GETS result
  Future<List<Meal?>> searchMeals(
    String searchText,
    int resId,
  ) async {
    final result = await _api.searchMeals(searchText, resId);
    return result;
  }
}
