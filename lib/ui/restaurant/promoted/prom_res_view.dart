import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../../models/models.dart';
import 'prom_res_view_model.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromResView extends StatelessWidget {
  final Restaurant restaurant;
  final List<Restaurant> promRess;
  const PromResView(
      {required this.restaurant, required this.promRess, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PromResViewModel>.reactive(
      builder: (context, model, child) => Container(
        height: 0.24.sh,
        width: 0.7.sw,
        margin: EdgeInsets.fromLTRB(
          promRess.indexOf(restaurant) == 0 ? 16.w : 8.w,
          4.h,
          promRess.indexOf(restaurant) == promRess.length - 1 ? 16.w : 0.w,
          10.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
//------------------ IMAGE with ripple effect ---------------------//
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => model.navToResDetailsView(restaurant),
                      child: YodaImage(
                        image: restaurant.image!,
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
                          color: AppTheme.WHITE,
                          size: 14.w,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          restaurant.workingHours!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.WHITE,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //------------------ FAVOURITE ---------------------//
                Positioned(
                  top: 8.w,
                  right: 8.w,
                  child: Container(
                    width: 0.09.sw,
                    height: 0.09.sw,
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
                        size: 20.w,
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
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.MAIN_DARK,
                ),
              ),
            ),
            //------------------ RATE ---------------------//
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (model.locationPosition != null)
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/map_pin_bold.svg',
                        color: kcDialogColor,
                        width: 14.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${restaurant.city} (${restaurant.distance} km)',
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
                      size: 18.w,
                      color: AppTheme.GREEN_COLOR,
                    ),
                    Text(
                      '${restaurant.rating} (${restaurant.rated})',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.MAIN_DARK,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      viewModelBuilder: () => PromResViewModel(),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';

// import 'promoted_view_model.dart';

// class PromotedView extends StatelessWidget {
//   const PromotedView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<PromotedViewModel>.reactive(
//       builder: (context, model, child) => Scaffold(),
//       viewModelBuilder: () => PromotedViewModel(),
//     );
//   }
// }
