import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../restaurant/restaurant.dart';
import '../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/widgets.dart';
import 'home.dart';
import 'search/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final List<String> imgList = [
  'assets/foodbanner1.png',
  'assets/foodbanner.jpg',
  'assets/foodbanner2.png',
];

List<HomeCategory> homeCategories = [
  HomeCategory(1, 'Halanlarym', 'assets/cat_fav.png'),
  HomeCategory(2, 'Sushi', 'assets/cat_sushi.png'),
  HomeCategory(3, 'Burger', 'assets/cat_burger.png'),
  HomeCategory(4, 'Pizza', 'assets/cat_pizza.png'),
  HomeCategory(5, 'Hemmesi', 'assets/cat_filter.png'),
];

List<Restaurant> restaurants = [
  Restaurant(
    1,
    'Sushi',
    'Sushi we başgalar',
    'assets/sushi.png',
  ),
  Restaurant(2, 'Hotdost', 'Hotdog we başgalar', 'assets/hotdost.jpg'),
  Restaurant(3, 'Burger Zone', 'Burger we başgalar', 'assets/burgerzone.jpg'),
  Restaurant(4, 'Palawkom', 'Palaw we başgalar', 'assets/palawkom.jpg'),
];

List<Discount> discounts = [
  Discount(1, 'assets/discount1.png'),
  Discount(2, 'assets/discount2.png'),
  Discount(3, 'assets/discount3.png'),
  Discount(4, 'assets/discount4.png'),
  Discount(5, 'assets/discount1.png'),
  Discount(6, 'assets/discount2.png'),
  Discount(7, 'assets/discount3.png'),
  Discount(8, 'assets/discount4.png'),
];

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Resize according to onscreen keyboard
      resizeToAvoidBottomInset: true,
      key: homeScaffoldKey,
      drawer: DrawerWidget(),
      body: SafeArea(
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            final controller = TextEditingController();
            return <Widget>[
              SliverAppBar(
                expandedHeight: 0.34.sh,
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
//------------------ MENU ---------------------//
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              size: 24.w,
                            ),
                            onPressed: () =>
                                homeScaffoldKey.currentState!.openDrawer(),
                            tooltip: 'Drawer',
                          ),
//------------------ SEARCH ---------------------//
                          HeaderSearchWidget(),
                        ],
                      ),
//------------------ BANNERS ---------------------//
                      BannerWidget(imgList: imgList),
                    ],
                  ),
                ),
              ),
//------------------ HOME CATEGORIES ---------------------//
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: ContestTabHeader(
                  child: HomeCategoriesWidget(homeCategories: homeCategories),
                  size: 80.w,
                ),
              ),
//------------------ DISCOUNTS ---------------------//
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: ContestTabHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w, top: 15.w),
                        child: Text(
                          'Aksiýalar',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 23.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.MAIN_DARK,
                          ),
                        ),
                      ),
                      DiscountsWidget(discounts: discounts),
                    ],
                  ),
                  size: 150.w,
                ),
              ),
            ];
          },
//------------------ RESTAURANTS ---------------------//
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
