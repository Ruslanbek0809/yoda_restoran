import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../models/hive_models/hive_models.dart';
import '../../shared/styles.dart';
import 'cart_view_model.dart';
import '../widgets/widgets.dart';
import '../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartMealItem extends ViewModelWidget<CartViewModel> {
  final HiveMeal cartMeal;
  const CartMealItem({Key? key, required this.cartMeal})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, CartViewModel model) {
    model.log.v('CartMealItem =========');

    num? totalMealSum = model.getTotalMealSum(cartMeal); // Gets totalMealSum
    String concatenateVolsCustoms = model
        .getConcatenateVolsCustoms(cartMeal); // Gets concatenatedVolsCustoms

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
            padding: EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0.h),
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
                      style: kts16Text,
                    )),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Text(
                        '${formatNum(totalMealSum)} TMT',
                        style: kts18SemiBoldText,
                      ),
                    ),
                  ],
                ),
                //------------------ ALL VOLS AND CUSTOMS CONCATENATED ---------------------//
                Text(
                  concatenateVolsCustoms,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kts14HelperText,
                ),
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
                        onTap: () async => cartMeal.quantity! == 1
                            ? await model.showRemoveCartMealDialog(
                                model, cartMeal)
                            : await model.updateCartMealInCart(
                                cartMeal, cartMeal.quantity! - 1),
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            Icons.remove_rounded,
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
                        style: kts20Text,
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
                            Icons.add_rounded,
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
