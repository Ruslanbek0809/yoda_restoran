import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
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
          Container(
            decoration: BoxDecoration(
              color: kcSecondaryLightColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.BORDER_RADIUS_20),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --------------- MAIN CATEGORIES -------------- //
                  Container(
                    decoration: BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: AppTheme().radius20,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.kitchen,
                          style: ktsDefault24DarkText,
                        ).tr(),
                        GridView.builder(
                          padding: EdgeInsets.only(top: 10.h),
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
                  //--------------- MAIN CATEGORY OPEN RESTAURANTS MANUAL -------------- //
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: AppTheme().radius20,
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        LocaleKeys
                            .byOpenRestaurants, // Changes name of first element if location is enabled
                        style: TextStyle(
                          color: kcFontColor,
                          fontSize: 16.sp,
                        ),
                      ).tr(),
                      value: model.isByOpenRestaurantsChecked,
                      controlAffinity: ListTileControlAffinity.trailing,
                      checkColor: kcWhiteColor,
                      activeColor: kcGreenColor,
                      onChanged: (value) =>
                          model.updateIsOpenByRestaurants(value!),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       LocaleKeys
                    //           .byOpenRestaurants, // Changes name of first element if location is enabled
                    //       style: TextStyle(
                    //         color: kcFontColor,
                    //         fontSize: 16.sp,
                    //       ),
                    //     ).tr(),
                    //     Transform.scale(
                    //       scale: 1.25,
                    //       child: Checkbox(
                    //         checkColor: kcWhiteColor,
                    //         value: model.isByOpenRestaurantsChecked,
                    //         onChanged: (value) =>
                    //             model.updateIsOpenByRestaurants(value!),
                    //         activeColor: kcGreenColor,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                  //--------------- MAIN CATEGORY SORT MANUAL -------------- //
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: AppTheme().radius20,
                    ),
                    child: Column(  
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10.w, right: 10.w, bottom: 4.h),
                          child: Text(
                            LocaleKeys.showOrder,
                            style: ktsDefault24DarkText,
                          ).tr(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: mainCatSortList
                              .map<Widget>(
                                (FilterSort categoryFilter) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadioListTile<FilterSort>(
                                      value: categoryFilter,
                                      groupValue: model.selectedSort,
                                      onChanged: model.updateSelectedSort,
                                      title: Text(
                                        mainCatSortList.indexOf(
                                                        categoryFilter) ==
                                                    0 &&
                                                model.locationPosition != null
                                            ? LocaleKeys.sortByGeolocation
                                            : categoryFilter
                                                .name, // Changes name of first element if location is enabled
                                        style: TextStyle(
                                          color: kcFontColor,
                                          fontSize: 16.sp,
                                        ),
                                      ).tr(),
                                      activeColor: kcGreenColor,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      toggleable: true,
                                    ),
                                    if (mainCatSortList
                                            .indexOf(categoryFilter) !=
                                        mainCatSortList.length - 1)
                                      Divider(
                                        color: kcDividerColor,
                                        indent: 10.w,
                                        endIndent: 15.w,
                                      )
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 0.125.sh)
                      ],
                    ),
                  ),
                  // //--------------- MAIN CATEGORY SORT MANUAL -------------- //
                  // Container(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                  //   decoration: BoxDecoration(
                  //     color: kcWhiteColor,
                  //     borderRadius: AppTheme().radius20,
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.only(bottom: 10.h),
                  //         child: Text(
                  //           LocaleKeys.showOrder,
                  //           style: ktsDefault24DarkText,
                  //         ).tr(),
                  //       ),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: mainCatSortList
                  //             .map<Widget>(
                  //               (FilterSort categoryFilter) => Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Text(
                  //                         mainCatSortList.indexOf(
                  //                                         categoryFilter) ==
                  //                                     0 &&
                  //                                 model.locationPosition != null
                  //                             ? LocaleKeys.sortByGeolocation
                  //                             : categoryFilter
                  //                                 .name, // Changes name of first element if location is enabled
                  //                         style: TextStyle(
                  //                           color: kcFontColor,
                  //                           fontSize: 16.sp,
                  //                         ),
                  //                       ).tr(),
                  //                       Transform.scale(
                  //                         scale: 1.5,
                  //                         child: Radio<FilterSort>(
                  //                           value: categoryFilter,
                  //                           groupValue: model.selectedSort,
                  //                           onChanged: model.updateSelectedSort,
                  //                           activeColor: kcGreenColor,
                  //                           toggleable: true,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   if (mainCatSortList
                  //                           .indexOf(categoryFilter) !=
                  //                       mainCatSortList.length - 1)
                  //                     Divider(
                  //                       color: kcDividerColor,
                  //                       indent: 2.w,
                  //                       endIndent: 13.w,
                  //                     )
                  //                 ],
                  //               ),
                  //             )
                  //             .toList(),
                  //       ),
                  //       SizedBox(height: 0.125.sh)
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          //--------------- SORT SELECTIONS -------------- //
          MainCatSortBottom(),
        ],
      ),
    );
  }
}
