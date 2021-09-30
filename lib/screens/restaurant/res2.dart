import 'package:flutter/material.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantScreen2 extends StatefulWidget {
  @override
  _RestaurantScreen2State createState() => _RestaurantScreen2State();
}

class _RestaurantScreen2State extends State<RestaurantScreen2> {
  late ScrollController _scrollController;
  bool lastStatus = true;

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

    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 0.5.sh,
              pinned: true,
              stretch: true,
              floating: false,
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
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [StretchMode.zoomBackground],
                background: YodaImage(
                  image: 'assets/burgerlist.jpg',
                ),
                title: Text(
                  'Kebapçy',
                  style: TextStyle(fontSize: 17.sp),
                ),
                centerTitle: false,
              ),
              bottom: ColoredTabBar(
                color: AppTheme.WHITE,
                tabBar: TabBar(
                  tabs: [
                    Tab(child: Text('Tab1')),
                    Tab(child: Text('Tab1')),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: ListView.separated(
                            itemCount: 10,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return Container(
                                height: 50,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Text(
                                      'Hey',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              );
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
                                  childAspectRatio: 1.sw / 1.65.sw,
                                ),
                                itemCount: 10,
                                itemBuilder: (context, pos) {
                                  return Container(
                                    color: Colors.blue,
                                    height: 50,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
