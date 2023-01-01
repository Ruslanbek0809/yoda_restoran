import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/shared.dart';
import 'add_address_bottom_sheet_hook.dart';
import '../../../widgets/widgets.dart';
import '../../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'checkout_address_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutAddAddressBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse<bool>) completer;
  CheckoutAddAddressBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  final GlobalKey<FormState> _addressformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutAddressViewModel>.reactive(
      builder: (context, model, child) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 1,
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
                        // --------------- BOTTOM SHEET DRAGGER -------------- //
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: SvgPicture.asset(
                            'assets/bottom_sheet_dragger.svg',
                            color: kcSecondaryLightColor,
                            // height: 6.h,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Constants.BORDER_RADIUS_20),
                            ),
                            color: kcWhiteColor,
                          ),
                          padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 10.h),
                          child: Form(
                            key: _addressformKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: AddAddressBottomSheetHook(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //--------------- ADD ADDRESS BUTTON -------------- //
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
                        borderRadius: AppTheme().radius15,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: model.isLoading
                              ? ButtonLoading()
                              : Text(
                                  LocaleKeys.addNewAddressButton,
                                  style: ktsButtonWhite18Text,
                                ).tr(),
                        ),
                        onPressed: !model.isLoading
                            ? () async {
                                FocusScope.of(context)
                                    .unfocus(); // UNFOCUSES all textfield b4 data fetch
                                if (!_addressformKey.currentState!.validate())
                                  return;
                                _addressformKey.currentState!.save();
                                await model.onAddAddressPressed(() async {
                                  await completer(SheetResponse(data: true));
                                  await showErrorFlashBar(
                                    context: context,
                                    msg: LocaleKeys.addAddedSuccessfully,
                                    margin: EdgeInsets.only(
                                      left: 16.w,
                                      right: 16.w,
                                      bottom: 0.05.sh,
                                    ),
                                  );
                                }, () async {
                                  await showErrorFlashBar(
                                    context: context,
                                    margin: EdgeInsets.only(
                                      left: 16.w,
                                      right: 16.w,
                                      bottom: 0.05.sh,
                                    ),
                                  );
                                });
                              }
                            : () {},
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
      viewModelBuilder: () => CheckoutAddressViewModel(),
    );
  }
}
