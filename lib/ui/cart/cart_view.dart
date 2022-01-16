import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import '../../shared/shared.dart';
import 'cart_toggle_button.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';
import 'cart_meal/cart_meal_item.dart';
import 'cart_res_food/cart_res_food_view.dart';
import 'cart_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Here it is reactive instead of nonReactive is just bc delete cartMeal when its quantity is 0
    return ViewModelBuilder<CartViewModel>.reactive(
      // onModelReady: (model) => model.getMoreMeals(),
      builder: (context, model, child) {
        model.log.v('CartView ===================');
        return WillPopScope(
          onWillPop: () async {
            model.navBack(); // Workaround
            return false;
          },
          child: Scaffold(
            appBar: MyAppbar(
              child: AppBar(
                backgroundColor: AppTheme.WHITE,
                elevation: 1,
                leadingWidth: 35.w,
                leading: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppTheme.FONT_COLOR,
                      size: 25.w,
                    ),
                    onPressed: model.navBack,
                  ),
                ),
                centerTitle: true,
                title: Text(
                  'Sargyt',
                  style: ktsDefault22DarkText,
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
            ),
            body: Stack(
              children: [
                ListView(
                  // ListView was used instead of SingleChildScrollView bc of its incompatibility with Stack Widget
                  // Also horizontal: 15.w padding is used for each inner widgets bc of horizontal CartFoodWidget list scroll
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    //------------------ CARTWIDGET ---------------------//
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
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
                    // //------------------ CART FOOD WIDGET TITLE ---------------------//
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       top: 20.h, bottom: 10.w, left: 16.w, right: 16.w),
                    //   child: Text(
                    //     'Ýene bir zat?',
                    //     style: ktsDefault24DarkText,
                    //   ),
                    // ),
                    // //------------------ CART FOOD WIDGET LIST ---------------------//
                    // SingleChildScrollView(
                    //   physics: BouncingScrollPhysics(),
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: mealList.map((food) {
                    //       return mealList.indexOf(food) == 0
                    //           ? Padding(
                    //               padding:
                    //                   EdgeInsets.only(right: 6.w, left: 16.w),
                    //               child: CartResFoodView(food: food),
                    //             )
                    //           : Padding(
                    //               padding:
                    //                   EdgeInsets.symmetric(horizontal: 5.w),
                    //               child: CartResFoodView(food: food),
                    //             );
                    //     }).toList(),
                    //   ),
                    // ),
                    //------------------ TOGGLE BUTTON ---------------------//
                    CartToggleButton(),
                    SizedBox(
                        height: 0.13
                            .sh), // COMPENSATES height of Checkout Button Widget is taking
                  ],
                ),
                //------------------ BOTTOM CART WIDGET ---------------------//
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.WHITE,
                      border: Border.all(
                        color: AppTheme.BUTTON_BORDER_COLOR,
                        width: 0.1,
                      ),
                      boxShadow: [AppTheme().bottomCartShadow],
                    ),
                    padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 25.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Text(
                            '${model.getTotalCartSum.toInt()} TMT',
                            style: ktsDefault22BoldText,
                          ),
                        ),
                        Expanded(
                          child: CustomTextChildButton(
                            padding: EdgeInsets.symmetric(vertical: 17.w),
                            child: Text(
                              model.hasLoggedInUser ? 'Dowam et' : 'Ulgama gir',
                              style: ktsButton18Text,
                            ),
                            onPressed: model.onCartCheckoutButtonPressed,
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
