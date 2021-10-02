import 'package:flutter/material.dart';
import 'package:yoda_res/models/food_model.dart';
import 'package:yoda_res/screens/restaurant/food_bottom_sheet.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartFoodWidget extends StatefulWidget {
  final FoodModel food;
  const CartFoodWidget({Key? key, required this.food}) : super(key: key);

  @override
  _CartFoodWidgetState createState() => _CartFoodWidgetState();
}

class _CartFoodWidgetState extends State<CartFoodWidget>
    with TickerProviderStateMixin {
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
          height: 0.35.sw,
          width: 0.35.sw,
          borderRadius: Constants.BORDER_RADIUS_10,
        ),
        Expanded(
          child: Column(
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

//// Button Widget
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Material(
                    color: AppTheme.WHITE,
                    borderRadius: AppTheme().buttonBorderRadius,
                    elevation: 1,
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
                  Text(
                    '1',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppTheme.FONT_COLOR,
                    ),
                  ),
                  Material(
                    color: AppTheme.WHITE,
                    borderRadius: AppTheme().buttonBorderRadius,
                    elevation: 1,
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
      ],
    );
  }
}
