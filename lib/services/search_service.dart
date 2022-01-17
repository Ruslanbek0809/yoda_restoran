import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

class SearchService {
  final log = getLogger('SearchService');

  final _api = locator<ApiService>();
  final _hiveDbService = locator<HiveDbService>();

  /// STARTS MAIN SEARCH and GETS result
  Future<List<SearchRestaurant?>> startMainSearch(String searchText) async {
    // await Future.delayed(Duration(seconds: 1));
    final result = await _api.startMainSearch(searchText);
    return result;
  }
}
