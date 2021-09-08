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
  Restaurant(1, 'Kebapçy', 'Kebap we başgalar', 'assets/kebapchy.jpg'),
  Restaurant(2, 'Hotdost', 'Hotdog we başgalar', 'assets/hotdost.jpg'),
  Restaurant(3, 'Burger Zone', 'Burger we başgalar', 'assets/burgerzone.jpg'),
  Restaurant(4, 'Palawkom', 'Palaw we başgalar', 'assets/palawkom.jpg'),
];

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isFavorited = false;
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
              SizedBox(height: 10.w),
//// Restaurants Widget
              Expanded(
                child: ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (ctx, pos) => Container(
                    height: 0.62.sw,
                    width: 1.sw,
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            YodaImage(
                              image: restaurants[pos].image,
                              height: 0.45.sw,
                              width: 1.sw,
                              borderRadius: Constants.BORDER_RADIUS_MAIN,
                            ),
///// Delivery time Widget
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 0.3.sw,
                                height: 33.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.w,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.MAIN_DARK.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Constants.BORDER_RADIUS_MAIN),
                                    bottomRight: Radius.circular(
                                        Constants.BORDER_RADIUS_MAIN),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '40-50 min.',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.WHITE,
                                  ),
                                ),
                              ),
                            ),
//// Favourite Widget
                            Positioned(
                              top: 10.w,
                              right: 10.w,
                              child: Container(
                                width: 0.11.sw,
                                height: 0.11.sw,
                                decoration: BoxDecoration(
                                  color: AppTheme.WHITE.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      isFavorited = !isFavorited;
                                    });
                                  },
                                  icon: Icon(
                                    isFavorited
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorited
                                        ? AppTheme.RED
                                        : IconTheme.of(context).color,
                                    size: 25.w,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.w),
                          child: Text(
                            restaurants[pos].name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 23.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.MAIN_DARK,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, size: 20.w, color: AppTheme.GREEN),
                            SizedBox(width: 3.w),
                            Text(
                              '4.9 (123)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppTheme.MAIN_DARK,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              restaurants[pos].foods,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppTheme.MAIN_DARK,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
