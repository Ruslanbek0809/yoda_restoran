import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/cart/checkout/checkout_view_model.dart';
import 'package:yoda_res/ui/widgets/custom_text_child_button.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutPaymentTypeBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const CheckoutPaymentTypeBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.35,
        maxChildSize: 0.35,
        expand: false,
        builder: (context, scrollController) => Container(
          height: 0.35.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.BORDER_RADIUS_20)),
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constants.BORDER_RADIUS_20),
                  ),
                  color: Colors.transparent,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(

                      /// To resize screen when OnKeyboard opened
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
// --------------- BOTTOM SHEET DRAGGER -------------- //
                      SizedBox(
                        height: 17.5.w,
                        width: 40.w,
                        child: SvgPicture.asset(
                          'assets/bottom_sheet_dragger.svg',
                          color: AppTheme.WHITE,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Constants.BORDER_RADIUS_20),
                          ),
                          color: AppTheme.WHITE,
                        ),
                        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 50.h),
                        child: Column(
                          children: [
                            Column(
                              children: paymentTypes
                                  .map(
                                    (paymentType) => Column(
                                      children: [
                                        Material(
                                          color: AppTheme.WHITE,
                                          child: InkWell(
                                            onTap: () {
                                              model
                                                  .updateTempSelectedPaymentType(
                                                      paymentType);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.w),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/checkCircle.svg',
                                                    color:
                                                        model.tempSelectedPaymentType
                                                                    .id ==
                                                                paymentType.id
                                                            ? AppTheme
                                                                .GREEN_COLOR
                                                            : Colors.white,
                                                    width: 25.w,
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Text(
                                                    paymentType.name,
                                                    style: ktsDefault18Text,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(color: AppTheme.DRAWER_DIVIDER)
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //--------------- FILTER BUTTONS -------------- //
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.WHITE,
                    border: Border.all(
                        color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
                  ),
                  padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 25.h),
                  child: CustomTextChildButton(
                    borderRadius: AppTheme().radius15,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Text('Saýla', style: ktsButton18Text),
                    onPressed: () {
                      model.updatePaymentType();
                      completer(SheetResponse());
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => CheckoutViewModel(),
    );
  }
}
