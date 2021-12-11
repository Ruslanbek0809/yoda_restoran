import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/restaurant/meal/meal_view.dart';
import 'package:yoda_res/ui/toggle_buttons/toggle_buttons_view.dart';
import 'package:yoda_res/utils/utils.dart';

import 'restaurant_details_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResDetailsMainWidget
    extends HookViewModelWidget<RestaurantDetailsViewModel> {
  final Restaurant restaurant;
  const ResDetailsMainWidget({required this.restaurant, Key? key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, RestaurantDetailsViewModel model) {
    double itemWidth = (1.sw - 5.w * 2 - 20.w) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing) / crossAxisCount
    double itemHeight = itemWidth + 0.3.sw; // 0.4.sw is for item height

    //-------------- TAB CONTROLLER ----------------//
    final tabController = useTabController(
      initialLength: foodCategoryList.length,
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
                  (0.55.sh - kToolbarHeight - 50.w));

      customScrollController.addListener(_customScrollListener);
      return () => customScrollController.removeListener(_customScrollListener);
    }, [customScrollController]); // _customScrollController, key, is specified

    return CustomScrollView(
      controller: customScrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        //------------------ ARROW BACK ---------------------//
        SliverAppBar(
          expandedHeight: 0.55.sh,
          pinned: true,
          stretch: true,
          floating: false,
          backgroundColor: AppTheme.WHITE,
          centerTitle: true,
          title: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: model.isShrink
                ? Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 5.w),
                    child: Text(
                      'Kebapçy',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppTheme.FONT_COLOR,
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
                color: model.isShrink ? Colors.transparent : AppTheme.WHITE,
                // boxShadow: _isShrink ? [] : [AppTheme().buttonShadow],
              ),
              child: Material(
                color: model.isShrink ? Colors.transparent : AppTheme.WHITE,
                shape: CircleBorder(),
                elevation: 0,
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 27.w,
                    color: AppTheme.BLACK,
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
                                : AppTheme.WHITE,
                            // boxShadow: _isShrink
                            //     ? []
                            //     : [AppTheme().buttonShadow],
                          ),
                          child: Material(
                            shape: CircleBorder(),
                            elevation: 0,
                            color: model.isShrink
                                ? Colors.transparent
                                : AppTheme.WHITE,
                            child: InkWell(
                              customBorder: CircleBorder(),
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Icon(
                                  Icons.favorite_outline_outlined,
                                  size: 27.w,
                                  color: AppTheme.BLACK,
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
                    color: model.isShrink ? Colors.transparent : AppTheme.WHITE,
                    // boxShadow: _isShrink ? [] : [AppTheme().buttonShadow],
                  ),
                  child: Material(
                    shape: CircleBorder(),
                    elevation: 0,
                    color: model.isShrink ? Colors.transparent : AppTheme.WHITE,
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: model.navToResSearchView,
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.search,
                          size: 27.w,
                          color: AppTheme.BLACK,
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
                  image: AssetImage('assets/burgerlist.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              //// NOTE: Instead of direct Container Column is used to make child work properly
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.WHITE,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    padding: EdgeInsets.only(top: 17.h, bottom: 50.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //------------------ TITLE NAME ---------------------//
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          child: Text(
                            'Kebapçy',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.MAIN_DARK,
                            ),
                          ),
                        ),
                        //------------------ RATE / WORK TIME / INFO---------------------//
                        Row(
                          children: [
                            //------------------ RATE ---------------------//
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.MAIN_LIGHT,
                                borderRadius: AppTheme().radius20,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 7.h),
                              margin: EdgeInsets.only(
                                top: 5.w,
                                bottom: 5.w,
                                left: 16.w,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: AppTheme.MAIN_DARK,
                                    size: 22.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //------------------ WORK TIME ---------------------//
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.MAIN_LIGHT,
                                borderRadius: AppTheme().radius20,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 7.h),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 10.w),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    color: AppTheme.MAIN_DARK,
                                    size: 22.w,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    '10:00 - 22:00',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // TODO: Uncomment and fix Info
                            // //------------------ INFO ---------------------//
                            // GestureDetector(
                            //   onTap: () => _onRestaurantInfoPressed(),
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       color: AppTheme.MAIN_LIGHT,
                            //       shape: BoxShape.circle,
                            //     ),
                            //     padding: EdgeInsets.symmetric(
                            //         horizontal: 5.w, vertical: 5.h),
                            //     child: SvgPicture.asset(
                            //       'assets/restaurant_info.svg',
                            //       color: AppTheme.FONT_COLOR,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 16.w,
                          ),
                          child: Divider(
                            color: AppTheme.MAIN_LIGHT,
                            thickness: 1.w,
                          ),
                        ),
//------------------ DELIVERY/SELF-PICKUP ---------------------//
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ToggleButtonView(),
                        ),
                        //------------------ MAIN DIVIDER ---------------------//
                        Container(
                          color: AppTheme.MAIN_DIVIDER_COLOR,
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
            color: AppTheme.WHITE,
            tabBar: TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              labelPadding: EdgeInsets.all(0.0),
              tabs: foodCategoryList
                  .map<Widget>((category) => Tab(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: AppTheme().radius15,
                            color: model.activeTab ==
                                    foodCategoryList.indexOf(category)
                                ? model.isTabPressed
                                    ? AppTheme.MAIN_LIGHT
                                    : AppTheme.WHITE
                                : AppTheme.WHITE,
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: 3.w,
                            horizontal: 5.w,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          alignment: Alignment.center,
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: AppTheme.FONT_COLOR,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              onTap: (index) {
                model.updateOnTapRipple();
                double offset = foodCategoryList.getRange(0, index).fold(
                  0,
                  (prev, category) {
                    int rows = (mealList.length / 2)
                        .ceil(); // food length to crossAxisCount
                    return prev +=
                        rows * (itemHeight + 24.w); // GridView vertical padding
                  },
                );

                customScrollController.animateTo(
                  offset +
                      ((index - 1) * 50.w) +
                      0.55.sh -
                      45.w, // * 50.w is same with each Food category title height // + 0.55.sh is to compensate 0.55.sh expanded height // + 45.w is for tab title
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
                model.updateOnTapRipple();
              },
            ),
          ),
        ),
//------------------ FOOD LIST with NAME ---------------------//
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: foodCategoryList.length,
                separatorBuilder: (context, index) {
                  if (index < foodCategoryList.length) {
                    FoodCategory category = foodCategoryList[index + 1];

                    return Container(
                      height: 50.w,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Text(
                            category.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemBuilder: (context, index) {
                  return GridView.builder(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.w, //spaceTopBottom
                      crossAxisSpacing: 5.w, //spaceLeftRight
                      // mainAxisSpacing: 12.h, //spaceTopBottom
                      // crossAxisSpacing: 8.w, //spaceLeftRight
                      childAspectRatio: itemWidth / itemHeight,
                    ),
                    itemCount: mealList.length,
                    itemBuilder: (context, pos) {
                      return MealView(
                        meal: mealList[pos],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({required this.color, required this.tabBar});

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}
