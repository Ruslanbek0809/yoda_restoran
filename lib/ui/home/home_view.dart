import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/screens/restaurant/restaurant.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'home_category/home_category_view.dart';
import 'home_category/home_discounts.dart';
import 'home_search/home_search.dart';
import 'home_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool isFavorited = false;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
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
                            HomeSearch(),
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
                    child: HomeCategoryView(homeCategories: homeCategories),
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
                        HomeDiscounts(discounts: discounts),
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
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
