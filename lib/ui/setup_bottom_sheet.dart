import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/ui/restaurant/meal/meal_bottom_sheet_view.dart';
import 'package:yoda_res/utils/utils.dart';
import 'cart/checkout_bottom_sheet_view/checkout_bottom_sheet_view.dart';
import 'home/main_cat_bottom_sheet/main_cat_bottom_sheet_view.dart';
import 'restaurant/restaurant_info_bottom_sheet.dart';

void setupBottomSheet() {
  final _bottomSheetService = locator<BottomSheetService>();

  final bottomSheetBuilders = {
    BottomSheetType.mainCategory: (context, sheetRequest, completer) =>
        MainCatBottomSheetView(
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
          meal: sheetRequest.data.meal,
          restaurant: sheetRequest.data.restaurant,
          mealViewModel: sheetRequest.data.mealViewModel,
        ),
    BottomSheetType.checkout: (context, sheetRequest, completer) =>
        CheckoutBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
    BottomSheetType.paymentType: (context, sheetRequest, completer) =>
        CheckoutBottomSheetView(
          request: sheetRequest,
          completer: completer,
        ),
  };

  _bottomSheetService.setCustomSheetBuilders(bottomSheetBuilders);
}
