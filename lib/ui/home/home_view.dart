import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/drawer/drawer_view.dart';
import 'package:yoda_res/ui/home/home_view_bottom_cart.dart';
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
            body: Stack(
              children: [
                model.anyObjectsBusy
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
                                size: 90.h,
                                child: MainCategoryView(
                                  mainCategories: model.mainCats ?? [],
                                ),
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
                                      padding: EdgeInsets.only(
                                          left: 15.w, top: 12.h),
                                      child: Text(
                                        'Aksiýalar',
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
                            padding: EdgeInsets.only(top: 10.h),
                            itemCount: model.resWithProms?.length ?? 0,
                            itemBuilder: (ctx, pos) {
                              if ((pos + 1) % 5 == 0 &&
                                  model.resWithProms![pos].prom != null)
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(model.resWithProms![pos].prom?.name! ??
                                        'Hey'),
                                    RestaurantView(
                                      restaurant:
                                          model.resWithProms![pos].restaurant,
                                    ),
                                  ],
                                );
                              return RestaurantView(
                                restaurant: model.resWithProms![pos].restaurant,
                              );
                            }
                            // /// After every 5 restaurant, it shows promoted ones
                            // if ((pos + 1) % 5 == 0) {
                            //   // && model.isOkToPromote
                            //   int promotePos = model.promotedCounter;
                            //   model.log.i('promotePos: $promotePos');
                            //   return Column(
                            //     children: [
                            //       Padding(
                            //         padding:
                            //             EdgeInsets.only(left: 15.w, top: 12.h),
                            //         child: Text(
                            //           model.promotedRes![promotePos].name!,
                            //           style: TextStyle(
                            //             fontSize: 24.sp,
                            //             fontWeight: FontWeight.bold,
                            //             color: AppTheme.MAIN_DARK,
                            //           ),
                            //         ),
                            //       ),
                            //       SingleChildScrollView(
                            //         physics: BouncingScrollPhysics(),
                            //         scrollDirection: Axis.horizontal,
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           children: model
                            //               .promotedRes![promotePos].restaurants!
                            //               .map((promoted) {
                            //             return Container(
                            //               padding: EdgeInsets.all(10),
                            //               color: Colors.blue,
                            //               child: Text(promoted.name!),
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //     ],
                            //   );
                            // }
                            ),
                      ),

                //------------------ BOTTOM CART ---------------------//
                HomeViewBottomCart(),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
