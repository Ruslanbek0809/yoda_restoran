import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/restaurant/meal/meal_bottom_sheet_view.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';

import 'cart_res_food_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartResFoodView extends StatefulWidget {
  final MealUI food;
  const CartResFoodView({Key? key, required this.food}) : super(key: key);

  @override
  State<CartResFoodView> createState() => _CartResFoodViewState();
}

class _CartResFoodViewState extends State<CartResFoodView>
    with TickerProviderStateMixin {
  late AnimationController _tweenController;
  Tween<double> _tween = Tween(begin: 1, end: 0.98);

  late MealUI food;
  bool isButtonToggled = false;

  @override
  void initState() {
    super.initState();
    food = widget.food;
//// Container bounce back
    _tweenController = AnimationController(
        duration: const Duration(milliseconds: 50), vsync: this)
      ..addStatusListener((status) {
//// This listener was used to repeat animation once
        if (status == AnimationStatus.completed) {
          _tweenController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _tweenController.dispose();
    super.dispose();
  }

  void _onProductBottomSheetClicked(MealUI food) {
    showFoodBottomSheet(context, food);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartResFoodViewModel>.reactive(
      builder: (context, model, child) => ScaleTransition(
        scale: _tween.animate(CurvedAnimation(
            parent: _tweenController, curve: Curves.bounceInOut)),
        child: Container(
          width: 0.33.sw +
              10.w, // this width is used to make spaceBetween work in Row Button widgets
          decoration: BoxDecoration(
            color: AppTheme.MAIN_LIGHT,
            borderRadius: AppTheme().radius20,
          ),
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YodaImage(
                image: food.image,
                height: 0.33.sw,
                width: 0.33.sw,
                borderRadius: Constants.BORDER_RADIUS_20,
              ),
              Padding(
                padding: EdgeInsets.only(top: 7.w, bottom: 2.w),
                child: Text(
                  food.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.FONT_COLOR,
                  ),
                ),
              ),
              Text(
                '${food.weight} ${food.weightType}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTheme.DRAWER_ICON,
                ),
              ),
              SizedBox(height: 15.w),
//// Button Widget
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: isButtonToggled
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Material(
                            color: AppTheme.WHITE,
                            borderRadius: AppTheme().radius15,
                            elevation: 3,
                            shadowColor: AppTheme.MAIN_LIGHT.withOpacity(0.3),
                            child: InkWell(
                              borderRadius: AppTheme().radius15,
                              onTap: () async {
                                _tweenController.forward();
                                if (isButtonToggled)
                                  setState(() {
                                    isButtonToggled = !isButtonToggled;
                                  });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Icon(
                                  Icons.remove,
                                  size: 22.w,
                                  color: AppTheme.FONT_COLOR,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '1',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppTheme.FONT_COLOR,
                            ),
                          ),
                          Material(
                            color: AppTheme.WHITE,
                            borderRadius: AppTheme().radius15,
                            elevation: 3,
                            shadowColor: AppTheme.MAIN_LIGHT.withOpacity(0.3),
                            child: InkWell(
                              borderRadius: AppTheme().radius15,
                              onTap: () {
                                _tweenController.forward();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Icon(
                                  Icons.add,
                                  size: 22.w,
                                  color: AppTheme.FONT_COLOR,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Material(
                        color: Colors.transparent,
                        borderRadius: AppTheme().radius15,
                        elevation: 3,
                        shadowColor: AppTheme.MAIN_LIGHT.withOpacity(0.3),
                        child: InkWell(
                          borderRadius: AppTheme().radius15,
                          onTap: () async {
                            //// Bouncing animation trigger
                            _tweenController.forward();
                            //// Toggle switch animation between price and quantity
                            if (!isButtonToggled)
                              setState(() {
                                isButtonToggled = !isButtonToggled;
                              });
                          },
                          child: Ink(
                            width: 0.33.sw,
                            decoration: BoxDecoration(
                              color: AppTheme.WHITE,
                              borderRadius: AppTheme().radius15,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.w),
                            child: Text(
                              '${food.price} TMT',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppTheme.FONT_COLOR,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => CartResFoodViewModel(),
    );
  }
}
