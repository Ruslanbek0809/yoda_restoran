import 'dart:io';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../models/models.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'meal_bottom_sheet_view.dart';
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
        onTap: () async {
          await _tweenController.forward();

          //------------------ MEAL BOTTOM SHEET ---------------------//
          //------------------ CUSTOM PACKAGE ---------------------//
          await showFlexibleBottomSheet(
            minHeight: 0,
            initHeight: (meal.gVolumes!.isEmpty &&
                        meal.gCustomizables!.isEmpty) &&
                    meal.description!.isEmpty
                ? Platform.isIOS
                    ? 0.635
                    : 0.63
                : (meal.gVolumes!.isEmpty && meal.gCustomizables!.isEmpty) &&
                        meal.description!.isNotEmpty
                    ? Platform.isIOS
                        ? 0.74
                        : 0.75
                    : 0.975,
            maxHeight:
                (meal.gVolumes!.isEmpty && meal.gCustomizables!.isEmpty) &&
                        meal.description!.isEmpty
                    ? Platform.isIOS
                        ? 0.635
                        : 0.63
                    : 0.975,
            duration: Duration(milliseconds: 250),
            context: context,
            builder: (context, scrollController, offset) {
              return CustomBarBottomSheet(
                isMealBottomSheet: true,
                child: MealBottomSheet(
                  scrollController: scrollController,
                  offset: offset,
                  meal: meal,
                  restaurant: restaurant,
                  mealViewModel: model,
                ),
              );
            },
            anchors: (meal.gVolumes!.isEmpty && meal.gCustomizables!.isEmpty) &&
                    meal.description!.isEmpty
                ? [0, Platform.isIOS ? 0.635 : 0.63]
                : (meal.gVolumes!.isEmpty && meal.gCustomizables!.isEmpty) &&
                        meal.description!.isNotEmpty
                    ? [0, Platform.isIOS ? 0.74 : 0.75, 0.975]
                    : [0, 0.975],
          );
          // await model.showCustomMealBottomSheet(meal, restaurant, model);
        },
        child: Container(
          decoration: BoxDecoration(
            color: kcSecondaryLightColor,
            borderRadius: AppTheme().radius20,
          ),
          padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 6.h),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------ IMAGE with DISCOUNT(if needed) ---------------------//
                  Stack(
                    children: [
                      YodaImage(
                        image: meal.imageCard!,
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
                                horizontal: 12.0, vertical: 3.h),
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
                                '-${formatNum(meal.discount!)}%',
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
                    padding: EdgeInsets.only(
                      top: 5.h,
                      bottom: 2.h,
                      left: 2.w,
                      right: 2.w,
                    ),
                    child: Text(
                      meal.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: kts14Text,
                    ),
                  ),
                  //------------------ MEAL PRICE ---------------------//
                  model.mealQuantity > 0
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: 2.w,
                            right: 2.w,
                          ),
                          child: Row(
                            children: [
                              Text(
                                meal.discount != null || meal.discount! > 0
                                    ? '${formatNum(meal.discountedPrice!)} TMT'
                                    : '${formatNum(meal.price!)} TMT',
                                style: kts14HelperText,
                              ),
                              if (meal.value != null)
                                Text(
                                  ' • ${formatNum(meal.value!)} ${meal.size!.name}',
                                  style: kts14HelperText,
                                ),
                            ],
                          ),
                        )
                      : meal.value != null
                          ? meal.discount != null && meal.discount! > 0
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    left: 2.w,
                                    right: 2.w,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${formatNum(meal.price!)} TMT',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: kcHelperColor,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        ' • ${formatNum(meal.value!)} ${meal.size!.name}',
                                        style: kts14HelperText,
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    left: 2.w,
                                    right: 2.w,
                                  ),
                                  child: Text(
                                    '${formatNum(meal.value!)} ${meal.size!.name}',
                                    style: kts14HelperText,
                                  ),
                                )
                          : meal.discount != null && meal.discount! > 0
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    left: 2.w,
                                    right: 2.w,
                                  ),
                                  child: Text(
                                    '${formatNum(meal.price!)} TMT',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: kcHelperColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                  Spacer(),
                  //------------------ BUTTONS ---------------------//
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: model.mealQuantity > 0
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
                                // model.quantity.toString(),
                                model.mealQuantity.toString(),
                                style: kts18Text,
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

                                          //------------------ MEAL BOTTOM SHEET ---------------------//
                                          //------------------ CUSTOM PACKAGE ---------------------//
                                          await showFlexibleBottomSheet(
                                            minHeight: 0,
                                            initHeight: (meal.gVolumes!
                                                            .isEmpty &&
                                                        meal.gCustomizables!
                                                            .isEmpty) &&
                                                    meal.description!.isEmpty
                                                ? Platform.isIOS
                                                    ? 0.635
                                                    : 0.63
                                                : (meal.gVolumes!.isEmpty &&
                                                            meal.gCustomizables!
                                                                .isEmpty) &&
                                                        meal.description!
                                                            .isNotEmpty
                                                    ? Platform.isIOS
                                                        ? 0.74
                                                        : 0.75
                                                    : 0.975,
                                            maxHeight: (meal.gVolumes!
                                                            .isEmpty &&
                                                        meal.gCustomizables!
                                                            .isEmpty) &&
                                                    meal.description!.isEmpty
                                                ? Platform.isIOS
                                                    ? 0.635
                                                    : 0.63
                                                : 0.975,
                                            duration:
                                                Duration(milliseconds: 250),
                                            context: context,
                                            builder: (context, scrollController,
                                                offset) {
                                              return CustomBarBottomSheet(
                                                isMealBottomSheet: true,
                                                child: MealBottomSheet(
                                                  scrollController:
                                                      scrollController,
                                                  offset: offset,
                                                  meal: meal,
                                                  restaurant: restaurant,
                                                  mealViewModel: model,
                                                ),
                                              );
                                            },
                                            anchors: (meal.gVolumes!.isEmpty &&
                                                        meal.gCustomizables!
                                                            .isEmpty) &&
                                                    meal.description!.isEmpty
                                                ? [
                                                    0,
                                                    Platform.isIOS
                                                        ? 0.635
                                                        : 0.63
                                                  ]
                                                : (meal.gVolumes!.isEmpty &&
                                                            meal.gCustomizables!
                                                                .isEmpty) &&
                                                        meal.description!
                                                            .isNotEmpty
                                                    ? [
                                                        0,
                                                        Platform.isIOS
                                                            ? 0.74
                                                            : 0.75,
                                                        0.975
                                                      ]
                                                    : [0, 0.975],
                                          );
                                          // await model.showCustomMealBottomSheet(meal, restaurant, model);
                                        }
                                      : () async {
                                          await model
                                              .addUpdateMealInCartFromBottomSheet(
                                                  meal, restaurant);
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

                                      //------------------ MEAL BOTTOM SHEET ---------------------//
                                      //------------------ CUSTOM PACKAGE ---------------------//
                                      await showFlexibleBottomSheet(
                                        minHeight: 0,
                                        initHeight: (meal.gVolumes!.isEmpty &&
                                                    meal.gCustomizables!
                                                        .isEmpty) &&
                                                meal.description!.isEmpty
                                            ? Platform.isIOS
                                                ? 0.635
                                                : 0.63
                                            : (meal.gVolumes!.isEmpty &&
                                                        meal.gCustomizables!
                                                            .isEmpty) &&
                                                    meal.description!.isNotEmpty
                                                ? Platform.isIOS
                                                    ? 0.74
                                                    : 0.75
                                                : 0.975,
                                        maxHeight: (meal.gVolumes!.isEmpty &&
                                                    meal.gCustomizables!
                                                        .isEmpty) &&
                                                meal.description!.isEmpty
                                            ? Platform.isIOS
                                                ? 0.635
                                                : 0.63
                                            : 0.975,
                                        duration: Duration(milliseconds: 250),
                                        context: context,
                                        builder: (context, scrollController,
                                            offset) {
                                          return CustomBarBottomSheet(
                                            isMealBottomSheet: true,
                                            child: MealBottomSheet(
                                              scrollController:
                                                  scrollController,
                                              offset: offset,
                                              meal: meal,
                                              restaurant: restaurant,
                                              mealViewModel: model,
                                            ),
                                          );
                                        },
                                        anchors: (meal.gVolumes!.isEmpty &&
                                                    meal.gCustomizables!
                                                        .isEmpty) &&
                                                meal.description!.isEmpty
                                            ? [0, Platform.isIOS ? 0.635 : 0.63]
                                            : (meal.gVolumes!.isEmpty &&
                                                        meal.gCustomizables!
                                                            .isEmpty) &&
                                                    meal.description!.isNotEmpty
                                                ? [
                                                    0,
                                                    Platform.isIOS
                                                        ? 0.74
                                                        : 0.75,
                                                    0.975
                                                  ]
                                                : [0, 0.975],
                                      );
                                      // await model.showCustomMealBottomSheet(meal, restaurant, model);
                                    }
                                  : () async {
                                      await model
                                          .addUpdateMealInCartFromBottomSheet(
                                              meal, restaurant);
                                      // await model.addMealToCart(
                                      //   meal,
                                      //   restaurant,
                                      // );
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
                                      ? '${formatNum(meal.discountedPrice!)} TMT'
                                      : '${formatNum(meal.price!)} TMT',
                                  textAlign: TextAlign.center,
                                  style: kts18Text,
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
