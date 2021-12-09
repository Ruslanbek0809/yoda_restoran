import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/drawer/drawer_view.dart';
import 'package:yoda_res/ui/home/main_category/main_category_view.dart';
import 'package:yoda_res/ui/restaurant/restaurant_view.dart';
import 'package:yoda_res/ui/slider/slider_view.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'home_search/home_search.dart';
import 'home_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main_category/home_discounts.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        model.log.i('HomeView');
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
                                SliderView(sliders: model.sliders ?? []),
                              ],
                            ),
                          ),
                        ),
                        //------------------ HOME CATEGORIES ---------------------//
                        SliverPersistentHeader(
                          pinned: false,
                          floating: true,
                          delegate: ContestTabHeader(
                            child: MainCategoryView(
                              mainCategories: model.mainCategories ?? [],
                            ),
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
                      itemCount: model.randomRestaurants?.length ?? 0,
                      itemBuilder: (ctx, pos) => RestaurantView(
                        restaurant: model.randomRestaurants![pos],
                      ),
                    ),
                  ),
          ),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
