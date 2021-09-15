import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';

import 'restaurant.dart';

class RestaurantWidget extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantWidget({required this.restaurant, Key? key})
      : super(key: key);

  @override
  _RestaurantWidgetState createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  bool isFavorited = false;
  late final Restaurant restaurant;

  @override
  void initState() {
    super.initState();
    restaurant = widget.restaurant;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.62.sw,
      width: 1.sw,
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
//// IMAGE with ripple effect
              Stack(
                children: [
                  YodaImage(
                    image: restaurant.image,
                    height: 0.45.sw,
                    width: 1.sw,
                    borderRadius: Constants.BORDER_RADIUS_MAIN,
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: AppTheme().mainBorderRadius,
                      child: InkWell(
                        borderRadius: AppTheme().mainBorderRadius,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
//// Delivery time Widget
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
                      topLeft: Radius.circular(Constants.BORDER_RADIUS_MAIN),
                      bottomRight:
                          Radius.circular(Constants.BORDER_RADIUS_MAIN),
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
              restaurant.name,
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
              Icon(Icons.star, size: 20.w, color: AppTheme.GREEN),
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
                restaurant.foods,
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
  }
}
