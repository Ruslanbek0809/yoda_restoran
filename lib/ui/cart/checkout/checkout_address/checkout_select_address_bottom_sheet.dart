import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import '../../../../generated/locale_keys.g.dart';
import 'checkout_address_view_model.dart';
import '../../../widgets/widgets.dart';
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
            //*-------------- CUSTOM BOTTOM SHEET MODAL WIDGET -------------- //
            CustomModalInsideBottomSheet(),

            //*-------------- ADD NEW ADDRESS -------------- //
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Material(
                color: kcWhiteColor,
                child: InkWell(
                  // //*CUSTOM BOTTOM SHEET BASED ON CONTENT
                  // onTap: () async => await showFlexibleBottomSheet(
                  //   isExpand: false,
                  //   initHeight: 0.95,
                  //   maxHeight: 0.95,
                  //   duration: Duration(milliseconds: 250),
                  //   context: context,
                  //   bottomSheetColor: Colors.transparent,
                  //   builder: (context, scrollController, offset) =>
                  //       CheckoutAddAddressBottomSheet2View(
                  //     scrollController: scrollController,
                  //     offset: offset,
                  //   ),
                  // ),
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
            ),
            if (model.addresses!.isNotEmpty) Divider(color: kcDividerColor),
            //*-------------- ADDRESSES -------------- //
            if (model.addresses!.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 10.h),
                itemCount: model.addresses!.length,
                itemBuilder: (context, pos) {
                  var _address = model.addresses![pos];
                  return Material(
                    color: kcWhiteColor,
                    child: InkWell(
                      onTap: () => model.updateTempSelectedAddress(_address),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child:
                                  model.tempSelectedAddress!.id == _address.id
                                      ? SvgPicture.asset(
                                          'assets/checkCircle.svg',
                                          color: kcGreenColor,
                                          width: 25.w,
                                        )
                                      : SvgPicture.asset(
                                          'assets/checkCircle.svg',
                                          color: kcFillBorderColor,
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
            //*-------------- ADDRESS CHOOSE BUTTON -------------- //
            Container(
              decoration: BoxDecoration(
                color: kcWhiteColor,
                border: Border(
                  top: BorderSide(
                    width: 0.1,
                    color: kcButtonBorderColor,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 22.h),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kcPrimaryColor,
                  foregroundColor: kcSecondaryLightColor, // ripple effect color
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(borderRadius: AppTheme().radius15),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  LocaleKeys.selectAddress,
                  style: TextStyle(
                    color: kcWhiteColor,
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
            )
          ],
        ),
      ),
      viewModelBuilder: () => CheckoutAddressViewModel(),
    );
  }
}
