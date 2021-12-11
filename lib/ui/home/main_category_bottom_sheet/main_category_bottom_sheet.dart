import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/home/main_category/main_category_view_model.dart';
import 'package:yoda_res/utils/utils.dart';
import 'main_category_item_bottom.dart';

class MainCategoryBottomSheetView
    extends HookViewModelWidget<MainCategoryViewModel> {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const MainCategoryBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key, reactive: true);

  // _filterButtonAnimationController =
  //     AnimationController(duration: Duration(milliseconds: 100), vsync: this);
  // _filterButtonAnimation =
  //     IntTween(begin: 0, end: 100).animate(_filterButtonAnimationController);
  // _filterButtonAnimation.addListener(() => setState(() {}));

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
      }
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        height: 0.95.sh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constants.BORDER_RADIUS_20)),
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constants.BORDER_RADIUS_20),
                ),
                color: Colors.transparent,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 17.5.w,
                      width: 40.w,
                      child: SvgPicture.asset(
                        'assets/bottom_sheet_dragger.svg',
                        color: AppTheme.WHITE,
                      ),
                    ),
                    // --------------- KITCHEN CATEGORIES -------------- //
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Constants.BORDER_RADIUS_20),
                        ),
                        color: AppTheme.WHITE,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 30.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aşhana',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GridView.builder(
                            padding: EdgeInsets.only(top: 10.w),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10.h, //spaceTopBottom
                              crossAxisSpacing: 10.w, //spaceLeftRight
                              childAspectRatio: 0.75,
                            ),
                            itemCount: model.mainCategories!.length,
                            itemBuilder: (context, pos) {
                              return MainCategoryItemBottom(
                                mainCategory: model.mainCategories![pos],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    //--------------- MAIN CATEGORY SORT -------------- //
                    Container(
                      color: AppTheme.WHITE,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              'Görkezmeli tertibi',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: mainCategorySortList
                                .mapIndexed<Widget>(
                                  (CategoryFilter categoryFilter, int pos) =>
                                      Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RadioListTile<CategoryFilter>(
                                        value: categoryFilter,
                                        groupValue: model.selectedSort,
                                        onChanged: model.updateSelectedSort,
                                        title: Text(
                                          categoryFilter.name,
                                          style: TextStyle(
                                            color: AppTheme.FONT_COLOR,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        activeColor: AppTheme.GREEN_COLOR,
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        toggleable: true,
                                      ),
                                      if (pos !=
                                          mainCategorySortList.length - 1)
                                        Divider(
                                          color: AppTheme.DRAWER_DIVIDER,
                                          indent: 10.w,
                                          endIndent: 15.w,
                                        )
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(height: 0.175.sh)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //--------------- FILTER BUTTONS -------------- //
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: AppTheme.WHITE,
                    border: Border.all(
                        color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
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
                          onPressed: () {
                            // if (_filterButtonAnimationController.value == 0.0) {
                            //   _filterButtonAnimationController.forward();
                            // } else {
                            //   _filterButtonAnimationController.reverse();
                            // }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
