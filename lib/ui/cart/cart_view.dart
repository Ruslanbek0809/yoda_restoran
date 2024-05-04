import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/hive_models/hive_meal.dart';

import '../../generated/locale_keys.g.dart';
import '../../models/models.dart';
import '../../shared/shared.dart';
import '../../utils/utils.dart';
import '../widgets/widgets.dart';
import 'cart_meal_item.dart';
import 'cart_meals_shimmer.dart';
import 'cart_more_meal/cart_more_meal_view.dart';
import 'cart_more_meal/cart_more_meals_shimmer.dart';
import 'cart_toggle_button.dart';
import 'cart_view_model.dart';
import 'checkout/checkout_bottom_sheet_view.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* Here it is reactive instead of nonReactive is just bc delete cartMeal when its quantity is 0
    return ViewModelBuilder<CartViewModel>.reactive(
      onModelReady: (model) async => await model.getCartData(),
      builder: (context, model, child) {
        model.log.v(
            '=================== CartView ==================='); // Observe ViewModel for price changes

        if (model.showCartMealsDataUpdatedFlashbar) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            //* Reset the indicator to prevent repetitive triggers
            model.resetCartMealsDataUpdatedFlashbar();

            await showDateRangeErrorFlashBar(
              context: context,
              msg: Text(
                LocaleKeys.requiredCartMealsDataChanged,
                style: kts16ButtonText,
              ).tr(),
              margin: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 0.13.sh,
              ),
            );
          });
        }

        return WillPopScope(
          onWillPop: () async {
            model.navBack(); // Workaround
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kcWhiteColor,
              elevation: 0.5,
              leadingWidth: 35.w,
              leading: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: kcFontColor,
                    size: 25.w,
                  ),
                  onPressed: model.navBack,
                ),
              ),
              centerTitle: true,
              title: Text(
                LocaleKeys.order,
                style: kts22DarkText,
              ).tr(),
              actions: [
                IconButton(
                  onPressed: () async => await model.showClearCartDialog(model),
                  icon: SvgPicture.asset(
                    'assets/trash.svg',
                    color: kcSecondaryDarkColor,
                    width: 25.w,
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                ListView(
                  // ListView was used instead of SingleChildScrollView bc of its incompatibility with Stack Widget
                  // Also horizontal: 15.w padding is used for each inner widgets bc of horizontal CartFoodWidget list scroll
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    //*------------------ CART WIDGET ---------------------//
                    ValueListenableBuilder(
                      valueListenable:
                          Hive.box<HiveMeal>(Constants.cartMealsBox)
                              .listenable(),
                      builder: (context, Box<HiveMeal> cartMealsBox, _) {
                        final cartMeals = cartMealsBox.values.toList();
                        return model.busyForCartMealsKey
                            ? CartMealsShimmerWidget(
                                cartMealsLength:
                                    cartMeals.length > 5 ? 5 : cartMeals.length,
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                  top: 20.h,
                                  left: 16.w,
                                  right: 16.w,
                                ),
                                itemCount: cartMeals.length,
                                itemBuilder: (context, pos) {
                                  return CartMealItem(cartMeal: cartMeals[pos]);
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                    child: Divider(
                                      thickness: 1,
                                      color: kcDividerColor.withOpacity(0.5),
                                    ),
                                  );
                                },
                              );
                      },
                    ),

                    //*------------------ CART MEAL WIDGET TITLE ---------------------//
                    if (!model.hasErrorForCartMoreMealsKeys ||
                        model.moreMeals.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.h, bottom: 10.h, left: 16.w, right: 16.w),
                        child: Text(
                          LocaleKeys.oneMore,
                          style: ktsDefault24DarkText,
                        ).tr(),
                      ),
                    //*------------------ CART MORE MEAL LIST ---------------------//
                    if (!model.hasErrorForCartMoreMealsKeys)
                      AnimatedCrossFade(
                        duration: Duration(milliseconds: 500),
                        crossFadeState: model.busyForCartMoreMealsKey
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: CartMoreMealsShimmerWidget(),
                        secondChild: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: model.moreMeals.map((meal) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    right: model.moreMeals.indexOf(meal) ==
                                            model.moreMeals.length - 1
                                        ? 16.w
                                        : 4.w,
                                    left: model.moreMeals.indexOf(meal) == 0
                                        ? 16.w
                                        : 4.w), // For proper padding
                                child: CartMoreMealView(
                                  meal: meal,
                                  restaurant: Restaurant(
                                    id: model.cartRes!.id,
                                    name: model.cartRes!.name,
                                    image: model.cartRes!.image,
                                    rated: model.cartRes!.rated,
                                    rating: model.cartRes!.rating,
                                    description: model.cartRes!.description,
                                    deliveryPrice: model.cartRes!.deliveryPrice,
                                    address: model.cartRes!.address,
                                    phoneNumber: model.cartRes!.phoneNumber,
                                    prepareTime: model.cartRes!.prepareTime,
                                    notification: model.cartRes!.notification,
                                    workingHours: model.cartRes!.workingHours,
                                    city: model.cartRes!.city,
                                    distance: model.cartRes!.distance,
                                    selfPickUp: model.cartRes!.selfPickUp,
                                    delivery: model.cartRes!.delivery,
                                    discountMeals: model.cartRes!.discountMeals,
                                    discountAksiya:
                                        model.cartRes!.discountAksiya,
                                    discountCategory:
                                        model.cartRes!.discountCategory,
                                  ),
                                  cartViewModel: model,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    // AnimatedSwitcher(
                    //   duration: Duration(milliseconds: 300),
                    //   child: model.isBusy
                    //       ? CartMoreMealsShimmerWidget()
                    //       : SingleChildScrollView(
                    //           physics: BouncingScrollPhysics(),
                    //           scrollDirection: Axis.horizontal,
                    //           child: Row(
                    //             children: model.moreMeals.map((meal) {
                    //               return Padding(
                    //                 padding: EdgeInsets.only(
                    //                     right: model.moreMeals.indexOf(meal) ==
                    //                             model.moreMeals.length - 1
                    //                         ? 16.w
                    //                         : 4.w,
                    //                     left: model.moreMeals.indexOf(meal) == 0
                    //                         ? 16.w
                    //                         : 4.w), // For proper padding
                    //                 child: CartMoreMealView(
                    //                   meal: meal,
                    //                   restaurant: Restaurant(
                    //                     id: model.cartRes!.id,
                    //                     name: model.cartRes!.name,
                    //                     image: model.cartRes!.image,
                    //                     rated: model.cartRes!.rated,
                    //                     rating: model.cartRes!.rating,
                    //                     description: model.cartRes!.description,
                    //                     deliveryPrice:
                    //                         model.cartRes!.deliveryPrice,
                    //                     address: model.cartRes!.address,
                    //                     phoneNumber: model.cartRes!.phoneNumber,
                    //                     prepareTime: model.cartRes!.prepareTime,
                    //                     notification:
                    //                         model.cartRes!.notification,
                    //                     workingHours:
                    //                         model.cartRes!.workingHours,
                    //                     city: model.cartRes!.city,
                    //                     distance: model.cartRes!.distance,
                    //                     selfPickUp: model.cartRes!.selfPickUp,
                    //                     delivery: model.cartRes!.delivery,
                    // discountMeals: model.cartRes!.discountMeals,
                    // discountAksiya: model.cartRes!.discountAksiya,
                    // discountCategory: model.cartRes!.discountCategory,
                    //                   ),
                    //                   cartViewModel: model,
                    //                 ),
                    //               );
                    //             }).toList(),
                    //           ),
                    //         ),
                    // ),
                    //*------------------ TOGGLE BUTTON ---------------------//
                    CartToggleButton(),
                    SizedBox(
                        height: 0.13
                            .sh), // COMPENSATES height of Checkout Button Widget is taking
                  ],
                ),
                //*------------------ BOTTOM CART WIDGET ---------------------//
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kcWhiteColor,
                      border: Border(
                        top: BorderSide(
                          width: 0.5,
                          color: kcSecondaryDarkColor.withOpacity(0.25),
                        ),
                      ),
                    ),
                    padding:
                        EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 15.h + 0.02.sw),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Text(
                            '${formatNum(model.getTotalCartSum)} TMT',
                            style: ktsDefault22BoldText,
                          ),
                        ),
                        Expanded(
                          child: CustomTextChildButton(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            child: Text(
                              LocaleKeys.continuee,
                              // model.hasLoggedInUser
                              //     ? LocaleKeys.continuee
                              //     : LocaleKeys.register,
                              style: ktsButtonWhite18Text,
                            ).tr(),
                            onPressed: () async {
                              //* Below res workingHours are splitted
                              var resWorkingHoursSplitted =
                                  model.cartRes!.workingHours!.split('-');
                              var resStartWorkingHoursSplitted =
                                  resWorkingHoursSplitted[0].split(':');
                              var resEndWorkingHoursSplitted =
                                  resWorkingHoursSplitted[1].split(':');
                              var startHour =
                                  int.parse(resStartWorkingHoursSplitted[0]);
                              var startMinute =
                                  int.parse(resStartWorkingHoursSplitted[1]);
                              var endHour =
                                  int.parse(resEndWorkingHoursSplitted[0]);
                              var endMinute =
                                  int.parse(resEndWorkingHoursSplitted[1]);

                              var nowHourMin = (DateTime.now().hour * 60) +
                                  DateTime.now().minute;
                              var startTempHourMin =
                                  (startHour * 60) + startMinute;
                              var endTempHourMin = (endHour * 60) + endMinute;
                              if (model.cartRes?.disabled != null &&
                                  model.cartRes!.disabled!) {
                                await showDateRangeErrorFlashBar(
                                  context: context,
                                  msg: Text(
                                    LocaleKeys
                                        .requiredRestaurantTemporarilyDisabled,
                                    style: kts16ButtonText,
                                  ).tr(),
                                  margin: EdgeInsets.only(
                                    left: 16.w,
                                    right: 16.w,
                                    bottom: 0.13.sh,
                                  ),
                                );
                              } else if (nowHourMin < startTempHourMin ||
                                  nowHourMin > endTempHourMin) {
                                model.log.v(
                                    'TIME Inconvenience nowHourMin: $nowHourMin, startTempHourMin: $startTempHourMin, endTempHourMin: $endTempHourMin');
                                await showDateRangeErrorFlashBar(
                                  context: context,
                                  msg: Text(
                                          LocaleKeys.requiredWorkingHoursForRes,
                                          style: kts16ButtonText)
                                      .tr(
                                    args: [model.cartRes!.workingHours!],
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 16.w,
                                    right: 16.w,
                                    bottom: 0.13.sh,
                                  ),
                                );
                              } else {
                                model.log.v(
                                    'PASSED TIME nowHourMin: $nowHourMin, startTempHourMin: $startTempHourMin, endTempHourMin: $endTempHourMin');

                                if (model.hasLoggedInUser) {
                                  //* CUSTOM BOTTOM SHEET BASED ON CONTENT
                                  await showFlexibleBottomSheet(
                                    isExpand: false,
                                    initHeight: 0.95,
                                    maxHeight: 0.95,
                                    duration: Duration(milliseconds: 250),
                                    context: context,
                                    bottomSheetColor: Colors.transparent,
                                    builder:
                                        (context, scrollController, offset) =>
                                            CheckoutBottomSheetView(
                                      scrollController: scrollController,
                                      offset: offset,
                                    ),
                                  );
                                } else
                                  model.navToLoginView();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => CartViewModel(),
    );
  }
}
