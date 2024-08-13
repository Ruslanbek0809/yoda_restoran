import 'dart:io';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:yoda_res/services/sentry/sentry_module.dart';
import 'package:yoda_res/ui/home/moments/moments_view.dart';
import '../../generated/locale_keys.g.dart';
import '../../library/upgrader_translations.dart';
import '../drawer/drawer_view.dart';
import '../../shared/shared.dart';
import 'home_bottom_cart.dart';
import 'home_exclusives/home_exclusive.dart';
import 'main_category/main_cats_view.dart';
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
        //*HOME RESS PAG
        if (!model.isPullUpEnabled) model.enablePullUp();

        //*This TRIGGERS fetch action of home data
        await _refreshController.requestRefresh();

        //* InAppUpdate for Android only (FLEXIBLE UPDATE STYLE)
        if (Platform.isAndroid) {
          try {
            var info = await InAppUpdate.checkForUpdate();

            printLog('InAppUpdate Info: $info');
            printLog(
              'InAppUpdate Info.availableVersionCode: ${info.availableVersionCode}',
            );
            if (info.updateAvailability == UpdateAvailability.updateAvailable) {
              printLog('Starting flexible update...');
              await InAppUpdate.startFlexibleUpdate().then((value) async {
                await InAppUpdate.completeFlexibleUpdate();
              }).catchError((error) {
                reportExceptionToSentry(
                  error,
                  additionalInfo:
                      'MY ERROR SENTRY => Error during flexible update completion',
                );
              });
            }
          } on PlatformException catch (e) {
            switch (e.code) {
              case 'TASK_FAILURE':
                reportExceptionToSentry(
                  e,
                  additionalInfo:
                      'MY ERROR SENTRY => TASK_FAILURE during in-app update',
                );
                break;
              case 'Install Error(-9)':
                reportExceptionToSentry(
                  e,
                  additionalInfo:
                      'MY ERROR SENTRY => Play Store not found during in-app update',
                );
                break;
              default:
                reportExceptionToSentry(
                  e,
                  additionalInfo:
                      'MY ERROR SENTRY => PlatformException during in-app update',
                );
                break;
            }
          } catch (e) {
            reportExceptionToSentry(
              e,
              additionalInfo:
                  'MY ERROR SENTRY => Unexpected error during in-app update',
            );
          }
        }

        //*HANDLES clicked terminated dynamic link
        await model.handleClickedDynamicLink();

        //* HANDLES hiveRatings
        if (model.hiveRating != null) await model.checkAndShowFirstHiveRating();
      }),
      builder: (context, model, child) {
        //* SHOWS custom ERROR snackbar when there is FILTER ERROR
        if (model.fetchingFilterError && model.cartRes!.id != -1)
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            model.disableActiveFilterErrorFromView();
            await model.showCustomFlashBar(
              context: context,
              isCartEmpty: false,
            );
          });
        //* SHOWS custom ERROR snackbar when there is FILTER ERROR
        else if (model.fetchingFilterError)
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            model.disableActiveFilterErrorFromView();
            await model.showCustomFlashBar(context: context);
          });

        //*----------------- SELECTED CATS LOADING VIEW ---------------------//
        Widget body = model.fetchingFilter
            ? CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: SizeExtension(0.1).sh,
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
                                //*----------------- RESTAURANTS VIEW ---------------------//
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/restaurants_icon.svg',
                                  ),
                                  onPressed: model.navToRestaurantsView,
                                  tooltip: 'Restaurants',
                                ),
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
                          padding: EdgeInsets.only(top: SizeExtension(0.4).sh),
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
                      await HapticFeedback.lightImpact();
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
                                expandedHeight: SizeExtension(0.3).sh,
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
                                            //*----------------- RESTAURANTS VIEW ---------------------//
                                            IconButton(
                                              icon: SvgPicture.asset(
                                                'assets/restaurants_icon.svg',
                                              ),
                                              onPressed:
                                                  model.navToRestaurantsView,
                                              tooltip: 'Restaurants',
                                            ),
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
                                            mobile: SizeExtension(0.075).sh +
                                                SizeExtension(0.6).sw,
                                            // mobile: 0.36.sh,
                                            tablet: SizeExtension(0.45).sh,
                                          )
                                        : SizeExtension(0.1).sh,
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
                                            //*----------------- RESTAURANTS VIEW ---------------------//
                                            IconButton(
                                              icon: SvgPicture.asset(
                                                'assets/restaurants_icon.svg',
                                              ),
                                              onPressed:
                                                  model.navToRestaurantsView,
                                              tooltip: 'Restaurants',
                                            ),
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
                                  size: !model.isFilterApplied ? 91.r : 95.r,
                                  child: MainCatsView(),
                                ),
                              ),
                              //*----------------- MOMENTS ---------------------//
                              if (model.moments!.isNotEmpty)
                                SliverPersistentHeader(
                                  pinned: false,
                                  floating: false,
                                  delegate: ContestTabHeader(
                                    //*If MAIN CAT FILTER is APPLIED
                                    size: 64 +
                                        36 +
                                        22.r, //* cached image height + title height + height paddings height
                                    child: MomentsView(moments: model.moments!),
                                  ),
                                ),
                              //*----------------- EXCLUSIVES ---------------------//
                              //*----------------- FILTER/MAINCAT is NOT APPLIED ---------------------//
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
                              //*----------------- FILTER/MAINCAT is NOT APPLIED ---------------------//
                              !model.isFilterApplied
                                  ? SliverPadding(
                                      padding: EdgeInsets.only(
                                        top: 14.r,
                                        bottom: SizeExtension(0.11)
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

                                  //*----------------- FILTER/MAINCAT is APPLIED ---------------------//
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
                                                height: SizeExtension(0.11)
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
          body:
              // Stack(
              //   children: <Widget>[
              ColorfulSafeArea(
            left: false,
            right: false,
            bottom: false,
            color: kcWhiteColor,
            child: Platform.isIOS
                ? UpgradeAlert(
                    shouldPopScope: () => true,
                    dialogStyle: UpgradeDialogStyle.cupertino,
                    upgrader: Upgrader(
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
                          bottom: SizeExtension(0.05).sh,
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
                        bottom: SizeExtension(0.05).sh,
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
          // Positioned.fill(
          //   child: IgnorePointer(
          //     child: SnowWidget(
          //       isRunning: true,
          //       totalSnow: 50,
          //       speed: 0.2,
          //       maxRadius: 8,
          //       snowColor: Colors.white,
          //     ),
          //   ),
          // ),
          //   ],
          // ),
        );
        // );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
