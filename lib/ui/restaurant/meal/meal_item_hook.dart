import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'meal_bottom_sheet_view.dart';
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

    //*To dispose a status listener attached to _tweenController
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
          FocusScope.of(context).unfocus();
          await _tweenController.forward();
          await HapticFeedback.lightImpact();

          //*----------------- MEAL BOTTOM SHEET ---------------------//
          //*----------------- CUSTOM PACKAGE ---------------------//
          await showFlexibleBottomSheet(
            isExpand: false,
            // minHeight: 0,
            initHeight: 0.95,
            maxHeight: 0.95,
            duration: Duration(milliseconds: 250),
            context: context,
            bottomSheetColor: Colors.transparent,
            builder: (context, scrollController, offset) {
              return CustomModalBottomSheet(
                child: MealBottomSheetView(
                  scrollController: scrollController,
                  offset: offset,
                  meal: meal,
                  restaurant: restaurant,
                  mealViewModel: model,
                ),
              );
            },
          );
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
                  //*----------------- IMAGE with DISCOUNT(if needed) ---------------------//
                  Stack(
                    children: [
                      YodaImage(
                        image: meal.imageCard ?? 'assets/ph_product.png',
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
                              color: kcGreenColor,
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(Constants.BORDER_RADIUS_20),
                                bottomRight:
                                    Radius.circular(Constants.BORDER_RADIUS_20),
                              ),
                            ),
                            child: FittedBox(
                              child: Text(
                                '-${formatNum(meal.discount ?? 0)}%',
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
                      meal.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: kts14Text,
                    ),
                  ),
                  //*----------------- MEAL PRICE ---------------------//
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
                                    ? '${formatNum(meal.discountedPrice ?? 0)} TMT'
                                    : '${formatNum(meal.price ?? 0)} TMT',
                                style: kts14HelperText,
                              ),
                              if (meal.value != null)
                                Text(
                                  ' • ${formatNum(meal.value ?? 0)} ${meal.size?.name ?? ''}',
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
                                        '${formatNum(meal.price ?? 0)} TMT',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: kcHelperColor,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Text(
                                        ' • ${formatNum(meal.value ?? 0)} ${meal.size?.name ?? ''}',
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
                                    '${formatNum(meal.value ?? 0)} ${meal.size?.name ?? 0}',
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
                                    '${formatNum(meal.price ?? 0)} TMT',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: kcHelperColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                  Spacer(),
                  //*----------------- BUTTONS ---------------------//
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: model.mealQuantity > 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                color: kcWhiteColor,
                                borderRadius: AppTheme().radius15,
                                elevation: 3,
                                shadowColor:
                                    kcSecondaryLightColor.withOpacity(0.3),
                                child: InkWell(
                                  borderRadius: AppTheme().radius15,
                                  onTap: () async {
                                    await model
                                        .subtractOrRemoveMealInCart(meal.id);
                                    await _tweenController.forward();
                                    await HapticFeedback.lightImpact();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      size: 22.w,
                                      color: kcFontColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                model.mealQuantity.toString(),
                                style: kts18Text,
                              ),
                              Material(
                                color: kcWhiteColor,
                                borderRadius: AppTheme().radius15,
                                elevation: 3,
                                shadowColor:
                                    kcSecondaryLightColor.withOpacity(0.3),
                                child: InkWell(
                                  borderRadius: AppTheme().radius15,
                                  onTap: (meal.gVolumes ?? []).isNotEmpty ||
                                          (meal.gCustomizables ?? []).isNotEmpty
                                      ? () async {
                                          FocusScope.of(context).unfocus();
                                          await _tweenController.forward();
                                          await HapticFeedback.lightImpact();

                                          //*----------------- MEAL BOTTOM SHEET ---------------------//
                                          //*----------------- CUSTOM PACKAGE ---------------------//
                                          await showFlexibleBottomSheet(
                                            isExpand: false,
                                            // minHeight: 0,
                                            initHeight: 0.95,
                                            maxHeight: 0.95,
                                            duration:
                                                Duration(milliseconds: 250),
                                            context: context,
                                            bottomSheetColor:
                                                Colors.transparent,
                                            builder: (context, scrollController,
                                                offset) {
                                              return CustomModalBottomSheet(
                                                child: MealBottomSheetView(
                                                  scrollController:
                                                      scrollController,
                                                  offset: offset,
                                                  meal: meal,
                                                  restaurant: restaurant,
                                                  mealViewModel: model,
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      : () async {
                                          await model
                                              .addUpdateMealInCartFromBottomSheet(
                                                  meal, restaurant);
                                          await _tweenController.forward();
                                          await HapticFeedback.lightImpact();
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      size: 22.w,
                                      color: kcFontColor,
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
                            shadowColor: kcSecondaryLightColor.withOpacity(0.3),
                            child: InkWell(
                              borderRadius: AppTheme().radius15,
                              onTap: (meal.gVolumes ?? []).isNotEmpty ||
                                      (meal.gCustomizables ?? []).isNotEmpty
                                  ? () async {
                                      FocusScope.of(context).unfocus();
                                      await _tweenController.forward();
                                      await HapticFeedback.lightImpact();

                                      //*----------------- MEAL BOTTOM SHEET ---------------------//
                                      //*----------------- CUSTOM PACKAGE ---------------------//
                                      await showFlexibleBottomSheet(
                                        isExpand: false,
                                        // minHeight: 0,
                                        initHeight: 0.95,
                                        maxHeight: 0.95,
                                        duration: Duration(milliseconds: 250),
                                        context: context,
                                        bottomSheetColor: Colors.transparent,
                                        builder: (context, scrollController,
                                            offset) {
                                          return CustomModalBottomSheet(
                                            child: MealBottomSheetView(
                                              scrollController:
                                                  scrollController,
                                              offset: offset,
                                              meal: meal,
                                              restaurant: restaurant,
                                              mealViewModel: model,
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  : () async {
                                      await model
                                          .addUpdateMealInCartFromBottomSheet(
                                              meal, restaurant);
                                      await _tweenController.forward();
                                    },
                              child: Ink(
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(
                                  color: kcWhiteColor,
                                  borderRadius: AppTheme().radius15,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Text(
                                  meal.discount != null && meal.discount! > 0
                                      ? '${formatNum(meal.discountedPrice ?? 0)} TMT'
                                      : '${formatNum(meal.price ?? 0)} TMT',
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
