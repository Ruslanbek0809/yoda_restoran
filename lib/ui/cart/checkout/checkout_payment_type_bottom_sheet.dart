import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
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
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
          color: kcWhiteColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Constants.BORDER_RADIUS_20),
          ),
        ),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          children: [
            // --------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
            CustomModalInsideBottomSheet(),
// --------------- PAYMENT TYPES -------------- //
            if (paymentTypes.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 10.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: model.cartRes!.resPaymentTypes!.length,
                  itemBuilder: (context, pos) {
                    var paymentType = model.cartRes!.resPaymentTypes![pos];
                    return Material(
                      color: kcWhiteColor,
                      child: InkWell(
                        onTap: () =>
                            model.updateTempSelectedPaymentType(paymentType),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Row(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: model.tempSelectedPaymentType!.id ==
                                        paymentType.id
                                    ? SvgPicture.asset(
                                        'assets/checkCircle.svg',
                                        color: kcGreenColor,
                                        width: 25.w,
                                      )
                                    : SvgPicture.asset(
                                        'assets/checkCircle.svg',
                                        color: kcWhiteColor,
                                        width: 25.w,
                                      ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                context.locale == context.supportedLocales[0]
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
                    return Divider(
                      color: kcDividerColor,
                      indent: 35.w,
                    );
                  },
                ),
              ),
            //--------------- PAYMENT BUTTON -------------- //
            Container(
              decoration: BoxDecoration(
                color: kcWhiteColor,
                border: Border(
                  top: BorderSide(
                    width: 0.1,
                    color: AppTheme.BUTTON_BORDER_COLOR,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 22.h),
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
            )
          ],
        ),
      ),
      viewModelBuilder: () => CheckoutViewModel(),
    );
  }
}
