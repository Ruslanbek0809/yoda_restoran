import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../../models/models.dart';
import '../main_category/main_cat_view_model.dart';
import '../../../utils/utils.dart';
import 'main_cat_bottom_sort.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main_cat_item_bottom_hook.dart';

class MainCatBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const MainCatBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainCatViewModel>.reactive(
      onModelReady: (model) => model.assignTempList(),
      viewModelBuilder: () => MainCatViewModel(),
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 1,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constants.BORDER_RADIUS_20),
            ),
            color: kcWhiteColor,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: SvgPicture.asset(
                        'assets/bottom_sheet_dragger.svg',
                        color: kcSecondaryLightColor,
                        height: 6.h,
                      ),
                    ),
                    // --------------- MAIN CATEGORIES -------------- //
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Constants.BORDER_RADIUS_20),
                        ),
                        color: AppTheme.WHITE,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Aşhana', style: kts22Text),
                          GridView.builder(
                            padding: EdgeInsets.only(top: 8.h),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 0.h, //spaceTopBottom
                              crossAxisSpacing: 5.w, //spaceLeftRight
                              childAspectRatio: 0.75,
                            ),
                            itemCount: model.mainCats!.length,
                            itemBuilder: (context, pos) {
                              return MainCategoryItemBottomHook(
                                mainCategory: model.mainCats![pos],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    //--------------- MAIN CATEGORY SORT -------------- //
                    Container(
                      color: AppTheme.WHITE,
                      padding: EdgeInsets.symmetric(horizontal: 5.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text('Görkezmeli tertibi', style: kts22Text),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: mainCatSortList
                                .map<Widget>(
                                  (CategoryFilter categoryFilter) => Column(
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
                                      if (mainCatSortList
                                              .indexOf(categoryFilter) !=
                                          mainCatSortList.length - 1)
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
              //--------------- SORT SELECTIONS -------------- //
              MainCatSortBottom(),
            ],
          ),
        ),
      ),
    );
  }
}
