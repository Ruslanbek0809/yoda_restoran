import 'package:flutter/material.dart';
import 'package:yoda_res/models/food_model.dart';
import 'package:yoda_res/screens/restaurant/food_bottom_sheet.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartWidget extends StatefulWidget {
  final FoodModel food;
  const CartWidget({Key? key, required this.food}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> with TickerProviderStateMixin {
  late FoodModel food;

  @override
  void initState() {
    super.initState();
    food = widget.food;
  }

  void _onProductBottomSheetClicked(FoodModel food) {
    showFoodBottomSheet(context, food);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YodaImage(
          image: food.image,
          height: 0.3.sw,
          width: 0.3.sw,
          borderRadius: Constants.BORDER_RADIUS_10,
        ),
        Expanded(
          child: Container(
            height: 0.3
                .sw, // this height is used to make Column apply MainAxisAlignment.spaceBetween
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      food.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppTheme.FONT_COLOR,
                      ),
                    ),
                    Text(
                      '${food.price} TMT',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppTheme.FONT_COLOR,
                      ),
                    ),
                  ],
                ),
                // Text(
                //   'Ajy sos',
                //   style: TextStyle(
                //     fontSize: 14.sp,
                //     color: AppTheme.DRAWER_ICON,
                //   ),
                // ),
//// Button Widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Material(
                      color: AppTheme.MAIN_LIGHT,
                      borderRadius: AppTheme().buttonBorderRadius,
                      elevation: 0,
                      child: InkWell(
                        borderRadius: AppTheme().buttonBorderRadius,
                        onTap: () async {},
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            Icons.remove,
                            size: 25.w,
                            color: AppTheme.FONT_COLOR,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '12',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppTheme.FONT_COLOR,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Material(
                      color: AppTheme.MAIN_LIGHT,
                      borderRadius: AppTheme().buttonBorderRadius,
                      elevation: 0,
                      child: InkWell(
                        borderRadius: AppTheme().buttonBorderRadius,
                        onTap: () {
                          _onProductBottomSheetClicked(food);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            Icons.add,
                            size: 25.w,
                            color: AppTheme.FONT_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
