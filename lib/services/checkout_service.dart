import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';

import 'api_service.dart';
import 'hv_db_service.dart';

class CheckoutService {
  final log = getLogger('CartService');

  final _api = locator<ApiService>();
  final _hiveDbService = locator<HiveDbService>();

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  /// SEARCHES promocodes and GETS first
  Future<void> searchPromocode(String searchText) async {
    log.v('searchText: $searchText, resId: ${_hiveDbService.cartRes!.id!}');

    _promocode =
        await _api.searchPromocode(searchText, _hiveDbService.cartRes!.id!);
  }
}
