import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'food_widget.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  RestaurantDetailsScreen({Key? key}) : super(key: key);

  @override
  RestaurantDetailsScreenState createState() => RestaurantDetailsScreenState();
}

class RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController bottomCartController;
  late Animation<Offset> bottomCartOffset;

  late TabController _tabController;

  var top = 0.0;
  late ScrollController _scrollController;
  bool lastStatus = true;
  bool isDelivery = true;
  int _activeIndex = 0;

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  void _tabListener() {
    setState(() {
      _activeIndex = _tabController.index;
    });
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (0.5.sh - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);
    _tabController =
        TabController(length: foodCategoryList.length, vsync: this);
    _tabController.addListener(_tabListener);

    bottomCartController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    bottomCartOffset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(bottomCartController);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    bottomCartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
//var tabBarHeight = primaryTabBar.preferredSize.height;
    var pinnedHeaderHeight =
//statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight;
    return Scaffold(
      backgroundColor: AppTheme.WHITE,
      body: ExtendedNestedScrollView(
          controller: _scrollController,
          // onlyOneScrollInBody: true,
          headerSliverBuilder: (c, f) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 0.5.sh,
                floating: false,
                stretch: true,
                pinned: true,
                backgroundColor: AppTheme.WHITE,
                leading: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    height: 50.w,
                    width: 50.w,
                    margin: EdgeInsets.only(left: 10.w, top: 5.w),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isShrink ? Colors.transparent : AppTheme.WHITE,
                        boxShadow: _isShrink ? [] : [AppTheme().buttonShadow]),
                    child: Material(
                      color: _isShrink ? Colors.transparent : AppTheme.WHITE,
                      shape: CircleBorder(),
                      elevation: 0,
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () {},
                        child: Icon(
                          Icons.arrow_back,
                          size: 27.w,
                          color: AppTheme.BLACK,
                        ), // other widget
                      ),
                    ),
                  ),
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      stretchModes: [StretchMode.zoomBackground],
                      centerTitle: false,
                      title: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: top ==
                                MediaQuery.of(context).padding.top +
                                    kToolbarHeight
                            ? Text(
                                'Kebapçy',
                                style: TextStyle(fontSize: 17.sp),
                              )
                            : SizedBox(),
                      ),
                      background: Stack(
                        children: [
//// IMAGE Widget
                          Positioned(
                            top: 0,
                            right: 0.0,
                            left: 0.0,
                            child: YodaImage(image: 'assets/burgerlist.jpg'),
                          ),
//// FOREGROUND Info Widget
                          Positioned(
                            bottom: 0,
                            right: 0.0,
                            left: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.WHITE,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 15.w),
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
                                  SizedBox(height: 15.w),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.MAIN_LIGHT,
                                          borderRadius:
                                              AppTheme().mainBorderRadius,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.5.w,
                                            vertical: 7.5.w),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.w),
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
                                          borderRadius:
                                              AppTheme().mainBorderRadius,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.5.w, vertical: 10.w),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.w),
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
                                          borderRadius:
                                              AppTheme().mainBorderRadius,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.5.w, vertical: 10.w),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.w),
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
                                  ToggleButtonWidget(),
//// Delivery/On-site Widget
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     color: AppTheme.MAIN_LIGHT,
                                  //     borderRadius:
                                  //         AppTheme().buttonBorderRadius,
                                  //   ),
                                  //   padding: EdgeInsets.symmetric(
                                  //       horizontal: 2.w, vertical: 2.w),
                                  //   child: LayoutBuilder(builder:
                                  //       (BuildContext context,
                                  //           BoxConstraints constraints) {
                                  //     return Row(
                                  //       children: [
                                  //         GestureDetector(
                                  //           onTap: () {
                                  //             if (!isDelivery)
                                  //               setState(() {
                                  //                 isDelivery = true;
                                  //               });
                                  //           },
                                  //           child: AnimatedContainer(
                                  //             duration:
                                  //                 Duration(milliseconds: 250),
                                  //             width: constraints.maxWidth / 2,
                                  //             decoration: BoxDecoration(
                                  //               color: isDelivery
                                  //                   ? AppTheme.WHITE
                                  //                   : AppTheme.MAIN_LIGHT,
                                  //               borderRadius: AppTheme()
                                  //                   .buttonBorderRadius,
                                  //             ),
                                  //             padding: EdgeInsets.symmetric(
                                  //                 vertical: 12.5.w),
                                  //             alignment: Alignment.center,
                                  //             child: Text(
                                  //               'Eltip bermek',
                                  //               style: TextStyle(
                                  //                 fontSize: 17.sp,
                                  //                 color: !isDelivery
                                  //                     ? AppTheme.FONT_GREY_COLOR
                                  //                     : AppTheme.FONT_COLOR,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         GestureDetector(
                                  //           onTap: () {
                                  //             setState(() {
                                  //               isDelivery = false;
                                  //             });
                                  //           },
                                  //           child: AnimatedContainer(
                                  //             duration:
                                  //                 Duration(milliseconds: 250),
                                  //             width: constraints.maxWidth / 2,
                                  //             decoration: BoxDecoration(
                                  //               color: !isDelivery
                                  //                   ? AppTheme.WHITE
                                  //                   : AppTheme.MAIN_LIGHT,
                                  //               borderRadius: AppTheme()
                                  //                   .buttonBorderRadius,
                                  //             ),
                                  //             padding: EdgeInsets.symmetric(
                                  //                 vertical: 12.5.w),
                                  //             alignment: Alignment.center,
                                  //             child: Text(
                                  //               'Özüm aljak',
                                  //               style: TextStyle(
                                  //                 fontSize: 17.sp,
                                  //                 color: isDelivery
                                  //                     ? AppTheme.FONT_GREY_COLOR
                                  //                     : AppTheme.FONT_COLOR,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     );
                                  //   }),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      titlePadding: EdgeInsets.only(left: 65.w, bottom: 16.w),
                    );
                  },
                ),
//// ACTIONS button (Fav and Search)
                actions: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: _isShrink
                        ? SizedBox()
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(
                        //       Icons.favorite_outline_rounded,
                        //       size: 30.w,
                        //     ),
                        //   )
                        : AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.w),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isShrink
                                        ? Colors.transparent
                                        : AppTheme.WHITE,
                                    boxShadow: _isShrink
                                        ? []
                                        : [AppTheme().buttonShadow]),
                                child: Material(
                                  shape: CircleBorder(),
                                  elevation: 0,
                                  color: _isShrink
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
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.w),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _isShrink ? Colors.transparent : AppTheme.WHITE,
                            boxShadow:
                                _isShrink ? [] : [AppTheme().buttonShadow]),
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
              ),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return pinnedHeaderHeight;
          },
//// TabBar Widget
          body: Stack(
            children: [
              Column(
                children: <Widget>[
                  Material(
                    elevation: _isShrink ? 3.0 : 0.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: ColoredBox(
                        color: AppTheme.WHITE,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          indicatorColor: Colors.transparent,
                          labelPadding: EdgeInsets.all(0.0),
                          tabs: foodCategoryList
                              .map<Widget>((foodCategory) => Tab(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            AppTheme().buttonBorderRadius,
                                        color: _activeIndex ==
                                                foodCategoryList
                                                    .indexOf(foodCategory)
                                            ? AppTheme.MAIN_LIGHT
                                            : AppTheme.WHITE,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 3.w, horizontal: 5.w),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      alignment: Alignment.center,
                                      child: Text(
                                        foodCategory.name,
                                        style: TextStyle(
                                          color: _activeIndex ==
                                                  foodCategoryList
                                                      .indexOf(foodCategory)
                                              ? AppTheme.FONT_COLOR
                                              : AppTheme.DRAWER_ICON,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
//// TabBarView Widget
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: BouncingScrollPhysics(),
                      children: foodCategoryList
                          .map<Widget>(
                            (foodCategory) => ScrollConfiguration(
                              behavior: ScrollBehavior(),
                              child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color: AppTheme.MAIN,
                                child: GridView.builder(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.w, horizontal: 10.w),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10.w, //spaceTopBottom
                                    crossAxisSpacing: 5.w, //spaceLeftRight
                                    childAspectRatio: 1.sw / 1.65.sw,
                                  ),
                                  itemCount: foodList.length,
                                  itemBuilder: (context, pos) {
                                    return FoodWidget(
                                      food: foodList[pos],
                                      animationController: bottomCartController,
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
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
                      decoration:
                          BoxDecoration(color: AppTheme.WHITE, boxShadow: [
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
          )),
    );
  }
}
