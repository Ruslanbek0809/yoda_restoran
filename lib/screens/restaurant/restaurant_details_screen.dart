import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with TickerProviderStateMixin {
  late TabController primaryTC;

  var top = 0.0;
  late ScrollController _scrollController;
  bool lastStatus = true;
  bool isDelivery = true;

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (0.5.sh - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    primaryTC = new TabController(length: 2, vsync: this);
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
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
                                                  color: AppTheme.FONT_COLOR,
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
                                                  color: AppTheme.FONT_COLOR,
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
          body: Column(
            children: <Widget>[
              ColoredBox(
                color: AppTheme.WHITE,
                child: TabBar(
                  controller: primaryTC,
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: "Tab1"),
                    Tab(text: "Tab2"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: primaryTC,
                  children: <Widget>[
                    ListView(
                      children: [
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                      ],
                    ),
                    ListView(
                      children: [
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
