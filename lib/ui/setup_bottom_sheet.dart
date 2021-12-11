import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/utils/utils.dart';

import 'home/main_category_bottom_sheet/main_category_bottom_view.dart';

void setupBottomSheet() {
  final _bottomSheetService = locator<BottomSheetService>();

  final bottomSheetBuilders = {
    BottomSheetType.mainCategory: (context, sheetRequest, completer) =>
        MainCategoryBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
  };

  _bottomSheetService.setCustomSheetBuilders(bottomSheetBuilders);
}
