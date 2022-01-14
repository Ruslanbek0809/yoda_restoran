import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/services/services.dart';

class HomeSearchViewModel extends BaseViewModel {
  final log = getLogger('HomeSearchViewModel');

  final _searchService = locator<SearchService>();

  String? _searchText = '';
  String? get searchText => _searchText;

  /// STARTS MAIN SEARCH and GETS result
  Future<void> startMainSearch(String? searchText) async {
    log.i('startMainSearch() searchText: $searchText');
    _searchText = searchText;
    if (searchText != null && searchText.isEmpty || searchText!.length < 3)
      return;

    try {
      await runBusyFuture(_searchService.startMainSearch(searchText));
      // log.v('CHECKOUT VM _promocode: $_promocode');
    } catch (err) {
      throw err;
    }
  }

  /// STARTS MAIN SEARCH and GETS result
  void clearSearch() {
    log.i('clearSearch()');
    _searchText = '';
    notifyListeners();
  }
}
