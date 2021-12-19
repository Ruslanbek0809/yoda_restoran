import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/ui/home/main_category/main_category_view_model.dart';
import 'package:yoda_res/utils/utils.dart';

class MainCatSortBottom extends HookViewModelWidget<MainCategoryViewModel> {
  const MainCatSortBottom({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(
      BuildContext context, MainCategoryViewModel model) {
    final sortAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
    );
    final _sortAnimationValue =
        IntTween(begin: 0, end: 100).animate(sortAnimationController);

    /// sortAnimationController trigger
    if (model.sortAnimationStatus != SortAnimationStatus.idle)
      switch (sortAnimationController.status) {
        case AnimationStatus.completed:
          if (model.sortAnimationStatus == SortAnimationStatus.reverse)
            sortAnimationController.reverse();
          break;
        case AnimationStatus.dismissed:
          if (model.sortAnimationStatus == SortAnimationStatus.forward)
            sortAnimationController.forward();
          break;
        default:
          break;
      }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
            color: AppTheme.WHITE,
            border: Border.all(color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
            boxShadow: [AppTheme().bottomCartShadow]),
        padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 25.w),
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: _sortAnimationValue.value,
                child: SizedBox(
                  width: 0.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.MAIN_LIGHT,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppTheme().radius15),
                      padding: EdgeInsets.symmetric(vertical: 17.w),
                    ),
                    child: FittedBox(
                      child: Text(
                        'Arassala',
                        style: TextStyle(
                          color: AppTheme.FONT_COLOR,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(width: 12.5.w),
              Expanded(
                flex: 100,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.MAIN,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppTheme().radius15),
                    padding: EdgeInsets.symmetric(vertical: 17.w),
                  ),
                  child: Text(
                    'Tassykla',
                    style: TextStyle(
                      color: AppTheme.WHITE,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
