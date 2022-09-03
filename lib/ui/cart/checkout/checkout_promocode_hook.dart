import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import 'checkout_view_model.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutPromocodeHook extends HookViewModelWidget<CheckoutViewModel> {
  CheckoutPromocodeHook({Key? key}) : super(key: key);

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget buildViewModelWidget(BuildContext context, CheckoutViewModel model) {
    final _promocodeController = useTextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/percent.svg',
              color: kcSecondaryDarkColor,
              width: 25.w,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  controller: _promocodeController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  style: kts18Text,
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
                    hintText: LocaleKeys.promocode.tr(),
                    hintStyle: ktsDefault18HelperText,
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 12.w),

                      /// If promocode is NOT NULL and promocode's quantity is NOT equal to -1 which means ERROR then proceed SUCCESS
                      child: _promocodeController.text.length > 2 &&
                              model.promocode != null &&
                              model.promocode!.quantity != -1
                          ? SvgPicture.asset(
                              'assets/check_outlined_circle.svg',
                              color: kcPrimaryColor,
                              width: 16.w,
                            )
                          : _promocodeController.text.length > 2 &&
                                  model.promocode != null &&
                                  model.promocode!.quantity == -1
                              ? SvgPicture.asset(
                                  'assets/warning_circle.svg',
                                  color: kcPrimaryColor,
                                  width: 25.w,
                                )
                              : SizedBox(),
                    ),
                  ),
                  onChanged: (value) => value.length > 2
                      ? _debouncer.run(() => model.searchPromocode(value))
                      : model.resetPromocode(),
                  onSubmitted: (value) => value.length > 2
                      ? _debouncer.run(() => model.searchPromocode(value))
                      : model.resetPromocode(),
                ),
              ),
            ),
          ],
        ),
        //------------------ PROMOCODE RESULT TEXT ---------------------//
        model.busy(_promocodeController.text)
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: SpinKitThreeBounce(
                  size: 16.w,
                  color: kcPrimaryColor,
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                  top: 8.h,
                  bottom: 8.h,
                  left: 45.w,
                  right: 20.w,
                ),
                child:
                    // _promocodeController.text.length > 2 &&
                    //         model.promocode != null &&
                    //         model.promocode!.quantity != -1
                    //     ? model.promocode!.promoType == 1
                    //         ? Text(
                    //             LocaleKeys.promocodeRemoveTMT,
                    //             style: kts14HelperText,
                    //           ).tr(args: [model.promocode!.discount.toString()])
                    //         : Text(
                    //             LocaleKeys.promocodeRemoveDiscount,
                    //             style: kts14HelperText,
                    //           ).tr(args: [model.promocode!.discount.toString()])
                    //     : _promocodeController.text.length > 2 &&
                    //             model.promocode != null &&
                    //             model.promocode!.quantity == -1
                    //         ? Text(
                    //             model.promocode!.text!,
                    //             style: kts14HelperText,
                    //           )
                    //         : SizedBox(),
                    _promocodeController.text.length > 2 &&
                            model.promocode != null
                        ? Text(
                            model.promocode!.text!,
                            style: kts14Text,
                          )
                        : SizedBox(),
              ),
      ],
    );
  }
}
