import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/ui/cart/checkout/checkout_address/checkout_address_view_model.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../../shared/shared.dart';
import '../../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutSelectAddressBottomSheetView extends StatelessWidget {
  final ScrollController scrollController;
  final double offset;
  const CheckoutSelectAddressBottomSheetView({
    Key? key,
    required this.scrollController,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutAddressViewModel>.reactive(
      onModelReady: (model) => model.getAddresses(),
      builder: (context, model, child) => model.isBusy
          ? LoadingWidget(width: 0.1.sw)
          : Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Constants.BORDER_RADIUS_20)),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.only(

                        /// To resize screen when OnKeyboard opened
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // --------------- ADD NEW ADDRESS -------------- //
                          Material(
                            color: kcWhiteColor,
                            child: InkWell(
                              onTap: model.showCustomAddAddressBottomSheet,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      color: kcSecondaryDarkColor,
                                      size: 27.w,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      LocaleKeys.addNewAddress,
                                      style: kts18Text,
                                    ).tr(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (model.addresses!.isNotEmpty)
                            Divider(color: kcDividerColor),
                          // --------------- ADDRESSES -------------- //
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
                                    onTap: () => model
                                        .updateTempSelectedAddress(_address),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: model.tempSelectedAddress!
                                                        .id ==
                                                    _address.id
                                                ? SvgPicture.asset(
                                                    'assets/checkCircle.svg',
                                                    color: AppTheme.GREEN_COLOR,
                                                    width: 25.w,
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/checkCircle.svg',
                                                    color: kcActiveDotColor,
                                                    width: 25.w,
                                                  ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Flexible(
                                            child: Text(
                                              _address.street! +
                                                  (_address.house != null
                                                      ? ', ${_address.house}'
                                                      : ''),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: kts18Text,
                                            ),
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
                        backgroundColor: kcPrimaryColor,
                        primary: kcSecondaryLightColor, // ripple effect color
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: AppTheme().radius15),
                        padding: EdgeInsets.symmetric(vertical: 17.w),
                      ),
                      child: Text(
                        LocaleKeys.selectAddress,
                        style: TextStyle(
                          color: AppTheme.WHITE,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ).tr(),
                      onPressed: () {
                        model.saveSelectedAddress();
                        Navigator.pop(context);
                        // completer(SheetResponse());
                      },
                    ),
                  ),
                )
              ],
            ),
      viewModelBuilder: () => CheckoutAddressViewModel(),
    );
  }
}
