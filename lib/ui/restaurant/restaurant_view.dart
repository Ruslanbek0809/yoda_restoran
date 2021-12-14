import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'restaurant_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantView extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantView({required this.restaurant, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantViewModel>.reactive(
      builder: (context, model, child) {
        return Container(
          height: 0.3.sh,
          width: 1.sw,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
//------------------ IMAGE with ripple effect ---------------------//
                  Stack(
                    children: [
                      YodaImage(
                        image: restaurant.image!,
                        height: 0.45.sw,
                        width: 1.sw,
                        borderRadius: Constants.BORDER_RADIUS_20,
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: AppTheme().radius20,
                          child: InkWell(
                            borderRadius: AppTheme().radius20,
                            onTap: () {
                              model.navToResDetailsView(restaurant);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  //------------------ DELIVERY TIME ---------------------//
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      // width: 0.3.sw,
                      height: 33.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.MAIN_DARK.withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Constants.BORDER_RADIUS_20),
                          bottomRight:
                              Radius.circular(Constants.BORDER_RADIUS_20),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        restaurant.prepareTime!,
                        // restaurant.prepareTime!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.WHITE,
                        ),
                      ),
                      //  Row(
                      //   children: [
                      //     Icon(
                      //       Icons.access_time_rounded,
                      //       color: AppTheme.WHITE,
                      //       size: 22.w,
                      //     ),
                      //     SizedBox(width: 3.w),
                      //     Text(
                      //       restaurant.workingHours!,
                      //       style: TextStyle(
                      //         fontSize: 16.sp,
                      //         // fontWeight: FontWeight.w600,
                      //         color: AppTheme.WHITE,
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
                        onPressed: model.updateResFavorite,
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
                padding: EdgeInsets.only(top: 5.w),
                child: Text(
                  restaurant.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.MAIN_DARK,
                  ),
                ),
              ),
              //------------------ RATE ---------------------//
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 20.w,
                    color: AppTheme.GREEN_COLOR,
                  ),
                  Text(
                    '${restaurant.rating} (${restaurant.rated})',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.MAIN_DARK,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => RestaurantViewModel(),
    );
  }
}
