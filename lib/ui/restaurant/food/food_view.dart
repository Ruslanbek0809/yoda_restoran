import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/restaurant/restaunant_bottom_sheets/food_bottom_sheet.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'food_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodView extends StatefulWidget {
  final Food food;
  final AnimationController animationController;
  const FoodView(
      {Key? key, required this.animationController, required this.food})
      : super(key: key);

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> with TickerProviderStateMixin {
  late AnimationController _tweenController;
  Tween<double> _tween = Tween(begin: 1, end: 0.98);

  late Food food;
  bool isButtonToggled = false;

  @override
  void initState() {
    super.initState();
    food = widget.food;
//// Container bounce back
    _tweenController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this)
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

  void _onProductBottomSheetClicked(Food food) {
    showFoodBottomSheet(context, food);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FoodViewModel>.reactive(
      builder: (context, model, child) => ScaleTransition(
        scale: _tween.animate(CurvedAnimation(
            parent: _tweenController, curve: Curves.bounceInOut)),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.MAIN_LIGHT,
            borderRadius: AppTheme().radius20,
          ),
          padding: EdgeInsets.fromLTRB(7.w, 7.w, 7.w, 7.w),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//------------------ IMAGE with DISCOUNT(if needed) ---------------------//
                  Stack(
                    children: [
                      YodaImage(
                        image: food.image,
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                        borderRadius: Constants.BORDER_RADIUS_20,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: AppTheme.GREEN_COLOR,
                            borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(Constants.BORDER_RADIUS_20),
                              bottomRight:
                                  Radius.circular(Constants.BORDER_RADIUS_20),
                            ),
                          ),
                          child: FittedBox(
                            child: Text(
                              '-20%',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.w, bottom: 4.w),
                    child: Text(
                      food.name,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: AppTheme.FONT_COLOR,
                      ),
                    ),
                  ),
                  isButtonToggled
                      ? Row(
                          children: [
                            Text(
                              '${food.price} TMT / ',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: AppTheme.DRAWER_ICON,
                              ),
                            ),
                            Text(
                              '${food.weight} ${food.weightType}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: AppTheme.DRAWER_ICON,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          '${food.weight} ${food.weightType}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppTheme.DRAWER_ICON,
                          ),
                        ),
                  Spacer(),
//------------------ BUTTONS ---------------------//
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: isButtonToggled
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                color: AppTheme.WHITE,
                                borderRadius: AppTheme().radius15,
                                elevation: 3,
                                shadowColor:
                                    AppTheme.MAIN_LIGHT.withOpacity(0.3),
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
                                borderRadius: AppTheme().radius15,
                                elevation: 3,
                                shadowColor:
                                    AppTheme.MAIN_LIGHT.withOpacity(0.3),
                                child: InkWell(
                                  borderRadius: AppTheme().radius15,
                                  onTap: () =>
                                      _onProductBottomSheetClicked(food),
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
                                  borderRadius: AppTheme().radius15,
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
      ),
      viewModelBuilder: () => FoodViewModel(),
    );
  }
}
