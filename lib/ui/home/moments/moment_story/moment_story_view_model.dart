import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.logger.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../models/models.dart';

class MomentStoryViewModel extends BaseViewModel {
  final log = getLogger('MomentStoryViewModel');

  final _navService = locator<NavigationService>();

//*----------------------- NAVIGATION ----------------------------//

  Future<void> navToResDetailsView(Restaurant restaurant) async =>
      await _navService.navigateTo(
        Routes.resDetailsView,
        arguments: ResDetailsViewArguments(restaurant: restaurant),
      );
}
