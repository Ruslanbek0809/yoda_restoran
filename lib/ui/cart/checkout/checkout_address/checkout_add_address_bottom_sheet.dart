import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../shared/shared.dart';
import 'add_address_bottom_sheet_hook.dart';
import '../checkout_view_model.dart';
import '../../../widgets/widgets.dart';
import '../../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutAddAddressBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  CheckoutAddAddressBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  final GlobalKey<FormState> _addressformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) => Container(
          height: 0.7.sh,
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
                        child: Form(
                          key: _addressformKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: AddAddressBottomSheetHook(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //--------------- ADD ADDRESS BUTTON -------------- //
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: model.isBusy
                          ? ButtonLoading()
                          : Text('Ýatda sakla', style: ktsButton18Text),
                    ),
                    onPressed: () async {
                      FocusScope.of(context)
                          .unfocus(); // UNFOCUSES all textfield b4 data fetch
                      if (!_addressformKey.currentState!.validate()) return;
                      _addressformKey.currentState!.save();
                      await model.onAddAddressPressed();
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
