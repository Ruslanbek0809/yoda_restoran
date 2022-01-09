import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'meal_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealItemHook extends HookViewModelWidget<MealViewModel> {
  final Meal meal;
  final Restaurant restaurant;
  const MealItemHook({
    Key? key,
    required this.meal,
    required this.restaurant,
  }) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, MealViewModel model) {
    Tween<double> _tween = Tween(begin: 1, end: 0.98);
    final _tweenController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    /// To dispose a status listener attached to _tweenController
    useEffect(() {
      void _listenerStatus(AnimationStatus status) {
        // This listener was used to repeat animation once
        if (status == AnimationStatus.completed) {
          _tweenController.reverse();
        }
      }

      _tweenController..addStatusListener(_listenerStatus);
      return () => _tweenController.removeStatusListener(_listenerStatus);
    }, [_tweenController]);

    return ScaleTransition(
      scale: _tween.animate(
        CurvedAnimation(
          parent: _tweenController,
          curve: Curves.bounceInOut,
        ),
      ),
      child: GestureDetector(
        onTap: () async =>
            await model.showCustomMealBottomSheet(meal, restaurant, model),
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
                        image: meal.image!,
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                        borderRadius: Constants.BORDER_RADIUS_20,
                      ),
                      if (meal.discount != null && meal.discount! > 0)
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
                                '-${meal.discount!.toInt()}%',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: kcWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7.h, bottom: 3.h),
                    child: Text(
                      meal.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ktsDefault16Text,
                    ),
                  ),
                  model.isButtonToggled
                      ? Row(
                          children: [
                            Text(
                              meal.discount != null || meal.discount! > 0
                                  ? '${meal.discountedPrice!.toInt()} TMT'
                                  : '${meal.price!.toInt()} TMT',
                              style: kts14HelperText,
                            ),
                            Text(
                              ' * ${meal.value!.toInt()} ${meal.size!.name}',
                              style: kts14HelperText,
                            ),
                          ],
                        )
                      : meal.discount != null && meal.discount! > 0
                          ? Row(
                              children: [
                                Text(
                                  '${meal.price!.toInt()} TMT',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: kcHelperColor,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  ' * ${meal.value!.toInt()} ${meal.size!.name}',
                                  style: kts14HelperText,
                                ),
                              ],
                            )
                          : Text(
                              '${meal.value!.toInt()} ${meal.size!.name}',
                              style: kts14HelperText,
                            ),
                  Spacer(),
                  //------------------ BUTTONS ---------------------//
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: model.isButtonToggled
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
                                    await model
                                        .subtractOrRemoveMealInCart(meal.id);
                                    await _tweenController.forward();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 22.w,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                model.quantity.toString(),
                                style: ktsDefault18Text,
                              ),
                              Material(
                                color: AppTheme.WHITE,
                                borderRadius: AppTheme().radius15,
                                elevation: 3,
                                shadowColor:
                                    AppTheme.MAIN_LIGHT.withOpacity(0.3),
                                child: InkWell(
                                  borderRadius: AppTheme().radius15,
                                  onTap: meal.gVolumes!.isNotEmpty ||
                                          meal.gCustomizables!.isNotEmpty
                                      ? () async {
                                          await _tweenController.forward();
                                          await model.showCustomMealBottomSheet(
                                              meal, restaurant, model);
                                        }
                                      : () async {
                                          await model.updateMealInCart(
                                            mealId: meal.id,
                                            mealQuantity: model.quantity + 1,
                                          );
                                          await _tweenController.forward();
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),
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
                              onTap: meal.gVolumes!.isNotEmpty ||
                                      meal.gCustomizables!.isNotEmpty
                                  ? () async {
                                      await _tweenController.forward();
                                      await model.showCustomMealBottomSheet(
                                          meal, restaurant, model);
                                    }
                                  : () async {
                                      await model.addMealToCart(
                                        meal,
                                        restaurant,
                                      );
                                      await _tweenController.forward();
                                    },
                              child: Ink(
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(
                                  color: AppTheme.WHITE,
                                  borderRadius: AppTheme().radius15,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Text(
                                  meal.discount != null && meal.discount! > 0
                                      ? '${meal.discountedPrice!.toInt()} TMT'
                                      : '${meal.price!.toInt()} TMT',
                                  textAlign: TextAlign.center,
                                  style: ktsDefault18Text,
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
    );
  }
}
