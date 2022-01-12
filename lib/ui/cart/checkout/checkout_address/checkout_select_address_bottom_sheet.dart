import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../../shared/shared.dart';
import '../checkout_view_model.dart';
import '../../../../utils/utils.dart';

class CheckoutSelectAddressBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const CheckoutSelectAddressBottomSheetView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  // int selectedAddressID = -1;
  // List<Address> addresses = [
  //   Address(1, 'A.Nowaýy, 164'),
  //   Address(2, 'N.Andalyp 32'),
  // ];

  // void _onCartAddressClicked() {
  //   cartAddressAddEditBottomSheet(context);
  // }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      onModelReady: (model) => model.getAddresses(),
      builder: (context, model, child) => DraggableScrollableSheet(
        initialChildSize: model.isBusy
            ? 0.3
            : model.addresses!.isEmpty
                ? 0.25
                : 0.3,
        maxChildSize: 1,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.BORDER_RADIUS_20)),
            color: kcWhiteColor,
          ),
          child: model.isBusy
              ? LoadingWidget(width: 0.1.sw)
              : Stack(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.only(

                          /// To resize screen when OnKeyboard opened
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
                              height: 6.h,
                            ),
                          ),
// --------------- ADDRESSES -------------- //
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top:
                                    Radius.circular(Constants.BORDER_RADIUS_20),
                              ),
                              color: AppTheme.WHITE,
                            ),
                            padding:
                                EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
                            child: Column(
                              children: [
                                if (model.addresses!.isNotEmpty)
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.addresses!.length,
                                    itemBuilder: (context, pos) {
                                      var _address = model.addresses![pos];
                                      return Material(
                                        color: kcWhiteColor,
                                        child: InkWell(
                                          onTap: () =>
                                              model.updateTempSelectedAddress(
                                                  _address),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      child:
                                                          model.tempSelectedAddress!
                                                                      .id ==
                                                                  _address.id
                                                              ? SvgPicture
                                                                  .asset(
                                                                  'assets/checkCircle.svg',
                                                                  color: AppTheme
                                                                      .GREEN_COLOR,
                                                                  width: 25.w,
                                                                )
                                                              : SvgPicture
                                                                  .asset(
                                                                  'assets/checkCircle.svg',
                                                                  color: Colors
                                                                      .white,
                                                                  width: 25.w,
                                                                ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Text(
                                                      _address.street! +
                                                          (_address.house !=
                                                                  null
                                                              ? ', ${_address.house}'
                                                              : ''),
                                                      style: ktsDefault18Text,
                                                    ),
                                                  ],
                                                ),
                                                SvgPicture.asset(
                                                  'assets/addressFilter.svg',
                                                  color: AppTheme.MAIN_DARK,
                                                  width: 25.w,
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
                                Material(
                                  color: kcWhiteColor,
                                  child: InkWell(
                                    onTap:
                                        model.showCustomAddAddressBottomSheet,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.w),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: kcFontColor,
                                            size: 27.w,
                                          ),
                                          SizedBox(width: 10.w),
                                          Text(
                                            'Täze salgy goş...',
                                            style: ktsDefault18Text,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //--------------- ADDRESS CHOOSE BUTTON -------------- //
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kcWhiteColor,
                          // border: Border.all(
                          //     color: AppTheme.BUTTON_BORDER_COLOR, width: 0.1),
                        ),
                        padding: EdgeInsets.fromLTRB(15.w, 10.w, 15.w, 25.w),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppTheme.MAIN,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: AppTheme().radius15),
                            padding: EdgeInsets.symmetric(vertical: 17.w),
                          ),
                          child: Text(
                            'Salgyny saýla',
                            style: TextStyle(
                              color: AppTheme.WHITE,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onPressed: () {
                            model.saveSelectedAddress();
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
