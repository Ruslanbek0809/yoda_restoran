import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/restaurant/restaurant_details/restaurant_details_view.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'restaurant_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantView extends StatefulWidget {
  final RestaurantUI restaurant;
  const RestaurantView({required this.restaurant, Key? key}) : super(key: key);

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantViewModel>.reactive(
      builder: (context, model, child) => Container(
        height: 0.62.sw,
        width: 1.sw,
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
//------------------ IMAGE with ripple effect ---------------------//
                Stack(
                  children: [
                    YodaImage(
                      image: widget.restaurant.image,
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
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantDetailsView(),
                              ),
                            );
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
                    width: 0.3.sw,
                    height: 33.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.w,
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
                      '40-50 min.',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.WHITE,
                      ),
                    ),
                  ),
                ),
                //// Favourite Widget
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
                      onPressed: () {
                        setState(() {
                          isFavorited = !isFavorited;
                        });
                      },
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited
                            ? AppTheme.RED
                            : IconTheme.of(context).color,
                        size: 25.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.w),
              child: Text(
                widget.restaurant.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.MAIN_DARK,
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, size: 20.w, color: AppTheme.GREEN_COLOR),
                SizedBox(width: 3.w),
                Text(
                  '4.9 (123)',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.MAIN_DARK,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  widget.restaurant.foods,
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
      ),
      viewModelBuilder: () => RestaurantViewModel(),
    );
  }
}
