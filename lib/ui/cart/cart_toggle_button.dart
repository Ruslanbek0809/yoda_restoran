import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/models.dart';
import '../../shared/shared.dart';
import 'cart_view_model.dart';
import '../toggle_buttons/toggle_buttons_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class CartToggleButton extends ViewModelWidget<CartViewModel> {
  const CartToggleButton({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, CartViewModel model) {
    model.log.v('CartToggleButton =========');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//*------------------ DELIVERY TOGGLE TITLE ---------------------//
        Padding(
          padding:
              EdgeInsets.only(top: 20.h, bottom: 10.w, left: 16.w, right: 16.w),
          child: Text(
            LocaleKeys.howToTake,
            style: ktsDefault24DarkText,
          ).tr(),
        ),
//*------------------ DELIVERY TOGGLE ---------------------//
        ToggleButtonView(
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
            workingHours: model.cartRes!.workingHours,
            city: model.cartRes!.city,
            distance: model.cartRes!.distance,
            selfPickUp: model.cartRes!.selfPickUp,
            delivery: model.cartRes!.delivery,
          ),
        ),
//*------------------ DELIVERY TYPE TEXT based on condition ---------------------//
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.w),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: model.isDelivery
                ? Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          'assets/delivery.svg',
                          color: Colors.transparent,
                          width: 10.w,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          LocaleKeys.deliveryPriceWillAddByOperator,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: kcFontColor,
                          ),
                        ).tr(),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          'assets/map_pin_bold.svg',
                          color: kcSecondaryDarkColor,
                          width: 22.w,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          model.cartRes?.address ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: kcFontColor,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
