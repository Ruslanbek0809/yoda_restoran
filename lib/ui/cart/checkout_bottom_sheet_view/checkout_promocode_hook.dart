import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/cart/checkout_bottom_sheet_view/checkout_view_model.dart';
import 'package:yoda_res/utils/utils.dart';

class CheckoutPromocodeHook extends HookViewModelWidget<CheckoutViewModel> {
  const CheckoutPromocodeHook({Key? key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, CheckoutViewModel model) {
    final _promocodeController = useTextEditingController();
    // model.log.v('CheckoutPromocodeHook =========');
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/percent.svg',
              color: AppTheme.MAIN_DARK,
              width: 25.w,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  controller: _promocodeController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  style: ktsDefault16Text,
                  decoration: InputDecoration(
                    isDense: true, // MAKES it more denser
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
                    hintStyle: ktsDefault16HelperText,
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/warning_circle.svg',
                          color: AppTheme.CONTACT_COLOR,
                          width: 16.w,
                        ),
                      ),
                      // SvgPicture.asset(
                      //   'assets/check_outlined_circle.svg',
                      //   color: AppTheme.MAIN,
                      //   width: 25.w,
                      // ),
                    ),
                  ),
                  onChanged: model.searchPromocode,
                  onSubmitted: model.searchPromocode,
                ),
              ),
            ),
          ],
        ),
        //------------------ PROMOCODE RESULT TEXT ---------------------//
        // if (model.promocode != null)
        Padding(
          padding:
              EdgeInsets.only(top: 8.h, bottom: 10.w, left: 29.w, right: 16.w),
          child: Text(
            model.promocode != null
                ? 'Siziň sargydyňyzdan 150 manat aýrylar.'
                : '', // Need to get its space here
            style: ktsDefault14HelperText,
          ),
        ),
      ],
    );
  }
}
