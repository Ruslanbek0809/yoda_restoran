import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/widgets/widgets.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with TickerProviderStateMixin {
  late TabController primaryTC;

  @override
  void initState() {
    primaryTC = new TabController(length: 2, vsync: this);
    super.initState();
  }

  var top = 0.0;

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
          // onlyOneScrollInBody: true,
          headerSliverBuilder: (c, f) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 0.5.sh,
                floating: false,
                pinned: true,
                leading: Container(
                  width: 50,
                  child: Icon(Icons.leaderboard),
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: false,
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: top ==
                                MediaQuery.of(context).padding.top +
                                    kToolbarHeight
                            ? 1.0
                            : 0.0,
                        child: Text(
                          'Kebapçy',
                          style: TextStyle(fontSize: 17.sp),
                        ),
                      ),
                      background: Stack(
                        children: [
                          Positioned(
                              top: 0,
                              right: 0.0,
                              left: 0.0,
                              child: YodaImage(image: 'assets/burgerlist.jpg')),
                          Positioned(
                            bottom: 0,
                            right: 0.0,
                            left: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  )),
                              alignment: Alignment.center,
                              height: 0.25.sh,
                              child: const Text('other things'),
                            ),
                          ),
                        ],
                      ),
                      titlePadding: EdgeInsets.only(left: 50, bottom: 16.0),
                    );
                  },
                ),
              ),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return pinnedHeaderHeight;
          },
          body: Column(
            children: <Widget>[
              TabBar(
                controller: primaryTC,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Tab1"),
                  Tab(text: "Tab2"),
                ],
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
