import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../../models/models.dart';
import '../../../utils/utils.dart';
import 'main_cat_bottom_sort.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main_cat_bottom_view_model.dart';
import 'main_cat_item_bottom_hook.dart';
import 'package:easy_localization/easy_localization.dart';

class MainCatBottomSheetView extends StatelessWidget {
  final ScrollController scrollController;
  final double offset;
  const MainCatBottomSheetView({
    Key? key,
    required this.scrollController,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainCatBottomViewModel>.reactive(
      onModelReady: (model) => model.assignTempCats(),
      viewModelBuilder: () => MainCatBottomViewModel(),
      builder: (context, model, child) => Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --------------- MAIN CATEGORIES -------------- //
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.kitchen,
                        style: ktsDefault24DarkText,
                      ).tr(),
                      GridView.builder(
                        padding: EdgeInsets.only(top: 8.h),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        child: Text(
                          LocaleKeys.showOrder,
                          style: ktsDefault24DarkText,
                        ).tr(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: mainCatSortList
                            .map<Widget>(
                              (CategoryFilter categoryFilter) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile<CategoryFilter>(
                                    value: categoryFilter,
                                    groupValue: model.selectedSort,
                                    onChanged: model.updateSelectedSort,
                                    title: Text(
                                      mainCatSortList.indexOf(categoryFilter) ==
                                                  0 &&
                                              model.locationPosition != null
                                          ? LocaleKeys.sortByGeolocation
                                          : categoryFilter
                                              .name, // Changes name of first element if location is enabled
                                      style: TextStyle(
                                        color: AppTheme.FONT_COLOR,
                                        fontSize: 16.sp,
                                      ),
                                    ).tr(),
                                    activeColor: AppTheme.GREEN_COLOR,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    toggleable: true,
                                  ),
                                  if (mainCatSortList.indexOf(categoryFilter) !=
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
    );
  }
}
