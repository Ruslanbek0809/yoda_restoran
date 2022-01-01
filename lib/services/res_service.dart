import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';

import 'api_service.dart';

class ResService {
  final log = getLogger('ResService');
  final _api = locator<ApiService>();

  List<ResCategory>? _resCategories = [];
  List<ResCategory>? get resCategories => _resCategories;

  bool get hasResCategories =>
      _resCategories != null && _resCategories!.isNotEmpty;

  Future<List<ResCategory>?> getResCatsWithMeals(int restaurantId) async {
    _resCategories = await _api.getResCatsWithMeals(restaurantId);
    log.i(_resCategories!.length);
    return _resCategories;
  }
}
