import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/utils/utils.dart';

import 'home/main_category_bottom_sheet/main_category_bottom_sheet_view.dart';
import 'restaurant/restaunant_bottom_sheets/restaurant_info_bottom_sheet.dart';

void setupBottomSheet() {
  final _bottomSheetService = locator<BottomSheetService>();

  final bottomSheetBuilders = {
    BottomSheetType.mainCategory: (context, sheetRequest, completer) =>
        MainCategoryBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.restaurantInfo: (context, sheetRequest, completer) =>
        RestaurantInfoBottomSheetWidget(
          request: sheetRequest,
          completer: completer,
          restaurant: sheetRequest.data,
        ),
  };

  _bottomSheetService.setCustomSheetBuilders(bottomSheetBuilders);
}
