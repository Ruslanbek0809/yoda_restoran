import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/utils/utils.dart';

class MainCategoryViewModel extends BaseViewModel {
  final log = getLogger('MainCategoryViewModel');

  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  List<int> _multiSelectionList = [];

  /// Function to check wether this mainCegory selected or NOT
  bool isMainCategorySelected(int? mainCategoryId) =>
      _multiSelectionList.contains(mainCategoryId);

  /// Function to ADD or REMOVE mainCategory to/from _multiSelectionList
  void updateMainCategoryItem(int? mainCategoryId) {
    if (_multiSelectionList.contains(mainCategoryId)) {
      _multiSelectionList.remove(mainCategoryId);
    } else {
      _multiSelectionList.add(mainCategoryId!);
    }
    log.i(_multiSelectionList);
    notifyListeners();
  }

  Future showCustomBottomSheet() async {
    log.i('showCustomBottomSheet');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.mainCategory,
      enableDrag: true,
      isScrollControlled: true,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     top: Radius.circular(Constants.BORDER_RADIUS_20),
      //   ),
      // ),
      // barrierColor: Colors.transparent,
      // backgroundColor: Colors.transparent,
    );
  }
}
