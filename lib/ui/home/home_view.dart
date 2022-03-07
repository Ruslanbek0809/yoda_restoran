import 'dart:io';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/library/upgrader_translations.dart';
import 'package:yoda_res/ui/drawer/drawer_view.dart';
import '../../shared/shared.dart';
import 'home_bottom_cart.dart';
import 'home_exclusives/home_exclusive.dart';
import 'main_category/main_cat_view.dart';
import '../restaurant/promoted/prom_res_view.dart';
import '../restaurant/restaurant_view.dart';
import '../slider/slider_view.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';
import 'home_search/home_search.dart';
import 'home_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

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
      onModelReady: (model) =>
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await _refreshController.requestRefresh();

        // await _refreshController.requestRefresh(needCallback: false);
        // _refreshController.refreshCompleted();

        /// InAppUpdate for Android only (FLEXIBLE UPDATE STYLE)
        if (Platform.isAndroid) {
          var info = await InAppUpdate.checkForUpdate();

          // model.log.v('InAppUpdate Info: $info');
          print('InAppUpdate Info: $info');
          // model.log.v(
          //     'InAppUpdate Info.availableVersionCode: ${info.availableVersionCode}');
          print(
              'InAppUpdate Info.availableVersionCode: ${info.availableVersionCode}');
          if (info.updateAvailability == 2) {
            print('I AM IN startFlexibleUpdate(): ');
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          }
        }
      }),
      builder: (context, model, child) {
        if (model.fetchingSelectError && model.cartRes!.id != -1)
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            model.updateFetchingSelectedError();
            await showErrorFlashBar(
              context: context,
              margin: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 0.12.sh,
              ),
            );
          });
        else if (model.fetchingSelectError)
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            model.updateFetchingSelectedError();
            await showErrorFlashBar(
              context: context,
              margin: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 0.05.sh,
              ),
            );
          });
        //------------------ MAIN CATS LOADING PART ---------------------//
        Widget body = model.fetchingSelectedMainCatsRes
            ? CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 0.1.sh,
                    backgroundColor: kcWhiteColor,
                    elevation: 0,
                    toolbarHeight: 60.h,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10.h + MediaQuery.of(context).padding.top),
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
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.only(top: 0.4.sh),
                          child: LoadingWidget(),
                        )
                      ],
                    ),
                  ),
                ],
              )
            //------------------ MAIN PART ---------------------//
            : Stack(
                children: [
                  SmartRefresher(
                    header: CustomHeader(
                      height: 50.h,
                      builder: (BuildContext context, RefreshStatus? mode) {
                        return SpinKitChasingDots(
                          size: 27,
                          color: kcPrimaryColor,
                        );
                      },
                    ),
                    // header: WaterDropMaterialHeader(
                    //   backgroundColor: AppTheme.MAIN,
                    // ),
                    controller: _refreshController,
                    enablePullDown: true,
                    onRefresh: () async {
                      await model.initialise();
                      _refreshController.refreshCompleted();
                    },
                    //------------------ CUSTOM ERROR ---------------------//
                    child: model.hasFutureError
                        ? CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                expandedHeight: 0.3.sh,
                                backgroundColor: kcWhiteColor,
                                elevation: 0,
                                toolbarHeight: 60.h,
                                automaticallyImplyLeading: false,
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.h +
                                                MediaQuery.of(context)
                                                    .padding
                                                    .top),
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
                                    ],
                                  ),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    ViewErrorWidget(
                                      modelCallBack: () async {
                                        await _refreshController
                                            .requestRefresh();
                                        // model.updateHasFutureError();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        //------------------ CUSTOM SUCCESS ---------------------//
                        : CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                expandedHeight: model.selectedMainCats.isEmpty
                                    ? 0.075.sh + 0.6.sw
                                    : 0.1.sh,
                                backgroundColor: kcWhiteColor,
                                elevation: 0,
                                toolbarHeight: 60.h,
                                automaticallyImplyLeading: false,
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.h +
                                                MediaQuery.of(context)
                                                    .padding
                                                    .top),
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
                                      if (model.selectedMainCats.isEmpty)
                                        SliderView(
                                            sliders: model.sliders ?? []),
                                    ],
                                  ),
                                ),
                              ),
                              //------------------ HOME CATEGORIES ---------------------//
                              SliverPersistentHeader(
                                pinned: false,
                                floating: false,
                                delegate: ContestTabHeader(
                                  size: 92.h,
                                  child: MainCatView(),
                                ),
                              ),
                              //------------------ EXCLUSIVES ---------------------//
                              if (model.selectedMainCatRestaurants.isEmpty &&
                                  model.exclusives!.isNotEmpty)
                                SliverPersistentHeader(
                                  pinned: false,
                                  floating: false,
                                  delegate: ContestTabHeader(
                                    size: 135.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.w, top: 12.h),
                                          child: Text(
                                            model.exclusives![0].name!,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.MAIN_DARK,
                                            ),
                                          ),
                                        ),
                                        HomeExclusive(
                                            exlusiveSingles: model
                                                .exclusives![0]
                                                .exclusiveSingles!),
                                      ],

                                      // model.exclusives!
                                      //     .map((_exclusive) => Column(
                                      //           children: [
                                      //             Padding(
                                      //               padding: EdgeInsets.only(
                                      //                   left: 16.w, top: 12.h),
                                      //               child: Text(
                                      //                 _exclusive.name!,
                                      //                 style: TextStyle(
                                      //                   fontSize: 24.sp,
                                      //                   fontWeight:
                                      //                       FontWeight.bold,
                                      //                   color:
                                      //                       AppTheme.MAIN_DARK,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             HomeExclusives(
                                      //                 exlusiveSingles: _exclusive
                                      //                     .exclusiveSingles!),
                                      //           ],
                                      //         ))
                                      //     .toList(),
                                    ),
                                  ),
                                ),
                              //------------------ BODY: RESTAURANTS ---------------------//
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    model.selectedMainCats.isEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.only(
                                                top: 16
                                                    .h), // Changes based on exclusive part
                                            itemCount:
                                                model.resWithProms?.length ?? 0,
                                            itemBuilder: (ctx, pos) {
                                              //------------------ RESTAURANTS with PROMOTEDS in every 5th place ---------------------//
                                              if ((pos + 1) % 5 == 0 &&
                                                  model.resWithProms![pos]
                                                          .prom !=
                                                      null)
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                                  left: 16.w,
                                                                  top: 4.h),
                                                          child: Text(
                                                            model
                                                                .resWithProms![
                                                                    pos]
                                                                .prom!
                                                                .name!,
                                                            style: TextStyle(
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                      LocaleKeys
                                                          .foundRestaurants,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          ktsDefault18BoldText,
                                                    ).tr(args: [
                                                      model
                                                          .selectedMainCatRestaurants
                                                          .length
                                                          .toString()
                                                    ]),
                                                    SizedBox(width: 5.w),
                                                    CustomTextChildButton(
                                                        child: Text(
                                                          LocaleKeys.clear,
                                                          style:
                                                              ktsDefault16Text,
                                                        ).tr(),
                                                        color:
                                                            kcSecondaryLightColor,
                                                        borderRadius:
                                                            AppTheme().radius20,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 6.h,
                                                                horizontal:
                                                                    20.w),
                                                        onPressed: () async {
                                                          await model
                                                              .clearSelectedMainCatRess();
                                                          await _refreshController
                                                              .requestRefresh();
                                                          // model
                                                          //     .updateHasFutureError();
                                                        }),
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
                                        height: 0.11
                                            .sh), // COMPENSATES HomeBottomCart
                                  ],
                                ),
                              ),

                              // model.selectedMainCats.isEmpty
                              //     ? SliverPadding(
                              //         padding: EdgeInsets.only(
                              //           top: 16.h,
                              //           bottom: 0.11
                              //               .sh, // COMPENSATES HomeBottomCart
                              //         ), // Changes based on exclusive part
                              //         sliver: SliverList(
                              //           delegate: SliverChildBuilderDelegate(
                              //             (BuildContext context, int pos) {
                              //               //------------------ RESTAURANTS with PROMOTEDS in every 5th place ---------------------//
                              //               if ((pos + 1) % 5 == 0 &&
                              //                   model.resWithProms![pos].prom !=
                              //                       null)
                              //                 return Column(
                              //                   mainAxisSize: MainAxisSize.min,
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     Column(
                              //                       crossAxisAlignment:
                              //                           CrossAxisAlignment
                              //                               .start,
                              //                       children: [
                              //                         Padding(
                              //                           padding:
                              //                               EdgeInsets.only(
                              //                                   left: 16.w,
                              //                                   top: 2.h),
                              //                           child: Text(
                              //                             model
                              //                                 .resWithProms![
                              //                                     pos]
                              //                                 .prom!
                              //                                 .name!,
                              //                             style: TextStyle(
                              //                               fontSize: 24.sp,
                              //                               fontWeight:
                              //                                   FontWeight.bold,
                              //                               color: AppTheme
                              //                                   .MAIN_DARK,
                              //                             ),
                              //                           ),
                              //                         ),
                              //                         SingleChildScrollView(
                              //                           physics:
                              //                               BouncingScrollPhysics(),
                              //                           scrollDirection:
                              //                               Axis.horizontal,
                              //                           child: Row(
                              //                             mainAxisAlignment:
                              //                                 MainAxisAlignment
                              //                                     .start,
                              //                             children: model
                              //                                 .resWithProms![
                              //                                     pos]
                              //                                 .prom!
                              //                                 .restaurants!
                              //                                 .map((promRes) {
                              //                               return PromResView(
                              //                                 restaurant:
                              //                                     promRes,
                              //                                 promRess: model
                              //                                     .resWithProms![
                              //                                         pos]
                              //                                     .prom!
                              //                                     .restaurants!,
                              //                               );
                              //                             }).toList(),
                              //                           ),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     //------------------ RESTAURANTS ---------------------//
                              //                     RestaurantView(
                              //                       restaurant: model
                              //                           .resWithProms![pos]
                              //                           .restaurant,
                              //                     ),
                              //                   ],
                              //                 );
                              //               return RestaurantView(
                              //                 restaurant: model
                              //                     .resWithProms![pos]
                              //                     .restaurant,
                              //               );
                              //             },
                              //             childCount:
                              //                 model.resWithProms?.length ?? 0,
                              //           ),
                              //         ),
                              //       )
                              //     : SliverList(
                              //         delegate: SliverChildListDelegate(
                              //           [
                              //             Column(
                              //               children: [
                              //                 Padding(
                              //                   padding: EdgeInsets.symmetric(
                              //                       horizontal: 16.w,
                              //                       vertical: 5.h),
                              //                   child: Divider(
                              //                     thickness: 1,
                              //                   ),
                              //                 ),
                              //                 //------------------ FOUND TITLE and CLEAR part ---------------------//
                              //                 Padding(
                              //                   padding: EdgeInsets.symmetric(
                              //                       horizontal: 16.w,
                              //                       vertical: 3.h),
                              //                   child: Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment
                              //                             .spaceBetween,
                              //                     children: [
                              //                       Text(
                              //                         LocaleKeys
                              //                             .foundRestaurants,
                              //                         overflow:
                              //                             TextOverflow.ellipsis,
                              //                         style:
                              //                             ktsDefault18BoldText,
                              //                       ).tr(args: [
                              //                         model
                              //                             .selectedMainCatRestaurants
                              //                             .length
                              //                             .toString()
                              //                       ]),
                              //                       SizedBox(width: 5.w),
                              //                       CustomTextChildButton(
                              //                           child: Text(
                              //                             LocaleKeys.clear,
                              //                             style:
                              //                                 ktsDefault16Text,
                              //                           ).tr(),
                              //                           color:
                              //                               kcSecondaryLightColor,
                              //                           borderRadius:
                              //                               AppTheme().radius20,
                              //                           padding: EdgeInsets
                              //                               .symmetric(
                              //                                   vertical: 6.h,
                              //                                   horizontal:
                              //                                       20.w),
                              //                           onPressed: () async {
                              //                             await model
                              //                                 .clearSelectedMainCatRess();
                              //                             await _refreshController
                              //                                 .requestRefresh();
                              //                             // model
                              //                             //     .updateHasFutureError();
                              //                           }),
                              //                     ],
                              //                   ),
                              //                 ),
                              //                 //------------------ RESULT SELECTED MAIN CATS RES LIST ---------------------//
                              //                 ListView.builder(
                              //                   shrinkWrap: true,
                              //                   physics:
                              //                       NeverScrollableScrollPhysics(),
                              //                   padding:
                              //                       EdgeInsets.only(top: 10.h),
                              //                   itemCount: model
                              //                       .selectedMainCatRestaurants
                              //                       .length,
                              //                   itemBuilder: (ctx, pos) {
                              //                     return RestaurantView(
                              //                       restaurant: model
                              //                               .selectedMainCatRestaurants[
                              //                           pos],
                              //                     );
                              //                   },
                              //                 ),
                              //               ],
                              //             ),
                              //             SizedBox(
                              //                 height: 0.11
                              //                     .sh), // COMPENSATES HomeBottomCart
                              //           ],
                              //         ),
                              //       ),
                            ],
                          ),
                  ),
                  //------------------ BOTTOM CART ---------------------//
                  if (!model.hasFutureError && model.cartRes!.id != -1)
                    HomeBottomCart(),
                ],
              );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              // statusBarColor: Colors
              //     .transparent, // Statusbar transparent
              statusBarIconBrightness:
                  Brightness.light, // For Android: (dark icons)
              statusBarBrightness: Brightness.light // For iOS: (dark icons)
              ),
          child:
              // SafeArea(
              //     child:
              Scaffold(
            /// Resize according to Onscreen keyboard
            resizeToAvoidBottomInset: true,
            key: model.homeScaffoldKey,
            drawer: DrawerView(),
            body: Platform.isIOS
                ? UpgradeAlert(
                    child: DoubleBackToCloseApp(
                      snackBar: SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        margin: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 0.05.sh,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme().radius10,
                        ),
                        content: Text(
                          LocaleKeys.doubleBackToCloseApp,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                          ),
                        ).tr(),
                      ),
                      child: body,
                    ),
                    shouldPopScope: () => true,
                    messages: context.locale == context.supportedLocales[0]
                        ? MyTurkmenMessages()
                        : MyRussianMessages(),
                  )
                : DoubleBackToCloseApp(
                    snackBar: SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 0.05.sh,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme().radius10,
                      ),
                      content: Text(
                        LocaleKeys.doubleBackToCloseApp,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                      ).tr(),
                    ),
                    child: body,
                  ),
          ),
        );
        // );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
