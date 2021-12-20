import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/drawer/drawer_view.dart';
import 'package:yoda_res/ui/home/home_bottom_cart.dart';
import 'package:yoda_res/ui/home/main_category/main_cat_view.dart';
import 'package:yoda_res/ui/restaurant/promoted/prom_res_view.dart';
import 'package:yoda_res/ui/restaurant/restaurant_view.dart';
import 'package:yoda_res/ui/slider/slider_view.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'home_search/home_search.dart';
import 'home_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main_category/home_discounts.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        model.log.i('HomeView: ${model.fetchingSelectedMainCatsRes}');
        return SafeArea(
          child: Scaffold(
            /// Resize according to Onscreen keyboard
            resizeToAvoidBottomInset: true,
            key: model.homeScaffoldKey,
            drawer: DrawerView(),
            body: Stack(
              children: [
                model.anyObjectsBusy || model.fetchingSelectedMainCatsRes
                    ? LoadingWidget()
                    : SmartRefresher(
                        header: WaterDropMaterialHeader(
                          backgroundColor: AppTheme.MAIN,
                        ),
                        controller: _refreshController,
                        enablePullDown: true,
                        onRefresh: () async {
                          await model
                              .initialise(); // This reinitializes whole HomeView
                          _refreshController.refreshCompleted();
                        },
                        child: CustomScrollView(
                          slivers: [
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
                              floating: false,
                              delegate: ContestTabHeader(
                                size: 90.h,
                                child: MainCatView(),
                              ),
                            ),
                            //------------------ DISCOUNTS ---------------------//
                            SliverPersistentHeader(
                              pinned: false,
                              floating: false,
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
                                size: 135.h,
                              ),
                            ),
                            //------------------ BODY: RESTAURANTS ---------------------//
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(top: 10.h),
                                    itemCount: model.resWithProms?.length ?? 0,
                                    itemBuilder: (ctx, pos) {
                                      //------------------ RESTAURANTS with PROMOTEDS in every 5th place ---------------------//
                                      if ((pos + 1) % 5 == 0 &&
                                          model.resWithProms![pos].prom != null)
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.w, top: 12.h),
                                                  child: Text(
                                                    model.resWithProms![pos]
                                                        .prom!.name!,
                                                    style: TextStyle(
                                                      fontSize: 24.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppTheme.MAIN_DARK,
                                                    ),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: model
                                                        .resWithProms![pos]
                                                        .prom!
                                                        .restaurants!
                                                        .map((promRes) {
                                                      return PromResView(
                                                        restaurant: promRes,
                                                        promRess: model
                                                            .resWithProms![pos]
                                                            .prom!
                                                            .restaurants!,
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //------------------ RESTAURANTS ---------------------//
                                            RestaurantView(
                                              restaurant: model
                                                  .resWithProms![pos]
                                                  .restaurant,
                                            ),
                                          ],
                                        );
                                      return RestaurantView(
                                        restaurant:
                                            model.resWithProms![pos].restaurant,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                //------------------ BOTTOM CART ---------------------//
                HomeBottomCart(),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
