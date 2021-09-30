import 'package:flutter/material.dart';
import 'package:yoda_res/models/food_model.dart';
import 'package:yoda_res/screens/restaurant/food_bottom_sheet.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:yoda_res/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'restaurant_details_screen.dart';

class FoodWidget extends StatefulWidget {
  final FoodModel food;
  final AnimationController animationController;
  const FoodWidget(
      {Key? key, required this.animationController, required this.food})
      : super(key: key);

  @override
  _FoodWidgetState createState() => _FoodWidgetState();
}

class _FoodWidgetState extends State<FoodWidget> with TickerProviderStateMixin {
  GlobalKey<RestaurantDetailsScreenState> restaurantDetailsKey =
      GlobalKey<RestaurantDetailsScreenState>();
  late AnimationController _tweenController;
  Tween<double> _tween = Tween(begin: 1, end: 0.98);

  late FoodModel food;
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

  void _onProductBottomSheetClicked(FoodModel food) {
    showFoodBottomSheet(context, food);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _tween.animate(
          CurvedAnimation(parent: _tweenController, curve: Curves.bounceInOut)),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.MAIN_LIGHT,
          borderRadius: AppTheme().mainBorderRadius,
        ),
        padding: EdgeInsets.all(5.w),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YodaImage(
                  image: food.image,
                  height: constraints.maxWidth,
                  width: constraints.maxWidth,
                  borderRadius: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.w, bottom: 4.w),
                  child: Text(
                    food.name,
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: AppTheme.FONT_COLOR,
                    ),
                  ),
                ),
                Text(
                  '${food.weight} ${food.weightType}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppTheme.DRAWER_ICON,
                  ),
                ),
                Spacer(),
//// Button Widget
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: isButtonToggled
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: AppTheme.WHITE,
                              borderRadius: AppTheme().buttonBorderRadius,
                              elevation: 1,
                              child: InkWell(
                                borderRadius: AppTheme().buttonBorderRadius,
                                onTap: () async {
                                  _tweenController.forward();
                                  if (isButtonToggled)
                                    setState(() {
                                      isButtonToggled = !isButtonToggled;
                                    });
                                },
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
                        )
                      : Material(
                          color: Colors.transparent,
                          borderRadius: AppTheme().buttonBorderRadius,
                          elevation: 1,
                          child: InkWell(
                            borderRadius: AppTheme().buttonBorderRadius,
                            onTap: () async {
                              //// Bouncing animation trigger
                              _tweenController.forward();
                              //// Toggle switch animation between price and quantity
                              if (!isButtonToggled)
                                setState(() {
                                  isButtonToggled = !isButtonToggled;
                                });
                              //// bottomCartAnimationController trigger
                              switch (widget.animationController.status) {
                                case AnimationStatus.completed:
                                  widget.animationController.reverse();
                                  break;
                                case AnimationStatus.dismissed:
                                  widget.animationController.forward();
                                  break;
                                default:
                              }
                            },
                            child: Ink(
                              width: constraints.maxWidth,
                              decoration: BoxDecoration(
                                color: AppTheme.WHITE,
                                borderRadius: AppTheme().buttonBorderRadius,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.w),
                              child: Text(
                                '${food.price} TMT',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: AppTheme.FONT_COLOR,
                                ),
                              ),
                            ),
                          ),
                        ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
