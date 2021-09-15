import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/screens/restaurant/restaurant.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/widgets/widgets.dart';
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
      drawer: DrawerWidget(),
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
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: ContestTabHeader(
                  categoriesWidget: HomeCategoriesWidget(
                    homeCategories: homeCategories,
                  ),
                  size: 90.w,
                ),
              ),
            ];
          },
///// Restaurants Widget
          body: ListView.builder(
            padding: EdgeInsets.only(top: 10.w),
            itemCount: restaurants.length,
            itemBuilder: (ctx, pos) => RestaurantWidget(
              restaurant: restaurants[pos],
            ),
          ),
//           Column(
//             children: [
// //// Categories Widget
//               // HomeCategoriesWidget(
//               //   homeCategories: homeCategories,
//               // ),
//               // SizedBox(height: 10.w),
// //// Restaurants Widget
//               Expanded(
//                 child:
//               ),
//             ],
//           ),
        ),
      ),
    );
  }
}
