import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/shared.dart';
import '../../../widgets/widgets.dart';
import '../../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'so_credit_cards_view_model.dart';
import 'so_send_code_bottom_sheet_hook.dart';

class SOSendCodeConfirmationBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse<bool>) completer;
  SOSendCodeConfirmationBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  final GlobalKey<FormState> _sendCodeformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SOCreditCardsViewModel>.reactive(
      viewModelBuilder: () => SOCreditCardsViewModel(),
      builder: (context, model, child) => DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constants.BORDER_RADIUS_20)),
                color: kcWhiteColor,
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // --------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
                        CustomModalInsideBottomSheet(isBottomZero: true),

                        //       //------------------ CVC CODE INFO ---------------------//
                        //       Padding(
                        //         padding: EdgeInsets.only(left: 16.w, top: 4.h),
                        //         child: Text(
                        //           LocaleKeys.cvc_kod_not_saved,
                        //           style: kts12ContactText,
                        //         ).tr(),
                        //       ),
                        // --------------- SEND CODE TEXTFIELD -------------- //
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Constants.BORDER_RADIUS_20),
                            ),
                            color: kcWhiteColor,
                          ),  
                          padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 10.h),
                          child: Form(
                            key: _sendCodeformKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: SOSendCodeBottomSheetHook(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //--------------- SEND CODE CONFIRM BUTTON -------------- //
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kcWhiteColor,
                        border: Border(
                          top: BorderSide(
                            width: 0.1,
                            color: kcButtonBorderColor,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 25.h),
                      child: CustomTextChildButton(
                        color: kcOnlinePaymentColor,
                        borderRadius: AppTheme().radius15,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: model.isLoading
                              ? ButtonLoading()
                              : Text(
                                  LocaleKeys.confirm,
                                  style: ktsButton18Text,
                                ).tr(),
                        ),
                        onPressed: () async {
                          FocusScope.of(context)
                              .unfocus(); // UNFOCUSES all textfield b4 data fetch

                          // if (!creditCardFormKey.currentState!.validate())
                          //   return;
                          // creditCardFormKey.currentState!.save();
                          // model.log.v('creditCardFormKey SUCCESS');
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
