import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:stacked/stacked.dart';
import '../../generated/locale_keys.g.dart';
import '../../shared/app_colors.dart';
import '../../models/models.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';
import 'restaurant_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class RestaurantView extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantView({required this.restaurant, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResViewModel>.reactive(
      /// INITIALIZES hourly discount variables for further condition
      onModelReady: (model) =>
          restaurant.hourlyDiscount != null && restaurant.hourlyDiscount! > 0
              ? model.initializeHourlyDiscountVars(
                  restaurant.discountBegin!, restaurant.discountEnd!)
              : () {},
      builder: (context, model, child) {
        if (model.hasLoggedInUser) model.checkResFav(restaurant.id!);
        return Container(
          margin: EdgeInsets.fromLTRB(16.w, 3.h, 16.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
//------------------ IMAGE with ripple effect ---------------------//
                  GestureDetector(
                    onTap: () => model.navToResDetailsView(restaurant),
                    child: YodaImage(
                      image: restaurant.image!,
                      phImage: 'assets/ph_restaurant.png',
                      height: 0.22.sh,
                      width: 1.sw,
                      borderRadius: Constants.BORDER_RADIUS_20,
                    ),
                  ),

                  /// Used with Stack
                  // Positioned.fill(
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     borderRadius: AppTheme().radius20,
                  //     child: InkWell(
                  //       borderRadius: AppTheme().radius20,
                  //       onTap: () {
                  //         model.navToResDetailsView(restaurant);
                  //       },
                  //     ),
                  //   ),
                  // ),
                  //------------------ DELIVERY TIME ---------------------//
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child:
                        //------------------ WORKING HOURS ---------------------//
                        Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: kcSecondaryDarkColor.withOpacity(0.85),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Constants.BORDER_RADIUS_20),
                          bottomRight:
                              Radius.circular(Constants.BORDER_RADIUS_20),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: 4.w,
                              top: 2.h,
                            ),
                            child: Icon(
                              Icons.access_time_rounded,
                              color: kcWhiteColor,
                              size: 16.sp,
                            ),
                          ),
                          Text(
                            restaurant.workingHours!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: kcWhiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //------------------ FAVOURITE ---------------------//
                  Positioned(
                    top: 10.w,
                    right: 10.w,
                    child: Container(
                      width: 0.11.sw,
                      height: 0.11.sw,
                      decoration: BoxDecoration(
                        color: kcWhiteColor.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => model.updateResFav(restaurant.id!),
                        icon: Icon(
                          model.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: model.isFavorited
                              ? kcRedColor
                              : kcSecondaryDarkColor,
                          size: 25.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //------------------ NAME ---------------------//
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(
                  restaurant.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: kcSecondaryDarkColor,
                  ),
                ),
              ),
              //------------------ LOCATION and RATE ---------------------//
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  model.locationPosition != null
                      ? Row(
                          children: [
                            SvgPicture.asset(
                              'assets/map_pin_bold.svg',
                              color: kcDialogColor,
                              width: 18.w,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              '${restaurant.city} (${restaurant.distance} ',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: kcIconColor,
                              ),
                            ),
                            Text(
                              LocaleKeys.km,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: kcIconColor,
                              ),
                            ).tr(),
                            Text(
                              ')',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: kcIconColor,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            SvgPicture.asset(
                              'assets/map_pin_bold.svg',
                              color: kcDialogColor,
                              width: 18.w,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              restaurant.city!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: kcIconColor,
                              ),
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 22.w,
                        color: kcPrimaryColor,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${formatNumRating(restaurant.rating!)} (${restaurant.rated})',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: kcIconColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              //------------------ DISCOUNT ONLY ---------------------//
              if ((restaurant.discount != null && restaurant.discount! > 0) &&
                  (restaurant.hourlyDiscount == null ||
                      restaurant.hourlyDiscount! == 0) &&
                  !model.isHourlyDiscountActive)
                FittedBox(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kcSecondaryLightColor,
                          borderRadius: AppTheme().radius20,
                        ),
                        margin:
                            EdgeInsets.only(left: 18.w, top: 10.h, bottom: 2.h),
                        padding: EdgeInsets.only(
                            top: 6.h, bottom: 6.w, right: 16.w, left: 22.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: Text(
                                LocaleKeys.discount,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: kcIconColor,
                                ),
                              ).tr(),
                            ),
                            Text(
                              '${formatNum(restaurant.discount!)}%',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: kcIconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 5.h,
                        child: SimpleShadow(
                          child: SvgPicture.asset(
                            'assets/discount.svg',
                            color: kcGreenColor,
                            width: 34.w,
                          ),
                          opacity: 0.1,
                          color: kcSecondaryDarkColor,
                          offset: Offset(2, 2),
                          sigma: 2,
                        ),
                      )
                    ],
                  ),
                ),
              //------------------ HOURLY DISCOUNT ONLY ---------------------//
              if (model.isHourlyDiscountActive ||
                  ((restaurant.discount == null || restaurant.discount! == 0) &&
                      (restaurant.hourlyDiscount != null &&
                          restaurant.hourlyDiscount! > 0) &&
                      !model.isHourlyDiscountActive))
                FittedBox(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kcSecondaryLightColor,
                          borderRadius: AppTheme().radius20,
                        ),
                        margin:
                            EdgeInsets.only(left: 16.w, top: 10.h, bottom: 2.h),
                        padding: EdgeInsets.only(
                            top: 6.h, bottom: 6.w, right: 16.w, left: 24.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: Text(
                                '${restaurant.discountBegin!.formateDateTimeHmOnly()} - ${restaurant.discountEnd!.formateDateTimeHmOnly()}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: kcIconColor,
                                ),
                              ),
                            ),
                            Text(
                              '${formatNum(restaurant.hourlyDiscount!)}%',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: kcIconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 5.h,
                        child: SimpleShadow(
                          child: SvgPicture.asset(
                            'assets/discount.svg',
                            color: kcGreenColor,
                            width: 34.w,
                          ),
                          opacity: 0.1,
                          color: kcSecondaryDarkColor,
                          offset: Offset(2, 2),
                          sigma: 2,
                        ),
                      )
                    ],
                  ),
                ),

              //------------------ DISCOUNT and HOURLY DISCOUNT ---------------------//
              if ((restaurant.discount != null && restaurant.discount! > 0) &&
                  (restaurant.hourlyDiscount != null &&
                      restaurant.hourlyDiscount! > 0) &&
                  !model.isHourlyDiscountActive)
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kcSecondaryLightColor,
                        borderRadius: AppTheme().radius20,
                      ),
                      margin:
                          EdgeInsets.only(left: 18.w, top: 10.h, bottom: 2.h),
                      padding: EdgeInsets.only(
                          top: 6.h, bottom: 6.w, right: 16.w, left: 22.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //------------------ DISCOUNT ---------------------//
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Text(
                                  LocaleKeys.discount,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: kcIconColor,
                                  ),
                                ).tr(),
                              ),
                              Text(
                                '${formatNum(restaurant.discount!)}%',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kcIconColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '/',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: kcIconColor,
                            ),
                          ),
                          //------------------ HOURLY DISCOUNT ---------------------//
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Text(
                                  '${restaurant.discountBegin!.formateDateTimeHmOnly()} - ${restaurant.discountEnd!.formateDateTimeHmOnly()}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: kcIconColor,
                                  ),
                                ),
                              ),
                              Text(
                                '${formatNum(restaurant.hourlyDiscount!)}%',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kcIconColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 5.h,
                      child: SimpleShadow(
                        child: SvgPicture.asset(
                          'assets/discount.svg',
                          color: kcGreenColor,
                          width: 34.w,
                        ),
                        opacity: 0.1,
                        color: kcSecondaryDarkColor,
                        offset: Offset(2, 2),
                        sigma: 2,
                      ),
                    )
                  ],
                ),
            ],
          ),
        );
      },
      viewModelBuilder: () => ResViewModel(),
    );
  }
}
