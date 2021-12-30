import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/cart/cart_view_model.dart';
import 'package:yoda_res/ui/toggle_buttons/toggle_buttons_view.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartToggleButton extends ViewModelWidget<CartViewModel> {
  const CartToggleButton({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, CartViewModel model) {
    model.log.v('CartToggleButton =========');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//------------------ DELIVERY TOGGLE TITLE ---------------------//
        Padding(
          padding:
              EdgeInsets.only(top: 20.h, bottom: 10.w, left: 16.w, right: 16.w),
          child: Text(
            'Almak usuly',
            style: ktsDefault24DarkText,
          ),
        ),
//------------------ DELIVERY TOGGLE ---------------------//
        ToggleButtonView(),
//------------------ DELIVERY TYPE TEXT based on condition ---------------------//
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
      ],
    );
  }
}
