import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/ui/restaurant/meal/meal_bottom_sheet_view.dart';
import 'package:yoda_res/utils/utils.dart';

import 'home/main_category_bottom_sheet/main_category_bottom_sheet_view.dart';
import 'restaurant/restaurant_info_bottom_sheet.dart';

void setupBottomSheet() {
  final _bottomSheetService = locator<BottomSheetService>();

  final bottomSheetBuilders = {
    BottomSheetType.mainCategory: (context, sheetRequest, completer) =>
        MainCategoryBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.restaurantInfo: (context, sheetRequest, completer) =>
        RestaurantInfoBottomSheet(
          request: sheetRequest,
          completer: completer,
          restaurant: sheetRequest.data,
        ),
    BottomSheetType.meal: (context, sheetRequest, completer) => MealBottomSheet(
          request: sheetRequest,
          completer: completer,
          meal: sheetRequest.data,
        ),
  };

  _bottomSheetService.setCustomSheetBuilders(bottomSheetBuilders);
}
