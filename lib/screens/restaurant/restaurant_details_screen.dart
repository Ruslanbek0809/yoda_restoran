import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/screens/restaurant/product_bottom_sheet.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var top = 0.0;
  late ScrollController _scrollController;
  bool lastStatus = true;
  bool isDelivery = true;
  bool isButtonToggled = false;
  int _activeIndex = 0;
  late AnimationController _tweenController;
  Tween<double> _tween = Tween(begin: 1, end: 0.98);

  List<FoodCategory> _foodCategoryList = [
    FoodCategory(0, 'Ertirlikler'),
    FoodCategory(1, 'Işdäaçarlar'),
    FoodCategory(2, 'Desertler'),
    FoodCategory(3, 'Steak'),
    FoodCategory(4, 'Burgerlar'),
  ];

  List<FoodModel> _foodList = [
    FoodModel(0, 'Sandwich', 120, 'g', 25, 'assets/breakfast_sandwich.jpg'),
    FoodModel(0, 'Egg', 120, 'g', 10, 'assets/breakfast_egg.jpg'),
    FoodModel(0, 'Sandwich', 300, 'ml', 15, 'assets/breakfast_latte.jpg'),
  ];

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

  void _onProductBottomSheetClicked(FoodModel food) {
    showProductBottomSheet(context, food);
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);
    _tabController =
        TabController(length: _foodCategoryList.length, vsync: this);
    _tabController.addListener(_tabListener);

    /// Container bounce back
    _tweenController = AnimationController(
        duration: const Duration(milliseconds: 50), vsync: this)
      ..addStatusListener((status) {
//// This listener was used to repeat animation once
        if (status == AnimationStatus.completed) {
          _tweenController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    _tabController.removeListener(_tabListener);
    _tweenController.dispose();
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
                                  )),
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
//// Delivery/On-site Widget
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.MAIN_LIGHT,
                                      borderRadius:
                                          AppTheme().buttonBorderRadius,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.w),
                                    child: LayoutBuilder(builder:
                                        (BuildContext context,
                                            BoxConstraints constraints) {
                                      return Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (!isDelivery)
                                                setState(() {
                                                  isDelivery = true;
                                                });
                                            },
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 250),
                                              width: constraints.maxWidth / 2,
                                              decoration: BoxDecoration(
                                                color: isDelivery
                                                    ? AppTheme.WHITE
                                                    : AppTheme.MAIN_LIGHT,
                                                borderRadius: AppTheme()
                                                    .buttonBorderRadius,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12.5.w),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Eltip bermek',
                                                style: TextStyle(
                                                  fontSize: 17.sp,
                                                  color: !isDelivery
                                                      ? AppTheme.FONT_GREY_COLOR
                                                      : AppTheme.FONT_COLOR,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isDelivery = false;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 250),
                                              width: constraints.maxWidth / 2,
                                              decoration: BoxDecoration(
                                                color: !isDelivery
                                                    ? AppTheme.WHITE
                                                    : AppTheme.MAIN_LIGHT,
                                                borderRadius: AppTheme()
                                                    .buttonBorderRadius,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12.5.w),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Özüm aljak',
                                                style: TextStyle(
                                                  fontSize: 17.sp,
                                                  color: isDelivery
                                                      ? AppTheme.FONT_GREY_COLOR
                                                      : AppTheme.FONT_COLOR,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
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
          body: Column(
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
                      tabs: _foodCategoryList
                          .map<Widget>((foodCategory) => Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: AppTheme().buttonBorderRadius,
                                    color: _activeIndex ==
                                            _foodCategoryList
                                                .indexOf(foodCategory)
                                        ? AppTheme.MAIN_LIGHT
                                        : AppTheme.WHITE,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 3.w, horizontal: 5.w),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  alignment: Alignment.center,
                                  child: Text(
                                    foodCategory.name,
                                    style: TextStyle(
                                      color: _activeIndex ==
                                              _foodCategoryList
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
                  children: _foodCategoryList
                      .map<Widget>(
                        (foodCategory) => GridView.builder(
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
                          itemCount: _foodList.length,
                          itemBuilder: (context, pos) {
                            return ScaleTransition(
                              scale: _tween.animate(CurvedAnimation(
                                  parent: _tweenController,
                                  curve: Curves.bounceInOut)),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.MAIN_LIGHT,
                                  borderRadius: AppTheme().mainBorderRadius,
                                ),
                                padding: EdgeInsets.all(5.w),
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        YodaImage(
                                          image: _foodList[pos].image,
                                          height: constraints.maxWidth,
                                          width: constraints.maxWidth,
                                          borderRadius: 20.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 8.w, bottom: 4.w),
                                          child: Text(
                                            _foodList[pos].name,
                                            style: TextStyle(
                                              fontSize: 17.sp,
                                              color: AppTheme.FONT_COLOR,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${_foodList[pos].weight} ${_foodList[pos].weightType}',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: AppTheme.DRAWER_ICON,
                                          ),
                                        ),
                                        Spacer(),
//// Button Widget
                                        AnimatedSwitcher(
                                          duration: Duration(milliseconds: 300),
                                          child: isButtonToggled
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Material(
                                                      color: AppTheme.WHITE,
                                                      borderRadius: AppTheme()
                                                          .buttonBorderRadius,
                                                      elevation: 1,
                                                      child: InkWell(
                                                        borderRadius: AppTheme()
                                                            .buttonBorderRadius,
                                                        onTap: () async {
                                                          _tweenController
                                                              .forward();
                                                          if (isButtonToggled)
                                                            setState(() {
                                                              isButtonToggled =
                                                                  !isButtonToggled;
                                                            });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.w),
                                                          child: Icon(
                                                            Icons.remove,
                                                            size: 25.w,
                                                            color: AppTheme
                                                                .FONT_COLOR,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '1',
                                                      style: TextStyle(
                                                        fontSize: 20.sp,
                                                        color:
                                                            AppTheme.FONT_COLOR,
                                                      ),
                                                    ),
                                                    Material(
                                                      color: AppTheme.WHITE,
                                                      borderRadius: AppTheme()
                                                          .buttonBorderRadius,
                                                      elevation: 1,
                                                      child: InkWell(
                                                        borderRadius: AppTheme()
                                                            .buttonBorderRadius,
                                                        onTap: () {
                                                          _onProductBottomSheetClicked(
                                                              _foodList[pos]);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.w),
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 25.w,
                                                            color: AppTheme
                                                                .FONT_COLOR,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Material(
                                                  color: Colors.transparent,
                                                  borderRadius: AppTheme()
                                                      .buttonBorderRadius,
                                                  elevation: 1,
                                                  child: InkWell(
                                                    borderRadius: AppTheme()
                                                        .buttonBorderRadius,
                                                    onTap: () async {
                                                      _tweenController
                                                          .forward();
                                                      if (!isButtonToggled)
                                                        setState(() {
                                                          isButtonToggled =
                                                              !isButtonToggled;
                                                        });
                                                    },
                                                    child: Ink(
                                                      width:
                                                          constraints.maxWidth,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.WHITE,
                                                        borderRadius: AppTheme()
                                                            .buttonBorderRadius,
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.w),
                                                      child: Text(
                                                        '${_foodList[pos].price} TMT',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20.sp,
                                                          color: AppTheme
                                                              .FONT_COLOR,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          )),
    );
  }
}
