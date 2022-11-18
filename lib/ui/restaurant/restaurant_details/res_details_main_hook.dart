import 'dart:io';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../meal/meal_view.dart';
import '../../toggle_buttons/toggle_buttons_view.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'restaurant_info_bottom_sheet.dart';
import 'res_details_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ResDetailsMainHook extends HookViewModelWidget<ResDetailsViewModel> {
  final Restaurant restaurant;
  const ResDetailsMainHook({required this.restaurant, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, ResDetailsViewModel model) {
    double itemWidth = (1.sw - 12.w - 20.h) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth + 0.15.sh; // 0.15.sh is for item height

    //-------------- TAB CONTROLLER ----------------//
    final tabController = useTabController(
      initialLength: model.resCategories!.length,
      initialIndex: model.activeTab,
    );

    /// To dispose a listener attached to TabController
    useEffect(() {
      void _tabListener() => model.updateActiveTab(tabController.index);
      tabController.addListener(_tabListener);
      return () => tabController.removeListener(_tabListener);
    }, [tabController]); // tabController, key, is specified

    //-------------- CUSTOM SCROLL CONTROLLER ----------------//
    final ScrollController customScrollController = useScrollController();

    /// To dispose a listener attached to ScrollController
    useEffect(() {
      void _customScrollListener() =>
          model.updateLastScrollStatus(customScrollController.hasClients &&
              customScrollController.offset >
                  (0.55.sh - kToolbarHeight - 56.h));

      customScrollController.addListener(_customScrollListener);
      return () => customScrollController.removeListener(_customScrollListener);
    }, [customScrollController]); // _customScrollController, key, is specified

    return CustomScrollView(
      controller: customScrollController,
      physics: ClampingScrollPhysics(),
      slivers: [
        //------------------ ARROW BACK ---------------------//
        SliverAppBar(
          expandedHeight: 0.55.sh,
          pinned: true,
          stretch: true,
          backgroundColor: kcWhiteColor,
          centerTitle: true,
          title: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: model.isShrink
                ? Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 5.w),
                    child: Text(
                      restaurant.name!,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: kcFontColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : SizedBox(),
          ),
          leading: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Container(
              height: 50.w,
              width: 50.w,
              margin: EdgeInsets.only(left: 10.w, top: 5.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kcWhiteColor,
                // color: model.isShrink ? Colors.transparent : kcWhiteColor,
                // boxShadow: _isShrink ? [] : [AppTheme().buttonShadow],
              ),
              child: Material(
                color: kcWhiteColor,
                // color: model.isShrink ? Colors.transparent : kcWhiteColor,
                shape: CircleBorder(),
                elevation: 0,
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 27.w,
                    color: kcBlackColor,
                  ),
                ),
              ),
            ),
          ),
          //------------------ ACTIONS FAV ---------------------//
          actions: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: model.isShrink
                  ? SizedBox()
                  : AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.w),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: model.isShrink
                                ? Colors.transparent
                                : kcWhiteColor,
                            // boxShadow: _isShrink
                            //     ? []
                            //     : [AppTheme().buttonShadow],
                          ),
                          child: Material(
                            shape: CircleBorder(),
                            elevation: 0,
                            color: model.isShrink
                                ? Colors.transparent
                                : kcWhiteColor,
                            child: InkWell(
                              customBorder: CircleBorder(),
                              onTap: () => model.updateResFav(restaurant.id!),
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Icon(
                                  model.isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 27.w,
                                  color: model.isFavorited
                                      ? kcRedColor
                                      : kcBlackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(width: 10.w),
//------------------ ACTIONS SEARCH ---------------------//
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Padding(
                padding: EdgeInsets.only(top: 5.w),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kcWhiteColor,
                  ),
                  child: Material(
                    shape: CircleBorder(),
                    elevation: 0,
                    color: kcWhiteColor,
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () => model.navToResSearchView(),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.search_rounded,
                          size: 27.w,
                          color: kcBlackColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
          ],
          //------------------ BACKGROUND RESTAURANT IMAGE ---------------------//
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [StretchMode.zoomBackground],
            //// NOTE: Container background image used to add custom widget in front of this background image
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(restaurant.image!),
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
              //// NOTE: Instead of direct Container Column is used to make child work properly
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    padding: EdgeInsets.only(
                        top: Platform.isIOS ? 14.h : 12.h, bottom: 50.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //------------------ TITLE NAME ---------------------//
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: Platform.isIOS ? 12.h : 10.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          child: Text(
                            restaurant.name!,
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              color: kcSecondaryDarkColor,
                            ),
                          ),
                        ),
                        //------------------ RATE / WORK TIME / INFO---------------------//
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              //------------------ RATE ---------------------//
                              Container(
                                decoration: BoxDecoration(
                                  color: kcSecondaryLightColor,
                                  borderRadius: AppTheme().radius20,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 7.h),
                                margin: EdgeInsets.only(
                                  top: 5.h,
                                  bottom: 5.h,
                                  left: 16.w,
                                  right: 10.w,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/star.svg',
                                      color: kcSecondaryDarkColor,
                                      width: 20.w,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      formatNumRating(restaurant.rating!),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: kcFontColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //------------------ WORK TIME ---------------------//
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: kcPrimaryColor_LIGHT,
                              //     borderRadius: AppTheme().radius20,
                              //   ),
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 10.w, vertical: 7.h),
                              //   margin: EdgeInsets.symmetric(
                              //       vertical: 5.h, horizontal: 10.w),
                              //   child: Row(
                              //     children: [
                              //       SvgPicture.asset(
                              //         'assets/clock.svg',
                              //         color: kcSecondaryDarkColor,
                              //         width: 20.w,
                              //       ),
                              //       SizedBox(width: 5.w),
                              //       Text(
                              //         restaurant.workingHours!,
                              //         style: TextStyle(
                              //           fontSize: 16.sp,
                              //           color: kcFontColor,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // if (model.locationPosition != null)
                              //------------------ LOCATION ---------------------//
                              Container(
                                decoration: BoxDecoration(
                                  color: kcSecondaryLightColor,
                                  borderRadius: AppTheme().radius20,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 7.h),
                                margin: EdgeInsets.only(
                                  top: 5.h,
                                  bottom: 5.h,
                                  right: 10.w,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/map_pin_bold.svg',
                                      color: kcSecondaryDarkColor,
                                      width: 20.w,
                                    ),
                                    SizedBox(width: 3.w),
                                    // Below condition checks whether res is LOCAL one or NOT
                                    model.locationPosition != null &&
                                            restaurant.paymentTypes != null
                                        ? Row(
                                            children: [
                                              Text(
                                                '${restaurant.city} (${restaurant.distance} ',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: kcFontColor,
                                                ),
                                              ),
                                              Text(
                                                LocaleKeys.km,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: kcFontColor,
                                                ),
                                              ).tr(),
                                              Text(
                                                ')',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: kcFontColor,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            restaurant.city!,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: kcFontColor,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              //------------------ RESTAURANT INFO BOTTOM SHEET ---------------------//
                              //------------------ CUSTOM PACKAGE ---------------------//
                              GestureDetector(
                                /// CUSTOM BOTTOM SHEET BASED ON CONTENT
                                onTap: () async =>
                                    await showFlexibleBottomSheet(
                                  isExpand: false,
                                  initHeight: 0.95,
                                  maxHeight: 0.95,
                                  duration: Duration(milliseconds: 250),
                                  context: context,
                                  bottomSheetColor: Colors.transparent,
                                  builder: (context, scrollController, offset) {
                                    return RestaurantInfoBottomSheet(
                                      scrollController: scrollController,
                                      offset: offset,
                                      restaurant: restaurant,
                                    );
                                  },
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kcSecondaryLightColor,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 5.h),
                                  margin: EdgeInsets.only(right: 16.w),
                                  child: SvgPicture.asset(
                                    'assets/restaurant_info.svg',
                                    color: kcSecondaryDarkColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 16.w,
                          ),
                          child: Divider(
                            color: kcSecondaryLightColor,
                            thickness: 1.w,
                          ),
                        ),
//------------------ DELIVERY/SELF-PICKUP ---------------------//
                        ToggleButtonView(restaurant: restaurant),
                        //------------------ MAIN DIVIDER ---------------------//
                        Container(
                          color: kcMainDividerColor,
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          margin: EdgeInsets.only(top: 15.h),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //------------------ TABBAR ---------------------//
          bottom: ColoredTabBar(
            isShrink: model.isShrink ? true : false,
            tabBar: TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              labelPadding: EdgeInsets.all(0.0),
              tabs: model.resCategories!
                  .map<Widget>((resCategory) => Tab(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: AppTheme().radius15,
                            color: model.activeTab ==
                                    model.resCategories!.indexOf(resCategory)
                                ? model.isTabPressed
                                    ? kcSecondaryLightColor
                                    : kcWhiteColor
                                : kcWhiteColor,
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: 2.h,
                            horizontal: 5.w,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          alignment: Alignment.center,
                          child: Text(
                            resCategory.resCategoryModel!.name!,
                            style: kts14SemiBoldText,
                          ),
                        ),
                      ))
                  .toList(),
              onTap: (index) {
                model.updateOnTapRipple();
                double offset = model.resCategories!.getRange(0, index).fold(
                  0,
                  (prev, resCategory) {
                    int rows = (resCategory.meals!.length / 2).ceil();
                    return prev += rows *
                        (itemHeight +
                            15.h); // itemHeight + GridView mainAxisSpacing
                  },
                );

                customScrollController.animateTo(
                  offset + ((index - 1) * 72.h) + 0.55.sh,
                  // * 88.h FIRST COMPENSATION HERE // + 0.55.sh is to compensate Expanded height
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
                model.updateOnTapRipple();
              },
            ),
          ),
        ),
//------------------ MEAL LIST ---------------------//
        SliverPadding(
          padding: EdgeInsets.only(
              bottom: 0.11.sh), // COMPENSATES ResDetailsBottomCart height
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final resCategory = model.resCategories![index];
                final resCategoryMeals = resCategory.meals;
                return Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 12.w, top: 25.h),
                      child: Text(
                        resCategory.resCategoryModel!.name!,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: kcSecondaryDarkColor,
                        ),
                      ),
                    ),

                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   padding: EdgeInsets.only(left: 12.w, top: 12.h),
                    //   child: Text(
                    //     resCategory.resCategoryModel!.name!,
                    //     style: TextStyle(
                    //       fontSize: 22.sp,
                    //       fontWeight: FontWeight.bold,
                    //       color: kcSecondaryDarkColor,
                    //     ),
                    //   ),
                    // ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 10.w,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h, //spaceTopBottom
                        crossAxisSpacing: 6.w, //spaceLeftRight
                        childAspectRatio: itemWidth / itemHeight,
                      ),
                      itemCount: resCategoryMeals!.length,
                      itemBuilder: (context, pos) {
                        return MealView(
                          meal: resCategoryMeals[pos],
                          restaurant:
                              restaurant, // Needed for add meal with conditions only in CART
                        );
                      },
                    ),
                  ],
                );
              },
              childCount: model.resCategories!.length,
            ),
          ),
        ),
      ],
    );
  }
}
