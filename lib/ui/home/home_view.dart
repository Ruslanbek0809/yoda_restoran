import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/drawer/drawer_view.dart';
import 'package:yoda_res/ui/restaurant/restaurant_view.dart';
import 'package:yoda_res/ui/slider/slider_view.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'home_category/home_category_view.dart';
import 'home_category/home_discounts.dart';
import 'home_search/home_search.dart';
import 'home_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            /// Resize according to Onscreen keyboard
            resizeToAvoidBottomInset: true,
            key: model.homeScaffoldKey,
            drawer: DrawerView(),
            body: model.fetchinghomeSliders &&
                    model.fetchinghomeMainCat &&
                    model.fetchingRandomRes
                ? LoadingWidget()
                : NestedScrollView(
                    physics: const ClampingScrollPhysics(),
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxScrolled) {
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
                                      onPressed: model.homeMenuPressed,
                                      tooltip: 'Drawer',
                                    ),
                                    //------------------ SEARCH ---------------------//
                                    HomeSearch(),
                                  ],
                                ),
                                //------------------ BANNERS ---------------------//
                                SliderView(sliders: model.sliders),
                              ],
                            ),
                          ),
                        ),
                        //------------------ HOME CATEGORIES ---------------------//
                        SliverPersistentHeader(
                          pinned: false,
                          floating: true,
                          delegate: ContestTabHeader(
                            child: HomeCategoryView(
                                mainCategories: model.mainCategories),
                            size: 75.h,
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
                                  padding:
                                      EdgeInsets.only(left: 15.w, top: 12.h),
                                  child: Text(
                                    'Aksiýalar',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 24.sp,
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
                      itemBuilder: (ctx, pos) => RestaurantView(
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
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
