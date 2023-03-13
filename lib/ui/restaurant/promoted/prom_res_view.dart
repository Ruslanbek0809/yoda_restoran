import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../../models/models.dart';
import 'prom_res_favorite_button.dart';
import 'prom_res_view_model.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class PromResView extends StatelessWidget {
  final Restaurant restaurant;
  final List<Restaurant> promRess;
  const PromResView(
      {required this.restaurant, required this.promRess, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PromResViewModel>.reactive(
      builder: (context, model, child) {
        return Container(
          height: 0.245.sh,
          width: 0.7.sw,
          margin: EdgeInsets.fromLTRB(
            promRess.indexOf(restaurant) == 0 ? 16.r : 8.r,
            6.r,
            promRess.indexOf(restaurant) == promRess.length - 1 ? 16.r : 0.r,
            24.r,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
//*----------------- IMAGE with ripple effect ---------------------//
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => model.navToResDetailsView(restaurant),
                        child: YodaImage(
                          image: restaurant.image ?? 'assets/ph_restaurant.png',
                          phImage: 'assets/ph_restaurant.png',
                          height: 0.18.sh,
                          width: 0.7.sw,
                          borderRadius: Constants.BORDER_RADIUS_20,
                        ),
                      ),
                      // Positioned.fill(
                      //   child: Material(
                      //     color: Colors.transparent,
                      //     borderRadius: AppTheme().radius20,
                      //     child: InkWell(
                      //       borderRadius: AppTheme().radius20,
                      //       onTap: () {
                      //         // model.navToResDetailsView(restaurant);
                      //       },
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  //*----------------- DELIVERY TIME ---------------------//
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child:
                        //*----------------- WORKING HOURS ---------------------//
                        Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.r,
                        vertical: 4.r,
                      ),
                      decoration: BoxDecoration(
                        color: kcSecondaryDarkColor.withOpacity(0.9),
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
                              right: 4.r,
                              top: 2.r,
                            ),
                            child: Icon(
                              Icons.access_time_rounded,
                              color: kcWhiteColor,
                              size: 12.sp,
                            ),
                          ),
                          Text(
                            restaurant.workingHours ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: kcWhiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //*----------------- FAVOURITE ---------------------//
                  PromResFavoriteButton(restaurant: restaurant),
                ],
              ),
              //*----------------- NAME ---------------------//
              Padding(
                padding: EdgeInsets.only(top: 2.r),
                child: Text(
                  restaurant.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: kcSecondaryDarkColor,
                  ),
                ),
              ),
              //*----------------- LOCATION and RATE ---------------------//
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/map_pin_bold.svg',
                        color: kcDialogColor,
                        width: 14.sp,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        restaurant.city ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: kcIconColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 18.sp,
                        color: kcPrimaryColor,
                      ),
                      Text(
                        '${formatNumRating(restaurant.rating ?? 0)} (${restaurant.rated})',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: kcSecondaryDarkColor,
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
      viewModelBuilder: () => PromResViewModel(),
    );
  }
}
