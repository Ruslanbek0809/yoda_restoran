import 'dart:io';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import '../../generated/locale_keys.g.dart';
import '../../library/upgrader_translations.dart';
import '../drawer/drawer_view.dart';
import '../../shared/shared.dart';
import 'home_bottom_cart.dart';
import 'home_exclusives/home_exclusive.dart';
import 'main_category/main_cat_view.dart';
import '../restaurant/promoted/prom_res_view.dart';
import '../restaurant/restaurant_view.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';
import 'home_search/home_search.dart';
import 'home_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'slider/slider_view.dart';

// import 'dart:math';
// import 'package:shake/shake.dart';
// import 'package:awesome_dialog/awesome_dialog.dart' as awesomeDialog;

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // awesomeDialog.AwesomeDialog? _awesomeDialog;
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
          WidgetsBinding.instance.addPostFrameCallback((_) async {
        //* //*----------------- SHAKE SLIDERS DIALOG ---------------------//
        // ShakeDetector.autoStart(
        //   shakeThresholdGravity: 1.75,
        //   onPhoneShake: () async {
        //     printLog('onPhoneShake WORKING');
        //     if (model.sliders != null && model.sliders!.isNotEmpty) {
        //       //*GENERATES a new Random object
        //       final _random = Random();

        //       // GENERATES a random index based on the list length
        //       // and USE it to RETRIEVE the element
        //       final _selectedRandomSlider =
        //           model.sliders![_random.nextInt(model.sliders!.length)];

        //       //*DISMISSES previous awesome dialog
        //       if (_awesomeDialog != null) {
        //         printLog('_awesomeDialog CALLED');
        //         _awesomeDialog?.dismiss();
        //         _awesomeDialog = null;
        //       }

        //       _awesomeDialog = awesomeDialog.AwesomeDialog(
        //         context: context,
        //         width: 1.sw,
        //         showCloseIcon: false,
        //         headerAnimationLoop: false,
        //         padding: EdgeInsets.zero,
        //         // onDissmissCallback: (value) {
        //         //   _awesomeDialog?.dismiss();
        //         //   printLog('onDissmissCallback value: $value');
        //         // },

        //         //*REMOVES top gap in a dialog
        //         bodyHeaderDistance: 0,
        //         dialogBackgroundColor: Colors.transparent,
        //         animType: awesomeDialog.AnimType.SCALE,
        //         dialogType: awesomeDialog.DialogType.NO_HEADER,
        //         body: FittedBox(
        //           child: GestureDetector(
        //             onTap: () async {
        //               _awesomeDialog?.dismiss();
        //               _awesomeDialog = null;
        //               _selectedRandomSlider.option == 'restoran'
        //                   ? await model.navToResDetailsViewViaAwesomeDialog(
        //                       _selectedRandomSlider.restaurant!)
        //                   : await model
        //                       .navToSliderWebview(_selectedRandomSlider.url!);
        //             },
        //             child: YodaImage(
        //               //*CHANGES slider image by localization
        //               image: context.locale == context.supportedLocales[0]
        //                   ? _selectedRandomSlider.image!
        //                   : _selectedRandomSlider.imageRu!,
        //               phImage: 'assets/ph_slider.png',
        //               borderRadius: 20.0,
        //             ),
        //           ),
        //         ),
        //       )..show();
        //     }
        //   },
        // );

        //*HOME RESS PAG
        if (model.isPullUpEnabled == false) model.enablePullUp();

        //*This TRIGGERS fetch action of home data
        await _refreshController.requestRefresh();

        //*InAppUpdate for Android only (FLEXIBLE UPDATE STYLE)
        if (Platform.isAndroid) {
          var info = await InAppUpdate.checkForUpdate();

          // model.log.v('InAppUpdate Info: $info');
          printLog('InAppUpdate Info: $info');
          // model.log.v(
          //     'InAppUpdate Info.availableVersionCode: ${info.availableVersionCode}');
          printLog(
              'InAppUpdate Info.availableVersionCode: ${info.availableVersionCode}');
          if (info.updateAvailability == 2) {
            printLog('I AM IN startFlexibleUpdate(): ');
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          }
        }

        //*HANDLES clicked terminated dynamic link
        await model.handleClickedDynamicLink();

        //* HANDLES hiveRatings
        if (model.hiveRating != null) await model.checkAndShowFirstHiveRating();
      }),
      builder: (context, model, child) {
        if (model.fetchingFilterError && model.cartRes!.id != -1)
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            model.updateFetchingSelectedError();
            await model.showCustomFlashBar(
              context: context,
              isCartEmpty: false,
            );
          });
        else if (model.fetchingFilterError)
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            model.updateFetchingSelectedError();
            await model.showCustomFlashBar(context: context);
          });

        //*----------------- SELECTED CATS LOADING VIEW ---------------------//
        Widget body = model.fetchingFilter
            ? CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 0.1.sh,
                    backgroundColor: kcWhiteColor,
                    systemOverlayStyle: customSystemUiOverlayStyle(),
                    elevation: 0,
                    toolbarHeight: 60.h,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.r),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                //*----------------- MENU ---------------------//
                                IconButton(
                                  icon: Icon(
                                    Icons.menu_rounded,
                                    size: 24.sp,
                                  ),
                                  onPressed: model.homeMenuPressed,
                                  tooltip: 'Drawer',
                                ),
                                //*----------------- SEARCH ---------------------//
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
            :
            //*----------------- HOME MAIN VIEW ---------------------//
            Stack(
                children: [
                  SmartRefresher(
                    header: CustomHeaderWidget(),
                    footer: CustomFooterWidget(),
                    controller: _refreshController,

                    //*HOME RESS PAG
                    enablePullUp: model.isPullUpEnabled,
                    onRefresh: () async {
                      //*HOME RESS PAG
                      if (model.isPullUpEnabled == false) model.enablePullUp();

                      await model.getHomeData();
                      _refreshController.refreshCompleted();
                    },

                    //*HOME RESS PAG
                    onLoading: () async {
                      await model.getMorePaginatedRestaurants();
                      _refreshController.loadComplete();
                    },
                    //*----------------- HOME ERROR VIEW ---------------------//
                    child: model.hasErrorForKeys
                        ? CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                expandedHeight: 0.3.sh,
                                backgroundColor: kcWhiteColor,
                                systemOverlayStyle:
                                    customSystemUiOverlayStyle(),
                                elevation: 0,
                                toolbarHeight: 60.h,
                                automaticallyImplyLeading: false,
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.r),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            //*----------------- MENU ---------------------//
                                            IconButton(
                                              icon: Icon(
                                                Icons.menu_rounded,
                                                size: 24.sp,
                                              ),
                                              onPressed: model.homeMenuPressed,
                                              tooltip: 'Drawer',
                                            ),
                                            //*----------------- SEARCH ---------------------//
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
                                      modelCallBack: () async =>
                                          await _refreshController
                                              .requestRefresh(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        //*----------------- HOME SUCCESS VIEW ---------------------//
                        //*----------------- DEFAULT HOME VIEW ---------------------//
                        : CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                expandedHeight:

                                    //*If MAIN CAT FILTER is APPLIED
                                    !model.isFilterApplied
                                        ? getValueForScreenType<double>(
                                            context: context,
                                            mobile: 0.36.sh,
                                            tablet: 0.45.sh,
                                          )
                                        : 0.1.sh,
                                backgroundColor: kcWhiteColor,
                                systemOverlayStyle:
                                    customSystemUiOverlayStyle(),
                                elevation: 0,
                                toolbarHeight: kToolbarHeight,
                                automaticallyImplyLeading: false,
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 12.r),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            //*----------------- MENU ---------------------//
                                            IconButton(
                                              icon: Icon(
                                                Icons.menu_rounded,
                                                size: 24.sp,
                                              ),
                                              onPressed: model.homeMenuPressed,
                                              tooltip: 'Drawer',
                                            ),
                                            //*----------------- SEARCH ---------------------//
                                            HomeSearch(),
                                          ],
                                        ),
                                      ),
                                      //*----------------- SLIDERS ---------------------//
                                      //*If MAIN CAT FILTER is APPLIED
                                      if (!model.isFilterApplied)
                                        SliderView(
                                          sliders: model.sliders ?? [],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              //*----------------- HOME CATEGORIES ---------------------//
                              SliverPersistentHeader(
                                pinned: false,
                                floating: false,
                                delegate: ContestTabHeader(
                                  //*If MAIN CAT FILTER is APPLIED
                                  size: !model.isFilterApplied ? 90.r : 94.r,
                                  child: MainCatView(),
                                ),
                              ),
                              //*----------------- EXCLUSIVES ---------------------//
                              //*If MAIN CAT FILTER is APPLIED
                              if (!model.isFilterApplied &&
                                  (model.exclusives ?? []).isNotEmpty)
                                SliverPersistentHeader(
                                  pinned: false,
                                  floating: false,
                                  delegate: ContestTabHeader(
                                    size: 160.r,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 16.r,
                                            top: 14.r,
                                          ),
                                          child: Text(
                                            model.exclusives![0].name ?? '',
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.bold,
                                              color: kcSecondaryDarkColor,
                                            ),
                                          ),
                                        ),
                                        HomeExclusive(
                                            exlusiveSingles: model
                                                .exclusives![0]
                                                .exclusiveSingles!),
                                      ],
                                    ),
                                  ),
                                ),
                              //*----------------- BODY: RESTAURANTS ---------------------//
                              //*----------------- DEFAULT BODY VIEW ---------------------//
                              //*If MAIN CAT FILTER is APPLIED
                              !model.isFilterApplied
                                  ? SliverPadding(
                                      padding: EdgeInsets.only(
                                        top: 14.r,
                                        bottom: 0.11
                                            .sh, // COMPENSATES HomeBottomCart
                                      ), // Changes based on exclusive part
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int pos) {
                                            final _homeRes =
                                                model.homeRess![pos];

                                            // //*----------- RESTAURANT with PROMOTED INCLUDED in every manual position --------------//
                                            return _homeRes.prom != null
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      //*----------------- RESTAURANT with PROMOTED ---------------------//
                                                      RestaurantView(
                                                        restaurant:
                                                            _homeRes.restaurant,
                                                      ),
                                                      // PROMOTED Title
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 16.r,
                                                                top: 2.r),
                                                        child: Text(
                                                          _homeRes.prom?.name ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: 24.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                kcSecondaryDarkColor,
                                                          ),
                                                        ),
                                                      ),

                                                      //*List of restaurants of pos'th PROMOTED
                                                      SingleChildScrollView(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: _homeRes
                                                              .prom!
                                                              .restaurants!
                                                              .map((promRes) {
                                                            return PromResView(
                                                              restaurant:
                                                                  promRes,
                                                              promRess: _homeRes
                                                                  .prom!
                                                                  .restaurants!,
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                //*----------------- RESTAURANT without Promoted ---------------------//
                                                : RestaurantView(
                                                    restaurant:
                                                        _homeRes.restaurant,
                                                  );
                                          },
                                          childCount:
                                              model.homeRess?.length ?? 0,
                                        ),
                                      ),
                                    )

                                  //*----------------- SELECTED CATS BODY VIEW ---------------------//
                                  : SliverList(
                                      delegate: SliverChildListDelegate(
                                        [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.r,
                                                    vertical: 6.r),
                                                child: Divider(
                                                  thickness: 1,
                                                ),
                                              ),

                                              //*----------------- FOUND TITLE and CLEAR part ---------------------//
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.r,
                                                    vertical: 4.r),
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
                                                      style: kts18BoldText,
                                                    ).tr(args: [
                                                      model
                                                          .selectedMainCatRestaurants
                                                          .length
                                                          .toString()
                                                    ]),
                                                    SizedBox(width: 5.r),
                                                    CustomTextChildButton(
                                                        child: Text(
                                                          LocaleKeys.clear,
                                                          style: kts16Text,
                                                        ).tr(),
                                                        color:
                                                            kcSecondaryLightColor,
                                                        borderRadius:
                                                            AppTheme().radius20,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: 6.r,
                                                          horizontal: 20.r,
                                                        ),
                                                        onPressed: () async {
                                                          await model
                                                              .clearSelectedMainCatRess();
                                                          await _refreshController
                                                              .requestRefresh();
                                                        }),
                                                  ],
                                                ),
                                              ),
                                              //*----------------- SELECTED MAIN CATS RESULT LIST ---------------------//
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding:
                                                    EdgeInsets.only(top: 10.r),
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
                                          if (!model.hasErrorForKeys &&
                                              model.cartRes!.id != -1)
                                            SizedBox(
                                                height: 0.11
                                                    .sh), // COMPENSATES HomeBottomCart
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                  ),

                  //*----------------- BOTTOM CART ---------------------//
                  if (!model.hasErrorForKeys && model.cartRes!.id != -1)
                    HomeBottomCart()
                ],
              );
        return
            // AnnotatedRegion<SystemUiOverlayStyle>(
            //   value: SystemUiOverlayStyle.dark,
            //   child:
            Scaffold(
          //* Resize according to Onscreen keyboard
          resizeToAvoidBottomInset: true,
          key: model.homeScaffoldKey,
          drawer: DrawerView(),
          //* Custom colorful safe area to create IOS like status bar that is compatible with SliverAppBar
          body: ColorfulSafeArea(
            left: false,
            right: false,
            bottom: false,
            color: kcWhiteColor,
            child: Platform.isIOS
                ? UpgradeAlert(
                    upgrader: Upgrader(
                      shouldPopScope: () => true,
                      messages: context.locale == context.supportedLocales[0]
                          ? MyTurkmenMessages()
                          : MyRussianMessages(),
                    ),
                    child: DoubleBackToCloseApp(
                      snackBar: SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        margin: EdgeInsets.only(
                          left: 16.r,
                          right: 16.r,
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
                  )
                : DoubleBackToCloseApp(
                    snackBar: SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.only(
                        left: 16.r,
                        right: 16.r,
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
