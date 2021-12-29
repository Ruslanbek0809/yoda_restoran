import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import 'package:yoda_res/shared/styles.dart';
import 'package:yoda_res/ui/cart/cart_view_model.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartMealItem extends ViewModelWidget<CartViewModel> {
  final HiveMeal cartMeal;
  const CartMealItem({Key? key, required this.cartMeal}) : super(key: key);

  @override
  Widget build(BuildContext context, CartViewModel model) {
    model.log.v('CartMealItem =========');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YodaImage(
          image: cartMeal.image!,
          height: 0.3.sw,
          width: 0.3.sw,
          borderRadius: Constants.BORDER_RADIUS_10,
        ),
        Expanded(
          child: Container(
            height: 0.3.sw, // MAKES Column apply MainAxisAlignment.spaceBetween
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      cartMeal.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ktsDefault16Text,
                    )),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 5.w),
                    //   child: Text(
                    //     '${model.totalMealSum} TMT',
                    //     style: ktsDefault18Text,
                    //   ),
                    // ),
                  ],
                ),
                //------------------ ALL VOLS AND CUSTOMS CONCATENATED ---------------------//
                // Text(
                //   model.concatenateVolsCustoms,
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: ktsDefault14HelperText,
                // ),
                //------------------ BUTTONS ---------------------//
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Material(
                      color: AppTheme.MAIN_LIGHT,
                      borderRadius: AppTheme().radius15,
                      elevation: 0,
                      child: InkWell(
                        borderRadius: AppTheme().radius15,
                        onTap: () async => await model.updateCartMealInCart(
                            cartMeal, cartMeal.quantity! - 1),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        cartMeal.quantity.toString(),
                        style: ktsDefault20Text,
                      ),
                    ),
                    Material(
                      color: AppTheme.MAIN_LIGHT,
                      borderRadius: AppTheme().radius15,
                      elevation: 0,
                      child: InkWell(
                        borderRadius: AppTheme().radius15,
                        onTap: () async => await model.updateCartMealInCart(
                            cartMeal, cartMeal.quantity! + 1),
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
