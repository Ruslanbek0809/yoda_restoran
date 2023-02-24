import 'dart:io';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import '../../toggle_buttons/toggle_buttons_view.dart';
import 'res_details_info_bottom_sheet.dart';
import 'res_details_notification_bell_bottom_sheet.dart';
import 'res_details_view_model.dart';

class ResDetailsAppBar extends SliverAppBar {
  final BuildContext context;
  final ResDetailsViewModel model;
  final List<ResCategory> resCategories;
  final bool isCollapsed;
  final int activeTab;
  final bool isTabPressed;
  final double expandedHeight;
  final double collapsedHeight;
  final AutoScrollController scrollController;
  final TabController tabController;
  final void Function(bool isCollapsed) onCollapsed;
  final void Function(int index) onTap;

  ResDetailsAppBar({
    required this.context,
    required this.model,
    // required this.restaurant,
    required this.resCategories,
    required this.isCollapsed,
    required this.activeTab,
    required this.isTabPressed,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.scrollController,
    required this.onCollapsed,
    required this.onTap,
    required this.tabController,
  }) : super(
          elevation: 0.0,
          pinned: true,
          stretch: true,
        );

//*----------------- BACKGROUND COLOR OVERRIDE ---------------------//
  @override
  Color? get backgroundColor => kcWhiteColor;

//*----------------- LEADING OVERRIDE ---------------------//
  @override
  Widget? get leading {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Container(
        height: 50.w,
        width: 50.r,
        margin: EdgeInsets.only(left: 10.r, top: 5.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kcWhiteColor,
        ),
        child: Material(
          color: kcWhiteColor,
          shape: CircleBorder(),
          elevation: 0,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 27.w,
              color: kcBlackColor,
            ),
          ),
        ),
      ),
    );
  }

//*----------------- ACTIONS OVERRIDE ---------------------//
  @override
  List<Widget>? get actions {
    return [
//*----------------- ACTIONS FAVOURITE ---------------------//
      AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: isCollapsed
            ? SizedBox()
            : AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Padding(
                  padding: EdgeInsets.only(top: 5.w),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCollapsed ? Colors.transparent : kcWhiteColor,
                    ),
                    child: Material(
                      shape: CircleBorder(),
                      elevation: 0,
                      color: isCollapsed ? Colors.transparent : kcWhiteColor,
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () => model.updateResFav(model.restaurant.id!),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            model.isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 27.w,
                            color:
                                model.isFavorited ? kcRedColor : kcBlackColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
      SizedBox(width: 10.w),
//*----------------- ACTIONS SEARCH ---------------------//
      AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Padding(
          padding: EdgeInsets.only(top: 5.w),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kcWhiteColor,
            ),
            child: Material(
              shape: CircleBorder(),
              elevation: 0,
              color: kcWhiteColor,
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: () => model.navToResSearchView(),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    CupertinoIcons.search,
                    size: 27.r,
                    color: kcBlackColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(width: 15.w),
    ];
  }

//*----------------- TITLE OVERRIDE ---------------------//
  @override
  Widget? get title {
    return AnimatedOpacity(
      opacity: this.isCollapsed ? 0 : 1,
      duration: const Duration(milliseconds: 250),
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, top: 5.w),
        child: Text(
          model.restaurant.name ?? '',
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontSize: 20.sp,
            color: kcFontColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

//*----------------- FLEXIBLE SPACE OVERRIDE ---------------------//
  @override
  Widget? get flexibleSpace {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final top = constraints.constrainHeight();
        final collapsedHight =
            MediaQuery.of(context).viewPadding.top + kToolbarHeight + 48;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          onCollapsed(collapsedHight != top);
        });

        return FlexibleSpaceBar(
          stretchModes: [StretchMode.zoomBackground],
          background: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  model.restaurant.image ?? 'assets/ph_restaurant.png',
                ),
                // fit: BoxFit.cover,
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kcWhiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: Platform.isIOS ? 14.h : 12.h,
                    bottom: 50.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //*----------------- TITLE NAME ---------------------//
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: Platform.isIOS ? 12.h : 10.h,
                          left: 16.w,
                          right: 16.w,
                        ),
                        child: Text(
                          model.restaurant.name ?? '',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: kcSecondaryDarkColor,
                          ),
                        ),
                      ),
                      //*----------------- RATE / WORK TIME / INFO---------------------//
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            //*----------------- RATE ---------------------//
                            Container(
                              decoration: BoxDecoration(
                                color: kcSecondaryLightColor,
                                borderRadius: AppTheme().radius20,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8.r,
                                horizontal: 10.r,
                              ),
                              margin: EdgeInsets.only(
                                top: 5.h,
                                bottom: 5.h,
                                left: 16.w,
                                right: 10.w,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/star.svg',
                                    color: kcSecondaryDarkColor,
                                    width: 20.w,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    formatNumRating(
                                        model.restaurant.rating ?? 5),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: kcFontColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //*----------------- LOCATION ---------------------//
                            Container(
                              decoration: BoxDecoration(
                                color: kcSecondaryLightColor,
                                borderRadius: AppTheme().radius20,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8.r,
                                horizontal: 10.r,
                              ),
                              margin: EdgeInsets.only(
                                top: 5.h,
                                bottom: 5.h,
                                right: 10.w,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/map_pin_bold.svg',
                                    color: kcSecondaryDarkColor,
                                    width: 20.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  // Below condition checks whether res is LOCAL one or NOT
                                  model.locationPosition != null &&
                                          model.restaurant.paymentTypes !=
                                              null &&
                                          model.restaurant.notification !=
                                              null &&
                                          model.restaurant.notification!.isEmpty
                                      ? Row(
                                          children: [
                                            Text(
                                              '${getCustomResCityName(model.restaurant.city ?? '')} (${model.restaurant.distance} ',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: kcFontColor,
                                              ),
                                            ),
                                            Text(
                                              LocaleKeys.km,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: kcFontColor,
                                              ),
                                            ).tr(),
                                            Text(
                                              ')',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: kcFontColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          getCustomResCityName(
                                              model.restaurant.city ?? ''),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: kcFontColor,
                                          ),
                                        ),
                                ],
                              ),
                            ),

                            //*----------------- RESTAURANT DETAILS INFO BOTTOM SHEET ---------------------//
                            GestureDetector(
                              //*CUSTOM BOTTOM SHEET BASED ON CONTENT
                              onTap: () async => await showFlexibleBottomSheet(
                                isExpand: false,
                                initHeight: 0.95,
                                maxHeight: 0.95,
                                duration: Duration(milliseconds: 250),
                                context: context,
                                bottomSheetColor: Colors.transparent,
                                builder: (context, scrollController, offset) {
                                  return ResDetailsInfoBottomSheet(
                                    scrollController: scrollController,
                                    offset: offset,
                                    restaurant: model.restaurant,
                                  );
                                },
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kcSecondaryLightColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4.r),
                                margin: EdgeInsets.only(right: 10.w),
                                child: SvgPicture.asset(
                                  'assets/restaurant_info.svg',
                                  color: kcSecondaryDarkColor,
                                ),
                              ),
                            ),

                            //*----------------- RESTAURANT DETAILS NOTIFICATION BELL BOTTOM SHEET ---------------------//
                            if (model.restaurant.notification != null &&
                                model.restaurant.notification!.isNotEmpty)
                              GestureDetector(
                                //*CUSTOM BOTTOM SHEET BASED ON CONTENT
                                onTap: () async =>
                                    await showFlexibleBottomSheet(
                                  isExpand: false,
                                  initHeight: 0.95,
                                  maxHeight: 0.95,
                                  duration: Duration(milliseconds: 250),
                                  context: context,
                                  bottomSheetColor: Colors.transparent,
                                  builder: (context, scrollController, offset) {
                                    return ResDetailsNotificationBellBottomSheet(
                                      scrollController: scrollController,
                                      offset: offset,
                                      restaurant: model.restaurant,
                                    );
                                  },
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kcSecondaryLightColor,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(8.r),
                                  margin: EdgeInsets.only(
                                    top: 5.h,
                                    bottom: 5.h,
                                    right: 16.w,
                                  ),
                                  child: Lottie.asset(
                                    'assets/bell.json',
                                    width: 20.r,
                                    repeat: false,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 16.w,
                        ),
                        child: Divider(
                          color: kcSecondaryLightColor,
                          thickness: 1.w,
                        ),
                      ),
                      //*----------------- DELIVERY/SELF-PICKUP ---------------------//
                      ToggleButtonView(restaurant: model.restaurant),
                      //*----------------- MAIN DIVIDER ---------------------//
                      Container(
                        color: kcMainDividerColor,
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        margin: EdgeInsets.only(top: 15.h),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//*----------------- BOTTOM OVERRIDE ---------------------//
  @override
  PreferredSizeWidget? get bottom {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        decoration: BoxDecoration(
          color: kcWhiteColor,
          boxShadow: !isCollapsed ? [AppTheme().tabBarShadow] : [],
        ),
        child: TabBar(
          isScrollable: resCategories.isNotEmpty && resCategories.length < 4
              ? false
              : true,
          controller: tabController,
          indicatorColor: Colors.transparent,
          // indicatorWeight: 3.0,
          // indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          labelColor: kcPrimaryColor,
          labelPadding: EdgeInsets.all(0.0),
          // unselectedLabelColor: kcFontColor,
          tabs: resCategories.map((resCategory) {
            return Tab(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: AppTheme().radius15,
                  color: model.activeTab == resCategories.indexOf(resCategory)
                      ? model.isTabPressed
                          ? kcSecondaryLightColor
                          : kcWhiteColor
                      : kcWhiteColor,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 2.h,
                  horizontal: 5.w,
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                alignment: Alignment.center,
                child: Text(
                  resCategory.resCategoryModel?.name ?? '',
                  style: kts14SemiBoldText,
                ),
              ),
            );
          }).toList(),
          onTap: onTap,
        ),
      ),
    );
  }
}
// background: Stack(
//             children: [
//               /// BACKGROUND IMAGE
//               Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: CachedNetworkImageProvider(
//                       restaurant.image ?? 'assets/ph_restaurant.png',
//                     ),
//                     fit: BoxFit.cover,
//                     // fit: BoxFit.contain,
//                     // alignment: Alignment.topCenter,
//                   ),
//                 ),
//               ),

//               /// FRONT CONTENT
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: kcWhiteColor,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20.0),
//                         topRight: Radius.circular(20.0),
//                       ),
//                     ),
//                     padding: EdgeInsets.only(
//                         top: Platform.isIOS ? 14.h : 12.h, bottom: 0.h),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         //*----------------- TITLE NAME ---------------------//
//                         Padding(
//                           padding: EdgeInsets.only(
//                             bottom: Platform.isIOS ? 12.h : 10.h,
//                             left: 16.w,
//                             right: 16.w,
//                           ),
//                           child: Text(
//                             restaurant.name ?? '',
//                             style: TextStyle(
//                               fontSize: 30.sp,
//                               fontWeight: FontWeight.bold,
//                               color: kcSecondaryDarkColor,
//                             ),
//                           ),
//                         ),
//                         //*----------------- RATE / WORK TIME / INFO---------------------//
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               //*----------------- RATE ---------------------//
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: kcSecondaryLightColor,
//                                   borderRadius: AppTheme().radius20,
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: 8.r,
//                                   horizontal: 10.r,
//                                 ),
//                                 margin: EdgeInsets.only(
//                                   top: 5.h,
//                                   bottom: 5.h,
//                                   left: 16.w,
//                                   right: 10.w,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     SvgPicture.asset(
//                                       'assets/star.svg',
//                                       color: kcSecondaryDarkColor,
//                                       width: 20.w,
//                                     ),
//                                     SizedBox(width: 5.w),
//                                     Text(
//                                       formatNumRating(restaurant.rating ?? 5),
//                                       style: TextStyle(
//                                         fontSize: 15.sp,
//                                         color: kcFontColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               //*----------------- LOCATION ---------------------//
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: kcSecondaryLightColor,
//                                   borderRadius: AppTheme().radius20,
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: 8.r,
//                                   horizontal: 10.r,
//                                 ),
//                                 margin: EdgeInsets.only(
//                                   top: 5.h,
//                                   bottom: 5.h,
//                                   right: 10.w,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     SvgPicture.asset(
//                                       'assets/map_pin_bold.svg',
//                                       color: kcSecondaryDarkColor,
//                                       width: 20.w,
//                                     ),
//                                     SizedBox(width: 3.w),
//                                     // // Below condition checks whether res is LOCAL one or NOT
//                                     // model.locationPosition != null &&
//                                     //         restaurant.paymentTypes != null &&
//                                     //         restaurant.notification != null &&
//                                     //         restaurant.notification!.isEmpty
//                                     //     ? Row(
//                                     //         children: [
//                                     //           Text(
//                                     //             '${restaurant.city} (${restaurant.distance} ',
//                                     //             overflow: TextOverflow.ellipsis,
//                                     //             style: TextStyle(
//                                     //               fontSize: 16.sp,
//                                     //               color: kcFontColor,
//                                     //             ),
//                                     //           ),
//                                     //           Text(
//                                     //             LocaleKeys.km,
//                                     //             overflow: TextOverflow.ellipsis,
//                                     //             style: TextStyle(
//                                     //               fontSize: 16.sp,
//                                     //               color: kcFontColor,
//                                     //             ),
//                                     //           ).tr(),
//                                     //           Text(
//                                     //             ')',
//                                     //             overflow: TextOverflow.ellipsis,
//                                     //             style: TextStyle(
//                                     //               fontSize: 16.sp,
//                                     //               color: kcFontColor,
//                                     //             ),
//                                     //           ),
//                                     //         ],
//                                     //       )
//                                     //     : Text(
//                                     //         restaurant.city ?? '',
//                                     //         overflow: TextOverflow.ellipsis,
//                                     //         style: TextStyle(
//                                     //           fontSize: 16.sp,
//                                     //           color: kcFontColor,
//                                     //         ),
//                                     //       ),
//                                   ],
//                                 ),
//                               ),

//                               //*----------------- RESTAURANT DETAILS INFO BOTTOM SHEET ---------------------//
//                               GestureDetector(
//                                 //*CUSTOM BOTTOM SHEET BASED ON CONTENT
//                                 onTap: () async =>
//                                     await showFlexibleBottomSheet(
//                                   isExpand: false,
//                                   initHeight: 0.95,
//                                   maxHeight: 0.95,
//                                   duration: Duration(milliseconds: 250),
//                                   context: context,
//                                   bottomSheetColor: Colors.transparent,
//                                   builder: (context, scrollController, offset) {
//                                     return ResDetailsInfoBottomSheet(
//                                       scrollController: scrollController,
//                                       offset: offset,
//                                       restaurant: restaurant,
//                                     );
//                                   },
//                                 ),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: kcSecondaryLightColor,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   padding: EdgeInsets.all(4.r),
//                                   margin: EdgeInsets.only(right: 10.w),
//                                   child: SvgPicture.asset(
//                                     'assets/restaurant_info.svg',
//                                     color: kcSecondaryDarkColor,
//                                   ),
//                                 ),
//                               ),

//                               //*----------------- RESTAURANT DETAILS NOTIFICATION BELL BOTTOM SHEET ---------------------//
//                               if (restaurant.notification != null &&
//                                   restaurant.notification!.isNotEmpty)
//                                 GestureDetector(
//                                   //*CUSTOM BOTTOM SHEET BASED ON CONTENT
//                                   onTap: () async =>
//                                       await showFlexibleBottomSheet(
//                                     isExpand: false,
//                                     initHeight: 0.95,
//                                     maxHeight: 0.95,
//                                     duration: Duration(milliseconds: 250),
//                                     context: context,
//                                     bottomSheetColor: Colors.transparent,
//                                     builder:
//                                         (context, scrollController, offset) {
//                                       return ResDetailsNotificationBellBottomSheet(
//                                         scrollController: scrollController,
//                                         offset: offset,
//                                         restaurant: restaurant,
//                                       );
//                                     },
//                                   ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: kcSecondaryLightColor,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     padding: EdgeInsets.all(8.r),
//                                     margin: EdgeInsets.only(
//                                       top: 5.h,
//                                       bottom: 5.h,
//                                       right: 16.w,
//                                     ),
//                                     child: Lottie.asset(
//                                       'assets/bell.json',
//                                       width: 20.r,
//                                       repeat: false,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: 8.h,
//                             horizontal: 16.w,
//                           ),
//                           child: Divider(
//                             color: kcSecondaryLightColor,
//                             thickness: 1.w,
//                           ),
//                         ),
//                         //*----------------- DELIVERY/SELF-PICKUP ---------------------//
//                         ToggleButtonView(restaurant: restaurant),
//                         //*----------------- MAIN DIVIDER ---------------------//
//                         Container(
//                           color: kcMainDividerColor,
//                           padding: EdgeInsets.symmetric(vertical: 4.h),
//                           margin: EdgeInsets.only(top: 15.h),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),