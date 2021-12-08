import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'cart_bottom_sheets/cart_order_bottom_sheet.dart';
import 'cart_food/cart_food_view.dart';
import 'cart_res_food/cart_res_food_view.dart';
import 'cart_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final TextEditingController _promocodeController = TextEditingController();

  // bool _switchValue = true;
  bool _isDelivery = false;
  void _onCartOrderClicked() {
    cartOrderBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
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
                onTap: () => Navigator.pop(context),
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
                  padding: EdgeInsets.only(top: 15.w, left: 16.w, right: 16.w),
                  itemCount: foodList.length,
                  itemBuilder: (context, pos) {
                    return CartFoodView(food: foodList[pos]);
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.w),
                      child: Divider(
                        thickness: 1,
                        color: AppTheme.DRAWER_DIVIDER,
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 7.w, horizontal: 16.w),
                  child: Divider(
                    thickness: 1,
                    color: AppTheme.DRAWER_DIVIDER,
                  ),
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
                      top: 15.w, bottom: 10.w, left: 16.w, right: 16.w),
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
                    children: foodList.mapIndexed((food, pos) {
                      return pos == 0
                          ? Padding(
                              padding: EdgeInsets.only(right: 6.w, left: 16.w),
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
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.w, bottom: 10.w, left: 16.w, right: 16.w),
                  child: Text(
                    'Almak usuly',
                    style: TextStyle(
                      color: AppTheme.MAIN_DARK,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
//------------------ DELIVERY TOGGLE ---------------------//
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ToggleButtonWidget(
                    toggleCallback: (isDelivery) {
                      setState(() {
                        _isDelivery = isDelivery;
                      });
                    },
                  ),
                ),
//------------------ DELIVERY TYPE TEXT based on condition ---------------------//
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.w),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isDelivery
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: SvgPicture.asset(
                                  'assets/delivery.svg',
                                  color: AppTheme.MAIN_DARK,
                                  width: 35.w,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Eltip bermek üçin töleg operator tarapyndan goşular.',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppTheme.FONT_COLOR,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: SvgPicture.asset(
                                  'assets/map_pin.svg',
                                  color: AppTheme.MAIN_DARK,
                                  width: 25.w,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Text(
                                  'Alişer Nowaýy köç. 171',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppTheme.FONT_COLOR,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                //------------------ PROMOCODE ---------------------//
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.w, bottom: 10.w, left: 16.w, right: 16.w),
                  child: Text(
                    'Promo kod',
                    style: TextStyle(
                      color: AppTheme.MAIN_DARK,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: _promocodeController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppTheme.FONT_COLOR,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppTheme().radius15,
                        borderSide: BorderSide(
                          color: AppTheme.FILL_BORDER_SECOND_COLOR,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppTheme().radius15,
                        borderSide: BorderSide(
                          color: AppTheme.FILL_BORDER_SECOND_COLOR,
                          width: 1,
                        ),
                      ),
                      hintText: 'Promo kody giriziň',
                      hintStyle: TextStyle(
                        fontSize: 18.sp,
                        color: AppTheme.FONT_GREY_COLOR,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 7.w),
                        child: GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset(
                            'assets/warning_circle.svg',
                            color: AppTheme.CONTACT_COLOR,
                            width: 25.w,
                          ),
                        ),
                        // SvgPicture.asset(
                        //   'assets/check_outlined_circle.svg',
                        //   color: AppTheme.MAIN,
                        //   width: 25.w,
                        // ),
                      ),
                    ),
                  ),
                ),
                //------------------ PROMOCODE ---------------------//
                Padding(
                  padding: EdgeInsets.only(
                      top: 8.w, bottom: 10.w, left: 29.w, right: 16.w),
                  child: Text(
                    'Siziň sargydyňyzdan 150 manat aýrylar.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.DIALOG_TITLE_COLOR,
                    ),
                  ),
                ),
                SizedBox(
                    height: 0.27
                        .sw), // this one is needed to compensate height of Checkout Button Widget is taking
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
                      color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
                  boxShadow: [AppTheme().bottomCartShadow],
                ),
                padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '175 TMT',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.MAIN_DARK,
                      ),
                    ),
                    CustomTextButton(
                      text: 'Dowam et',
                      padding: EdgeInsets.symmetric(
                          vertical: 17.w, horizontal: 0.2.sw),
                      textStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.WHITE,
                      ),
                      onPressed: () => _onCartOrderClicked(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => CartViewModel(),
    );
  }
}
