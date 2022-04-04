import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../../models/models.dart';
import '../../toggle_buttons/toggle_buttons_view.dart';
import '../../widgets/loading_widget.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'res_details_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class ResDetailsMainBusy extends ViewModelWidget<ResDetailsViewModel> {
  final Restaurant restaurant;
  const ResDetailsMainBusy({required this.restaurant, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, ResDetailsViewModel model) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        //------------------ ARROW BACK ---------------------//
        SliverAppBar(
          expandedHeight: 0.55.sh,
          pinned: true,
          stretch: true,
          floating: false,
          backgroundColor: AppTheme.WHITE,
          centerTitle: true,
          title: SizedBox(),
          leading: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Container(
              height: 50.w,
              width: 50.w,
              margin: EdgeInsets.only(left: 10.w, top: 5.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.WHITE,
              ),
              child: Material(
                color: AppTheme.WHITE,
                shape: CircleBorder(),
                elevation: 0,
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 27.w,
                    color: AppTheme.BLACK,
                  ),
                ),
              ),
            ),
          ),
          //------------------ ACTIONS FAV ---------------------//
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 5.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.WHITE,
                  // boxShadow: _isShrink
                  //     ? []
                  //     : [AppTheme().buttonShadow],
                ),
                child: Material(
                  shape: CircleBorder(),
                  elevation: 0,
                  color: AppTheme.WHITE,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.favorite_outline_outlined,
                        size: 27.w,
                        color: AppTheme.BLACK,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
//------------------ ACTIONS SEARCH ---------------------//
            Padding(
              padding: EdgeInsets.only(top: 5.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.WHITE,
                  // boxShadow: _isShrink ? [] : [AppTheme().buttonShadow],
                ),
                child: Material(
                  shape: CircleBorder(),
                  elevation: 0,
                  color: AppTheme.WHITE,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.search,
                        size: 27.w,
                        color: AppTheme.BLACK,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
          ],
          //------------------ BACKGROUND RESTAURANT IMAGE ---------------------//
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [StretchMode.zoomBackground],
            //// NOTE: Container background image used to add custom widget in front of this background image
            background: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(restaurant.image!),
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
              //// NOTE: Instead of direct Container Column is used to make child work properly
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.WHITE,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    padding: EdgeInsets.only(
                        top: Platform.isIOS ? 14.h : 12.h, bottom: 50.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //------------------ TITLE NAME ---------------------//
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: Platform.isIOS ? 12.h : 10.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          child: Text(
                            restaurant.name!,
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              color: kcSecondaryDarkColor,
                            ),
                          ),
                        ),
                        //------------------ RATE / WORK TIME / INFO---------------------//
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              //------------------ RATE ---------------------//
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.MAIN_LIGHT,
                                  borderRadius: AppTheme().radius20,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 7.h),
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
                                      color: AppTheme.MAIN_DARK,
                                      width: 20.w,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      restaurant.rating.toString(),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: AppTheme.FONT_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //------------------ WORK TIME ---------------------//
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: AppTheme.MAIN_LIGHT,
                              //     borderRadius: AppTheme().radius20,
                              //   ),
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 10.w, vertical: 7.h),
                              //   margin: EdgeInsets.symmetric(
                              //       vertical: 5.h, horizontal: 10.w),
                              //   child: Row(
                              //     children: [
                              //       SvgPicture.asset(
                              //         'assets/clock.svg',
                              //         color: AppTheme.MAIN_DARK,
                              //         width: 20.w,
                              //       ),
                              //       SizedBox(width: 5.w),
                              //       Text(
                              //         restaurant.workingHours!,
                              //         style: TextStyle(
                              //           fontSize: 16.sp,
                              //           color: AppTheme.FONT_COLOR,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              // if (model.locationPosition != null)
                              //------------------ LOCATION ---------------------//
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.MAIN_LIGHT,
                                  borderRadius: AppTheme().radius20,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 7.h),
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
                                            restaurant.paymentTypes != null
                                        ? Row(
                                            children: [
                                              Text(
                                                '${restaurant.city} (${restaurant.distance} ',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: AppTheme.FONT_COLOR,
                                                ),
                                              ),
                                              Text(
                                                LocaleKeys.km,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: AppTheme.FONT_COLOR,
                                                ),
                                              ).tr(),
                                              Text(
                                                ')',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: AppTheme.FONT_COLOR,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            restaurant.city!,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: AppTheme.FONT_COLOR,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              //------------------ INFO ---------------------//
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.MAIN_LIGHT,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 5.h),
                                  margin: EdgeInsets.only(right: 16.w),
                                  child: SvgPicture.asset(
                                    'assets/restaurant_info.svg',
                                    color: AppTheme.MAIN_DARK,
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
                            color: AppTheme.MAIN_LIGHT,
                            thickness: 1.w,
                          ),
                        ),
//------------------ DELIVERY/SELF-PICKUP ---------------------//
                        ToggleButtonView(restaurant: restaurant),
                        //------------------ MAIN DIVIDER ---------------------//
                        Container(
                          color: AppTheme.MAIN_DIVIDER_COLOR,
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          margin: EdgeInsets.only(top: 15.h),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
//------------------ FOOD LIST with NAME ---------------------//
        SliverToBoxAdapter(
          child: LoadingWidget(),
        ),
      ],
    );
  }
}
