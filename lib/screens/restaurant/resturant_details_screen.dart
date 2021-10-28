import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'food_widget.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int activetab = 0;

  late ScrollController _sliverScrollController;
  bool lastStatus = true;
  bool isTabPressed = false;

  late AnimationController bottomCartController;
  late Animation<Offset> bottomCartOffset;

  void _scrollListener() {
//// Animate to currentTab when listview scrools
    // printLog("offset = ${_sliverScrollController.offset}");
    // currentTab = (_sliverScrollController.offset) ~/
    //     ((_foodList.length / 2).ceil() * (1.2.sw));
    // // currentTab = (_sliverScrollController.offset) ~/
    // //     ((_foodList.length / 2).ceil() * (1.sw / 1.65.sw));
    // print(
    //     'currentTab=> $currentTab ${(_foodList.length / 2).ceil()} ${1.sw} ${0.55.sh} ${(1.sw / 1.65.sw)}');
    // _tabController.animateTo(currentTab);

//// For SliverAppBar
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _sliverScrollController.hasClients &&
        _sliverScrollController.offset > (0.55.sh - kToolbarHeight - 50.w);
  }

  void _tabListener() {
    setState(() {
      activetab = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: foodCategoryList.length,
    );
    _tabController.addListener(_tabListener);
    _sliverScrollController = ScrollController()..addListener(_scrollListener);

    bottomCartController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    bottomCartOffset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(bottomCartController);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sliverScrollController.removeListener(_scrollListener);
    _sliverScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = (1.sw - 5.w * 2 - 20.w) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview horizontal padding) / crossAxisCount

    double itemHeight = itemWidth + 0.3.sw; // 0.4.sw is for item height
    printLog('ItemHeight: $itemHeight and expected ${0.75.sw}');
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _sliverScrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
//------------------ ARROW BACK ---------------------//
              SliverAppBar(
                expandedHeight: 0.55.sh,
                pinned: true,
                stretch: true,
                floating: false,
                backgroundColor: AppTheme.WHITE,
                centerTitle: false,
                title: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _isShrink
                      ? Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 5.w),
                          child: Text(
                            'Kebapçy',
                            style: TextStyle(fontSize: 20.sp),
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
                      color: _isShrink ? Colors.transparent : AppTheme.WHITE,
                      // boxShadow: _isShrink ? [] : [AppTheme().buttonShadow],
                    ),
                    child: Material(
                      color: _isShrink ? Colors.transparent : AppTheme.WHITE,
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
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.w),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _isShrink ? Colors.transparent : AppTheme.WHITE,
                          // boxShadow: _isShrink
                          //     ? []
                          //     : [AppTheme().buttonShadow],
                        ),
                        child: Material(
                          shape: CircleBorder(),
                          elevation: 0,
                          color:
                              _isShrink ? Colors.transparent : AppTheme.WHITE,
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
                  SizedBox(width: 10.w),
//------------------ ACTIONS SEARCH ---------------------//
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.w),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _isShrink ? Colors.transparent : AppTheme.WHITE,
                          // boxShadow: _isShrink ? [] : [AppTheme().buttonShadow],
                        ),
                        child: Material(
                          shape: CircleBorder(),
                          elevation: 0,
                          color:
                              _isShrink ? Colors.transparent : AppTheme.WHITE,
                          child: InkWell(
                            customBorder: CircleBorder(),
                            onTap: () {},
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
                          fit: BoxFit.cover),
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
                          padding: EdgeInsets.fromLTRB(15.w, 15.w, 15.w, 55.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Kebapçy',
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.MAIN_DARK,
                                ),
                              ),
                              SizedBox(height: 10.w),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.MAIN_LIGHT,
                                      borderRadius: AppTheme().mainBorderRadius,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.5.w, vertical: 7.5.w),
                                    margin: EdgeInsets.symmetric(vertical: 5.w),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppTheme.MAIN_DARK,
                                          size: 24.w,
                                        ),
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
                                  SizedBox(width: 10.w),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.MAIN_LIGHT,
                                      borderRadius: AppTheme().mainBorderRadius,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.5.w, vertical: 10.w),
                                    margin: EdgeInsets.symmetric(vertical: 5.w),
                                    child: Text(
                                      '45-55 min',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppTheme.FONT_COLOR,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.MAIN_LIGHT,
                                      borderRadius: AppTheme().mainBorderRadius,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.5.w, vertical: 10.w),
                                    margin: EdgeInsets.symmetric(vertical: 5.w),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Eltip bermek ',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppTheme.FONT_COLOR,
                                          ),
                                        ),
                                        Text(
                                          '20 TMT',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppTheme.FONT_COLOR,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.MAIN_LIGHT,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(5.w),
                                    child: SvgPicture.asset(
                                      'assets/restaurant_info.svg',
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: AppTheme.MAIN_LIGHT,
                                thickness: 1.w,
                              ),
//------------------ DELIVERY/SELF-PICKUP ---------------------//
                              ToggleButtonWidget(),
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
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.all(0.0),
                    tabs: foodCategoryList
                        .map<Widget>((category) => Tab(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  borderRadius: AppTheme().buttonBorderRadius,
                                  color: activetab ==
                                          foodCategoryList.indexOf(category)
                                      ? isTabPressed
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
                                    color: activetab ==
                                            foodCategoryList.indexOf(category)
                                        ? isTabPressed
                                            ? AppTheme.FONT_COLOR
                                            : AppTheme.DRAWER_ICON
                                        : AppTheme.DRAWER_ICON,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                    onTap: (index) {
                      setState(() {
                        isTabPressed = true;
                      });
                      double offset = foodCategoryList.getRange(0, index).fold(
                        0,
                        (prev, category) {
                          int rows = (foodList.length / 2)
                              .ceil(); // food length to crossAxisCount
                          return prev += rows *
                              (itemHeight + 24.w); // GridView vertical padding
                        },
                      );

                      _sliverScrollController.animateTo(
                        offset +
                            ((index - 1) * 50.w) +
                            0.55.sh -
                            45.w, // * 50.w is same with each Food category title height // + 0.55.sh is to compensate 0.55.sh expanded height // + 45.w is for tab title
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                      Timer(Duration(milliseconds: 1200), () {
                        setState(() {
                          isTabPressed = false;
                        });
                      });
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(
                                  category.name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 15.w, horizontal: 10.w),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.w, //spaceTopBottom
                            crossAxisSpacing: 5.w, //spaceLeftRight
                            childAspectRatio: itemWidth / itemHeight,
                          ),
                          itemCount: foodList.length,
                          itemBuilder: (context, pos) {
                            return FoodWidget(
                              food: foodList[pos],
                              animationController: bottomCartController,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
//------------------ BOTTOM CART ---------------------//
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: bottomCartOffset,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RouteList.cart);
                },
                child: Container(
                  height: 0.22.sw,
                  width: 1.sw,
                  decoration: BoxDecoration(color: AppTheme.WHITE, boxShadow: [
                    AppTheme().bottomCartShadow,
                  ]),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 15.w),
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: AppTheme.MAIN,
                      borderRadius: AppTheme().containerRadius,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '40-50 min',
                          style: TextStyle(
                            color: AppTheme.WHITE,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          'Sargyt',
                          style: TextStyle(
                            color: AppTheme.WHITE,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '35 TMT',
                          style: TextStyle(
                            color: AppTheme.WHITE,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SubcategoryTabs extends StatefulWidget {
  final List<FoodCategory> categories;
  final Function(int)? onItemPressed;

  SubcategoryTabs({
    required this.categories,
    this.onItemPressed,
  });

  @override
  _SubcategoryTabsState createState() => _SubcategoryTabsState();
}

class _SubcategoryTabsState extends State<SubcategoryTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.categories.length,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        unselectedLabelColor: AppTheme.MAIN,
        tabs: widget.categories
            .map<Widget>((category) => Tab(text: category.name))
            .toList(),
        onTap: widget.onItemPressed,
      ),
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
