import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/toggle_buttons/toggle_buttons_view.dart';
import 'package:yoda_res/utils/utils.dart';
import 'restaurant_details_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResDetailsMainWidget
    extends HookViewModelWidget<RestaurantDetailsViewModel> {
  final Restaurant restaurant;
  const ResDetailsMainWidget({required this.restaurant, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, RestaurantDetailsViewModel model) {
    print('itemWidth 0.3.sw:${0.3.sw} and sh: 0.2.sh');
    double itemWidth = (1.sw - 12.w - 20.h) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth + 0.31.sw; // 0.31.sw is for item height

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
                  (0.55.sh - kToolbarHeight - 40.h)); // - 40 for Tab height

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
                      restaurant.name!,
                      overflow: TextOverflow.fade,
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
                  image: CachedNetworkImageProvider(restaurant.image!),
                  fit: BoxFit.cover,
                  // AssetImage('assets/burgerlist.jpg'),
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
                            restaurant.name!,
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
                                    restaurant.rating.toString(),
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
                                    restaurant.workingHours!,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // //------------------ INFO ---------------------//
                            GestureDetector(
                              onTap: () {
                                model.showCustomBottomSheet(restaurant);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.MAIN_LIGHT,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 5.h),
                                child: SvgPicture.asset(
                                  'assets/restaurant_info.svg',
                                  color: AppTheme.MAIN_DARK,
                                ),
                              ),
                            ),
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
                            vertical: 2.h,
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
                    int rows = (mealList.length / 2).ceil();
                    return prev += rows *
                        (itemHeight +
                            20.h); // GridView mainAxisSpacing * 2 SECOND MAIN COMPENSATION HERE
                  },
                );

                customScrollController.animateTo(
                  offset + ((index - 1) * 30.h) + 0.55.sh - 40.h,
                  // * 30.h FIRST COMPENSATION HERE // + 0.55.sh is to compensate 0.55.sh expanded height // + 45.h is for tab title
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
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: foodCategoryList.length,
                itemBuilder: (context, index) {
                  FoodCategory category = foodCategoryList[index];
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 12.w, top: 7.h),
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
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
                        itemCount: mealList.length,
                        itemBuilder: (context, pos) {
                          return Container(color: Colors.blue);
                        },
                      ),
                    ],
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
