import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/cart/checkout_bottom_sheet_view/checkout_view_model.dart';
import 'package:yoda_res/ui/widgets/custom_text_child_button.dart';
import 'package:yoda_res/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutAddAddressBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const CheckoutAddAddressBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  // bool _isLoading = false;
  final GlobalKey<FormState> _cartAddressformKey = GlobalKey<FormState>();
  // final TextEditingController _cityController = TextEditingController();
  // final TextEditingController _streetController = TextEditingController();
  // final TextEditingController _apartmentController = TextEditingController();
  // final TextEditingController _houseController = TextEditingController();
  // final TextEditingController _floorController = TextEditingController();
  // final TextEditingController _notesController = TextEditingController();
  // final FocusNode _cityFocus = FocusNode();
  // final FocusNode _streetFocus = FocusNode();
  // final FocusNode _apartmentFocus = FocusNode();
  // final FocusNode _houseFocus = FocusNode();
  // final FocusNode _floorFocus = FocusNode();
  // final FocusNode _notesFocus = FocusNode();

  // Future _onConfirmButtonPressed() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   if (_cartAddressformKey.currentState!.validate()) {
  //     printLog('_contactformKey validated');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.7,
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
                          key: _cartAddressformKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: 
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
                    child: Text('Ýatda sakla', style: ktsButton18Text),
                    onPressed: () {
                      // model.updatePaymentType();
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
