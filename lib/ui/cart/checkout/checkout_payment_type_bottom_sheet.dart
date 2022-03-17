import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import 'checkout_view_model.dart';
import '../../widgets/custom_text_child_button.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutPaymentTypeBottomSheetView extends StatelessWidget {
  final ScrollController scrollController;
  final double offset;
  const CheckoutPaymentTypeBottomSheetView({
    Key? key,
    required this.scrollController,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      builder: (context, model, child) => Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(

                /// To resize screen when OnKeyboard opened
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
// --------------- PAYMENT TYPES -------------- //
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Constants.BORDER_RADIUS_20),
                    ),
                    color: AppTheme.WHITE,
                  ),
                  padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 10.h),
                  child: Column(
                    children: [
                      if (paymentTypes.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.cartRes!.resPaymentTypes!.length,
                          itemBuilder: (context, pos) {
                            var paymentType =
                                model.cartRes!.resPaymentTypes![pos];
                            return Material(
                              color: AppTheme.WHITE,
                              child: InkWell(
                                onTap: () => model
                                    .updateTempSelectedPaymentType(paymentType),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Row(
                                    children: [
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child:
                                            model.tempSelectedPaymentType!.id ==
                                                    paymentType.id
                                                ? SvgPicture.asset(
                                                    'assets/checkCircle.svg',
                                                    color: AppTheme.GREEN_COLOR,
                                                    width: 25.w,
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/checkCircle.svg',
                                                    color: Colors.white,
                                                    width: 25.w,
                                                  ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        context.locale ==
                                                context.supportedLocales[0]
                                            ? paymentType.nameTk!
                                            : paymentType.nameRu!,
                                        style: kts18Text,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(color: kcDividerColor);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //--------------- PAYMENT BUTTON -------------- //
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.WHITE,
                // border: Border.all(
                //     color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
              ),
              padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 25.h),
              child: CustomTextChildButton(
                borderRadius: AppTheme().radius15,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Text(LocaleKeys.select, style: ktsButton18Text).tr(),
                onPressed: () {
                  model.savePaymentType();
                  Navigator.pop(context);
                  // completer(SheetResponse());
                },
              ),
            ),
          )
        ],
      ),
      viewModelBuilder: () => CheckoutViewModel(),
    );
  }
}
