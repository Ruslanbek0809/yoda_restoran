import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/drawer/drawer_view.dart';
import '../../shared/shared.dart';
import 'home_bottom_cart.dart';
import 'main_category/main_cat_view.dart';
import '../restaurant/promoted/prom_res_view.dart';
import '../restaurant/restaurant_view.dart';
import '../slider/slider_view.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';
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
        return SafeArea(
          child: Scaffold(
            /// Resize according to Onscreen keyboard
            resizeToAvoidBottomInset: true,
            key: model.homeScaffoldKey,
            drawer: DrawerView(),
            body: model.anyObjectsBusy || model.fetchingSelectedMainCatsRes
                ? LoadingWidget()
                : Stack(
                    children: [
                      SmartRefresher(
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
                              expandedHeight:
                                  model.selectedMainCatRestaurants.isEmpty
                                      ? 0.36.sh
                                      : 0.1.sh,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              toolbarHeight: 60.h,
                              automaticallyImplyLeading: false,
                              flexibleSpace: FlexibleSpaceBar(
                                background: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 15.h),
                                      child: Row(
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
                                    ),
                                    //------------------ SLIDERS ---------------------//
                                    if (model
                                        .selectedMainCatRestaurants.isEmpty)
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
                            // //------------------ DISCOUNTS ---------------------//
                            // if (model.selectedMainCatRestaurants.isEmpty)
                            //   SliverPersistentHeader(
                            //     pinned: false,
                            //     floating: false,
                            //     delegate: ContestTabHeader(
                            //       child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Padding(
                            //             padding: EdgeInsets.only(
                            //                 left: 15.w, top: 12.h),
                            //             child: Text(
                            //               'Aksiýalar',
                            //               style: TextStyle(
                            //                 fontSize: 24.sp,
                            //                 fontWeight: FontWeight.bold,
                            //                 color: AppTheme.MAIN_DARK,
                            //               ),
                            //             ),
                            //           ),
                            //           HomeDiscounts(discounts: discounts),
                            //         ],
                            //       ),
                            //       size: 135.h,
                            //     ),
                            //   ),
                            //------------------ BODY: RESTAURANTS ---------------------//
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  model.selectedMainCatRestaurants.isEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(
                                              top: 20
                                                  .h), // Changes based on exclusive part
                                          itemCount:
                                              model.resWithProms?.length ?? 0,
                                          itemBuilder: (ctx, pos) {
                                            //------------------ RESTAURANTS with PROMOTEDS in every 5th place ---------------------//
                                            if ((pos + 1) % 5 == 0 &&
                                                model.resWithProms![pos].prom !=
                                                    null)
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.w),
                                                        child: Text(
                                                          model
                                                              .resWithProms![
                                                                  pos]
                                                              .prom!
                                                              .name!,
                                                          style: TextStyle(
                                                            fontSize: 24.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppTheme
                                                                .MAIN_DARK,
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
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: model
                                                              .resWithProms![
                                                                  pos]
                                                              .prom!
                                                              .restaurants!
                                                              .map((promRes) {
                                                            return PromResView(
                                                              restaurant:
                                                                  promRes,
                                                              promRess: model
                                                                  .resWithProms![
                                                                      pos]
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
                                              restaurant: model
                                                  .resWithProms![pos]
                                                  .restaurant,
                                            );
                                          },
                                        )
                                      : Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 5.h),
                                              child: Divider(
                                                thickness: 1,
                                              ),
                                            ),
                                            //------------------ FOUND TITLE and CLEAR part ---------------------//
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 3.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${model.selectedMainCatRestaurants.length} restoran tapyldy',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: ktsDefault20BoldText,
                                                  ),
                                                  CustomTextChildButton(
                                                    child: Text(
                                                      'Arassala',
                                                      style: ktsDefault16Text,
                                                    ),
                                                    color:
                                                        kcSecondaryLightColor,
                                                    borderRadius:
                                                        AppTheme().radius20,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.h,
                                                            horizontal: 22.w),
                                                    onPressed: model
                                                        .clearSelectedMainCatRess,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //------------------ RESULT SELECTED MAIN CATS RES LIST ---------------------//
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding:
                                                  EdgeInsets.only(top: 10.h),
                                              itemCount: model
                                                  .selectedMainCatRestaurants
                                                  .length,
                                              itemBuilder: (ctx, pos) {
                                                return RestaurantView(
                                                  restaurant: model
                                                          .selectedMainCatRestaurants[
                                                      pos],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                  SizedBox(
                                      height:
                                          0.1.sh), // COMPENSATES HomeBottomCart
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
