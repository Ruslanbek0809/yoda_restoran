import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/app_colors.dart';
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
      // onModelReady: (model) =>
      //     model.hasLoggedInUser ? model.checkResFav(restaurant.id!) : () {},
      builder: (context, model, child) {
        if (model.hasLoggedInUser) model.checkResFav(restaurant.id!);
        return Container(
          height: 0.3.sh,
          width: 1.sw,
          margin: EdgeInsets.fromLTRB(16.w, 3.h, 16.w, 10.h),
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
                    child: restaurant.discount != null &&
                            restaurant.discount! > 0
                        //------------------ WORKING HOURS with DISCOUNT ---------------------//
                        ? Row(
                            children: [
                              Container(
                                transform: Matrix4.translationValues(16.w, 0.0,
                                    0.0), // Stacks container into another container
                                padding:
                                    EdgeInsets.fromLTRB(14.w, 4.h, 24.w, 4.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.GREEN_COLOR.withOpacity(0.85),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Constants.BORDER_RADIUS_20),
                                    bottomRight: Radius.circular(
                                        Constants.BORDER_RADIUS_20),
                                  ),
                                ),
                                child: FittedBox(
                                  child: Text(
                                    '-${formatNum(restaurant.discount!)}%',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: kcWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.MAIN_DARK.withOpacity(0.85),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Constants.BORDER_RADIUS_20),
                                    bottomRight: Radius.circular(
                                        Constants.BORDER_RADIUS_20),
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
                            ],
                          )
                        //------------------ WORKING HOURS ---------------------//
                        : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.MAIN_DARK.withOpacity(0.85),
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(Constants.BORDER_RADIUS_20),
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
                        color: AppTheme.WHITE.withOpacity(0.8),
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
                              ? AppTheme.RED
                              : AppTheme.MAIN_DARK,
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
                    color: AppTheme.MAIN_DARK,
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
                        color: AppTheme.GREEN_COLOR,
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
            ],
          ),
        );
      },
      viewModelBuilder: () => ResViewModel(),
    );
  }
}
