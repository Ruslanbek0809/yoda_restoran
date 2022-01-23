import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/app_colors.dart';
import '../../models/models.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';
import 'restaurant_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantView extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantView({required this.restaurant, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResViewModel>.reactive(
      onModelReady: (model) =>
          model.hasLoggedInUser ? model.checkResFav(restaurant.id!) : () {},
      builder: (context, model, child) {
        return Container(
          height: 0.3.sh,
          width: 1.sw,
          margin: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 8.h),
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
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: kcWhiteColor,
                            size: 18.w,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            restaurant.workingHours!,
                            style: TextStyle(
                              fontSize: 14.sp,
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
                        onPressed: () => model.hasLoggedInUser
                            ? model.updateResFav(restaurant.id!)
                            : () {},
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
                padding: EdgeInsets.only(top: 6.h),
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
      viewModelBuilder: () => ResViewModel(),
    );
  }
}
