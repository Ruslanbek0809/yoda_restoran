import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/utils/utils.dart';
import 'cart_meal/cart_meal_item.dart';
import 'cart_promocode_hook.dart';
import 'cart_res_food/cart_res_food_view.dart';
import 'cart_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);
  // final TextEditingController _promocodeController = TextEditingController();

  // // bool _switchValue = true;
  // bool _isDelivery = false;
  // void _onCartOrderClicked() {
  //   cartOrderBottomSheet(context);
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
      onModelReady: (model) => model.getMoreMeals(),
      builder: (context, model, child) {
        model.log.v('CartView ===================');
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: AppTheme.WHITE,
            elevation: 0,
            leadingWidth: 35.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  'assets/cancel.svg',
                  color: AppTheme.MAIN_DARK,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: GestureDetector(
                  onTap: () async => await model.showClearCartDialog(model),
                  child: SvgPicture.asset(
                    'assets/trash.svg',
                    color: AppTheme.MAIN_DARK,
                    width: 25.w,
                  ),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Sargyt',
                      style: TextStyle(
                        color: AppTheme.MAIN_DARK,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
//------------------ CARTWIDGET ---------------------//
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.only(top: 15.h, left: 16.w, right: 16.w),
                    itemCount: model.cartMeals.length,
                    itemBuilder: (context, pos) {
                      return CartMealItem(cartMeal: model.cartMeals[pos]);
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Divider(
                          thickness: 1,
                          color: AppTheme.DRAWER_DIVIDER.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
//------------------ ACCESSORIES ---------------------//
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                  //   child: Row(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () => Navigator.pop(context),
                  //         child: SvgPicture.asset(
                  //           'assets/forkKnife.svg',
                  //           color: AppTheme.MAIN_DARK,
                  //           width: 25.w,
                  //         ),
                  //       ),
                  //       SizedBox(width: 15.w),
                  //       Text(
                  //         'Esbaplar',
                  //         style: TextStyle(
                  //           fontSize: 18.sp,
                  //           color: AppTheme.FONT_COLOR,
                  //         ),
                  //       ),
                  //       Spacer(),
                  //       CupertinoSwitch(
                  //         activeColor: AppTheme.MAIN,
                  //         trackColor: AppTheme.TOGGLE_COLOR,
                  //         value: _switchValue,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _switchValue = value;
                  //           });
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
//------------------ CART FOOD WIDGET TITLE ---------------------//
                  Padding(
                    padding: EdgeInsets.only(
                        top: 15.h, bottom: 10.w, left: 16.w, right: 16.w),
                    child: Text(
                      'Ýene bir zat?',
                      style: TextStyle(
                        color: AppTheme.MAIN_DARK,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
//------------------ CART FOOD WIDGET LIST ---------------------//
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: mealList.map((food) {
                        return mealList.indexOf(food) == 0
                            ? Padding(
                                padding:
                                    EdgeInsets.only(right: 6.w, left: 16.w),
                                child: CartResFoodView(food: food),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: CartResFoodView(food: food),
                              );
                      }).toList(),
                    ),
                  ),
//------------------ DELIVERY TOGGLE TITLE ---------------------//
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       top: 20.w, bottom: 10.w, left: 16.w, right: 16.w),
                  //   child: Text(
                  //     'Almak usuly',
                  //     style: TextStyle(
                  //       color: AppTheme.MAIN_DARK,
                  //       fontSize: 24.sp,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
//------------------ DELIVERY TOGGLE ---------------------//
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //   child: ToggleButtonWidget(
                  //     toggleCallback: (isDelivery) {
                  //       setState(() {
                  //         _isDelivery = isDelivery;
                  //       });
                  //     },
                  //   ),
                  // ),
//------------------ DELIVERY TYPE TEXT based on condition ---------------------//
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.w),
                  //   child: AnimatedSwitcher(
                  //     duration: const Duration(milliseconds: 300),
                  //     child: _isDelivery
                  //         ? Row(
                  //             children: [
                  //               GestureDetector(
                  //                 onTap: () => Navigator.pop(context),
                  //                 child: SvgPicture.asset(
                  //                   'assets/delivery.svg',
                  //                   color: AppTheme.MAIN_DARK,
                  //                   width: 35.w,
                  //                 ),
                  //               ),
                  //               SizedBox(width: 8.w),
                  //               Expanded(
                  //                 child: Text(
                  //                   'Eltip bermek üçin töleg operator tarapyndan goşular.',
                  //                   style: TextStyle(
                  //                     fontSize: 16.sp,
                  //                     color: AppTheme.FONT_COLOR,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           )
                  //         : Row(
                  //             children: [
                  //               GestureDetector(
                  //                 onTap: () => Navigator.pop(context),
                  //                 child: SvgPicture.asset(
                  //                   'assets/map_pin.svg',
                  //                   color: AppTheme.MAIN_DARK,
                  //                   width: 25.w,
                  //                 ),
                  //               ),
                  //               SizedBox(width: 5.w),
                  //               Expanded(
                  //                 child: Text(
                  //                   'Alişer Nowaýy köç. 171',
                  //                   style: TextStyle(
                  //                     fontSize: 16.sp,
                  //                     color: AppTheme.FONT_COLOR,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //   ),
                  // ),
                  //------------------ PROMOCODE ---------------------//
                  CartPromocodeHook(),
                  SizedBox(
                      height: 0.27
                          .sw), // COMPENSATES height of Checkout Button Widget is taking
                ],
              ),
//------------------ BOTTOM CART WIDGET ---------------------//
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: AppTheme.WHITE,
              //       border: Border.all(
              //           color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
              //       boxShadow: [AppTheme().bottomCartShadow],
              //     ),
              //     padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 25.w),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           '175 TMT',
              //           style: TextStyle(
              //             fontSize: 20.sp,
              //             fontWeight: FontWeight.w600,
              //             color: AppTheme.MAIN_DARK,
              //           ),
              //         ),
              //         CustomTextButton(
              //           text: 'Dowam et',
              //           padding: EdgeInsets.symmetric(
              //               vertical: 17.w, horizontal: 0.2.sw),
              //           textStyle: TextStyle(
              //             fontSize: 18.sp,
              //             fontWeight: FontWeight.normal,
              //             color: AppTheme.WHITE,
              //           ),
              //           onPressed: () => _onCartOrderClicked(),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
      viewModelBuilder: () => CartViewModel(),
    );
  }
}
