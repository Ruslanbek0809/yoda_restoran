import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../../../../shared/shared.dart';
import '../../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'so_credit_cards_view_model.dart';

class SOSelectCreditCardsBottomSheetView extends StatelessWidget {
  final ScrollController scrollController;
  final double offset;
  final Order order;
  const SOSelectCreditCardsBottomSheetView({
    Key? key,
    required this.scrollController,
    required this.offset,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SOCreditCardsViewModel>.reactive(
      viewModelBuilder: () => SOCreditCardsViewModel(),
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

            // --------------- CREDIT CARD CONFIRMATION -------------- //
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Material(
                color: kcWhiteColor,
                child: InkWell(
                  /// ASSIGNS only order model if it is new Credit Card
                  onTap: () async =>
                      await model.showCustomCreditCardsConfirmationBottomSheet(
                          order: order),
                  //* COMMENTED
                  // onTap: () async => await showFlexibleBottomSheet(
                  //   isExpand: false,
                  //   initHeight: 0.95,
                  //   maxHeight: 0.95,
                  //   duration: Duration(milliseconds: 250),
                  //   context: context,
                  //   bottomSheetColor: Colors.transparent,
                  //   builder: (context, scrollController, offset) =>
                  //       SOConfirmationBottomSheet2View(
                  //     scrollController: scrollController,
                  //     offset: offset,
                  //   ),
                  // ),
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
                          LocaleKeys.addNewCreditCard,
                          style: kts18Text,
                        ).tr(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (model.hiveCreditCards.isNotEmpty)
              Divider(color: kcDividerColor),
            // --------------- HIVE CREDIT CARDS -------------- //
            if (model.hiveCreditCards.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 10.h),
                itemCount: model.hiveCreditCards.length,
                itemBuilder: (context, pos) {
                  final _creditCard = model.hiveCreditCards[pos];
                  return Material(
                    color: kcWhiteColor,
                    child: InkWell(
                      onTap: () =>
                          model.updateTempSelectedHiveCreditCard(_creditCard),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // --------------- SELECTED HIVE CREDIT CARD -------------- //
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: model.tempSelectedHiveCreditCard != null &&
                                      model.tempSelectedHiveCreditCard!
                                              .bankId ==
                                          _creditCard.bankId
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

                            // --------------- CREDIT CARD INFO -------------- //
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // --------------- CREDIT CARD NAME  -------------- //
                                  Text(
                                    _creditCard.cardHolderName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kts16BoldText,
                                  ),
                                  // --------------- CREDIT CARD NUMBER and EXPIRY DATE  -------------- //
                                  Padding(
                                    padding: EdgeInsets.only(top: 0.h),
                                    child: Row(
                                      textBaseline: TextBaseline.ideographic,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      children: [
                                        Flexible(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: _creditCard.cardNumber
                                                      .replaceRange(
                                                          0,
                                                          _creditCard.cardNumber
                                                              .length,
                                                          '•••• •••• •••• '),
                                                  style:
                                                      kts24CreditCardNumberText,
                                                ),
                                                TextSpan(
                                                  text: _creditCard.cardNumber
                                                      .substring(_creditCard
                                                              .cardNumber
                                                              .length -
                                                          4),
                                                  style: kts18Text,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16.w),
                                          child: Text(
                                            _creditCard.expiryDate,
                                            style: kts18Text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
            //--------------- CREDIT CARD CHOOSE BUTTON -------------- //
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
                  backgroundColor: kcOnlinePaymentColor,
                  primary: kcSecondaryLightColor, // ripple effect color
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(borderRadius: AppTheme().radius15),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  LocaleKeys.selectCreditCard,
                  style: TextStyle(
                    color: kcWhiteColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ).tr(),
                // onPressed: () async => await showFlexibleBottomSheet(
                //   isExpand: false,
                //   initHeight: 0.95,
                //   maxHeight: 0.95,
                //   duration: Duration(milliseconds: 250),
                //   context: context,
                //   bottomSheetColor: Colors.transparent,
                //   builder: (context, scrollController, offset) =>
                //       SOConfirmationBottomSheetView(
                //     scrollController: scrollController,
                //     offset: offset,
                //   ),
                // ),
                onPressed: () async {
                  if (model.tempSelectedHiveCreditCard == null)
                    await showErrorFlashBar(
                      context: context,
                      msg: LocaleKeys.selectCreditCard,
                      margin: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 0.13.sh,
                      ),
                    );
                  else
                    await model.showCustomCreditCardsConfirmationBottomSheet(
                      isNewCreditCard: false,
                      order: order,
                    );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
