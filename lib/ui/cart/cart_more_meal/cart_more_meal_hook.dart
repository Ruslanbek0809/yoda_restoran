import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../shared/app_colors.dart';
import '../../../shared/styles.dart';
import '../../../models/models.dart';
import '../../widgets/widgets.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cart_more_meal_bottom_sheet_view.dart';
import 'cart_more_meal_view_model.dart';

class CartMoreMealHook extends StackedHookView<CartMoreMealViewModel> {
  final Meal meal;
  final Restaurant
      restaurant; // Needed for add meal with conditions only in CART
  const CartMoreMealHook({
    Key? key,
    required this.meal,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget builder(BuildContext context, CartMoreMealViewModel model) {
    double itemWidth = 0.35.sw + 10.w;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth * 1.75; // 0.32.sw is for item height

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
          await _tweenController.forward();
          //*----------------- CART MORE MEAL BOTTOM SHEET ---------------------//
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
                child: CartMoreMealBottomSheetView(
                  scrollController: scrollController,
                  offset: offset,
                  meal: meal,
                  restaurant: restaurant,
                  cartMoreMealViewModel: model,
                ),
              );
            },
          );
        },
        child: Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            color: kcSecondaryLightColor,
            borderRadius: AppTheme().radius20,
          ),
          padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                fontSize: 14.sp,
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
                    top: 4.h,
                    bottom: 2.h,
                    left: 2.w,
                    right: 2.w,
                  ),
                  child: Text(
                    meal.name ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kts12Text,
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
                              style: kts12HelperText,
                            ),
                            if (meal.value != null)
                              Text(
                                ' • ${formatNum(meal.value ?? 0)} ${meal.size?.name ?? ''}',
                                style: kts12HelperText,
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
                                        fontSize: 12.sp,
                                        color: kcHelperColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      ' • ${formatNum(meal.value ?? 0)} ${meal.size?.name ?? ''}',
                                      style: kts12HelperText,
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
                                  '${formatNum(meal.value ?? 0)} ${meal.size?.name ?? ''}',
                                  style: kts12HelperText,
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
                                    fontSize: 12.sp,
                                    color: kcHelperColor,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              )
                            : SizedBox(),
                Spacer(), //*----------------- BUTTONS ---------------------//
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
                                    size: 18.w,
                                    color: kcFontColor,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              model.mealQuantity.toString(),
                              style: kts16Text,
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
                                        await _tweenController.forward();

                                        //*----------------- CART MORE MEAL BOTTOM SHEET ---------------------//
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
                                              child:
                                                  CartMoreMealBottomSheetView(
                                                scrollController:
                                                    scrollController,
                                                offset: offset,
                                                meal: meal,
                                                restaurant: restaurant,
                                                cartMoreMealViewModel: model,
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
                                    size: 18.w,
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
                                    await _tweenController.forward();

                                    //*----------------- CART MORE MEAL BOTTOM SHEET ---------------------//
                                    //*----------------- CUSTOM PACKAGE ---------------------//
                                    await showFlexibleBottomSheet(
                                      isExpand: false,
                                      // minHeight: 0,
                                      initHeight: 0.95,
                                      maxHeight: 0.95,
                                      context: context,
                                      bottomSheetColor: Colors.transparent,
                                      duration: Duration(milliseconds: 250),
                                      builder:
                                          (context, scrollController, offset) {
                                        return CustomModalBottomSheet(
                                          child: CartMoreMealBottomSheetView(
                                            scrollController: scrollController,
                                            offset: offset,
                                            meal: meal,
                                            restaurant: restaurant,
                                            cartMoreMealViewModel: model,
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
                            child: Ink(
                              width: constraints.maxWidth,
                              decoration: BoxDecoration(
                                color: kcWhiteColor,
                                borderRadius: AppTheme().radius15,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Text(
                                meal.discount != null && meal.discount! > 0
                                    ? '${formatNum(meal.discountedPrice ?? 0)} TMT'
                                    : '${formatNum(meal.price ?? 0)} TMT',
                                textAlign: TextAlign.center,
                                style: kts16Text,
                              ),
                            ),
                          ),
                        ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
