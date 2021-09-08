import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoda_res/library/scrollable_list_tabview/sroll.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/widgets/widgets.dart';

import 'ex.dart';
import 'home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final List<String> imgList = [
  'assets/foodbanner.jpg',
  'assets/foodbanner1.jpg',
  'assets/foodbanner2.png',
];

List<HomeCategory> homeCategories = [
  HomeCategory(1, 'Filter', 'assets/filter.png'),
  HomeCategory(2, 'Halanlarym', 'assets/favorite.png'),
  HomeCategory(3, 'Burger', 'assets/burger.png'),
  HomeCategory(4, 'Sushi', 'assets/sushi.png'),
  HomeCategory(5, 'Pizza', 'assets/pizza.png'),
];

List<Restaurant> restaurants = [
  Restaurant(1, 'Kebapchy', 'Kebap we başgalar', 'assets/kebapchy.jpg'),
  Restaurant(2, 'Hotdost', 'Hotdog we başgalar', 'assets/hotdost.jpg'),
  Restaurant(3, 'Burger Zone', 'Burger we başgalar', 'assets/burgerzone.jpg'),
  Restaurant(4, 'Palawkom', 'Palaw we başgalar', 'assets/palawkom.jpg'),
];

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Resize according to onscreen keyboard
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTheme.WHITE,
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomScrollView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  stretch: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.2,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'ýoda.restoran',
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(bottom: 40.0),
                    centerTitle: true,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ListTile(
                        title: Text(
                          'Home',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        leading: Icon(
                          Icons.home_rounded,
                          color: Theme.of(context).accentColor,
                        ),
                        selected: true,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Settings'),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        leading: Icon(
                          Icons
                              .settings_rounded, // miscellaneous_services_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text('About'),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/about');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: NestedScrollView(
          // physics: const BouncingScrollPhysics(),
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            final controller = TextEditingController();
            return <Widget>[
              SliverAppBar(
                expandedHeight: 0.3.sh,
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 60.w,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      SizedBox(height: 15.w),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
//// Menu button
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            tooltip: 'Drawer',
                          ),
//// Search
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 15.w, right: 5.w),
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                borderRadius: AppTheme().mainBorderRadius,
                                color: Theme.of(context).cardColor,
                                boxShadow: [AppTheme().searchShadow],
                              ),
                              child: TextField(
                                controller: controller,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5, color: Colors.transparent),
                                  ),
                                  suffixIcon: Icon(
                                    CupertinoIcons.search,
                                    color: AppTheme.MAIN,
                                  ),
                                  border: InputBorder.none,
                                  hintText: 'Gözleg',
                                ),
                                onSubmitted: (query) {},
                              ),
                            ),
                          ),
                        ],
                      ),
//// Banners Widget
                      BannerWidget(imgList: imgList),
                    ],
                  ),
                ),
              ),
//// Categories Widget
              // SliverPersistentHeader(
              //   pinned: true,
              //   floating: true,
              //   delegate: ContestTabHeader(
              //     categoriesWidget: HomeCategoriesWidget(
              //       homeCategories: homeCategories,
              //     ),
              //     size: 90.w,
              //   ),
              // ),
            ];
          },
          body: Column(
            children: [
//// Categories Widget
              HomeCategoriesWidget(
                homeCategories: homeCategories,
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (ctx, pos) => Container(
                  height: 0.45.sw,
                  decoration: BoxDecoration(color: Colors.grey),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      YodaImage(
                        image: restaurants[pos].image,
                        height: 0.45.sw,
                        borderRadius: 20,
                      ),
                      // Stack(
                      //   children: [
                      //   ],
                      // ),
                    ],
                  ),
                ),
              )),
            ],
          ),
          // SubcategoryWidget(),
          // ScrollableListTabView(
          //   tabHeight: 48,
          //   bodyAnimationDuration: const Duration(milliseconds: 300),
          //   tabAnimationCurve: Curves.ease,
          //   tabAnimationDuration: const Duration(milliseconds: 300),
          //   bodyAnimationCurve: Curves.linear,
          //   tabs: [
          //     ScrollableListTab(
          //         tab: ListTab(
          //             tabLabel: Text('Label 1'),
          //             innerLabel: Text('Label 1'),
          //             icon: Icon(Icons.group)),
          //         body: ListView.builder(
          //           shrinkWrap: true,
          //           physics: NeverScrollableScrollPhysics(),
          //           itemCount: 10,
          //           itemBuilder: (_, index) => ListTile(
          //             leading: Container(
          //               height: 40,
          //               width: 40,
          //               decoration: BoxDecoration(
          //                   shape: BoxShape.circle, color: Colors.grey),
          //               alignment: Alignment.center,
          //               child: Text(index.toString()),
          //             ),
          //             title: Text('List element $index'),
          //           ),
          //         )),
          //     ScrollableListTab(
          //         tab: ListTab(
          //             tabLabel: Text('Label 1'),
          //             innerLabel: Text('Label 1'),
          //             icon: Icon(Icons.group)),
          //         body: ListView.builder(
          //           shrinkWrap: true,
          //           physics: NeverScrollableScrollPhysics(),
          //           itemCount: 10,
          //           itemBuilder: (_, index) => ListTile(
          //             leading: Container(
          //               height: 40,
          //               width: 40,
          //               decoration: BoxDecoration(
          //                   shape: BoxShape.circle, color: Colors.grey),
          //               alignment: Alignment.center,
          //               child: Text(index.toString()),
          //             ),
          //             title: Text('List element $index'),
          //           ),
          //         )),
          //   ],
          // ),
        ),
      ),
    );
  }
}
