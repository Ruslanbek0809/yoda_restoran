import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'my_credit_cards_view_model.dart';

class MyCreditCardsView extends StatefulWidget {
  MyCreditCardsView({Key? key}) : super(key: key);

  @override
  State<MyCreditCardsView> createState() => _MyCreditCardsViewState();
}

class _MyCreditCardsViewState extends State<MyCreditCardsView> {
  FlashController? _previousController;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreditCardsViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.navToHomeByRemovingAll(); // Workaround
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kcWhiteColor,
            elevation: 0.5,
            leadingWidth: 35.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: kcFontColor,
                  size: 25.w,
                ),
                onPressed: model.navToHomeByRemovingAll,
              ),
            ),
            centerTitle: true,
            title: Text(
              LocaleKeys.my_credit_cards,
              style: kts22DarkText,
            ).tr(),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add_rounded,
                  color: kcSecondaryDarkColor,
                  size: 25.w,
                ),
                onPressed: () => model.navToMyCreditCardAddView(
                  onNewCreditCardAdded: () =>
                      showNewCreditCardAddedFlashBar(context),
                ),
              ),
            ],
          ),
          body: model.hiveCreditCards.isEmpty
              ? EmptyWidget(
                  text: LocaleKeys.noCreditCardsYet,
                  svg: 'assets/credit_card_empty.svg',
                )
              // --------------- HIVE CREDIT CARDS -------------- //
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: model.hiveCreditCards.length,
                  itemBuilder: (context, pos) {
                    final _creditCard = model.hiveCreditCards[pos];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 12.h, 0.0, 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                                                        _creditCard
                                                            .cardNumber.length,
                                                        '•••• •••• •••• '),
                                                style:
                                                    kts24CreditCardNumberText,
                                              ),
                                              TextSpan(
                                                text: _creditCard.cardNumber
                                                    .substring(_creditCard
                                                            .cardNumber.length -
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
                          // --------------- CREDIT CARD DELETE -------------- //
                          Padding(
                            padding: EdgeInsets.only(left: 4.w, right: 8.w),
                            child: IconButton(
                              onPressed: () async => await model
                                  .showCreditCardDeleteDialog(_creditCard),
                              icon: SvgPicture.asset(
                                'assets/trash.svg',
                                color: kcCreditCardDeleteIconColor,
                                width: 24.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 24.w),
                      color: kcDividerColor,
                      height: 0.5.h,
                    );
                  },
                ),
        ),
      ),
      viewModelBuilder: () => CreditCardsViewModel(),
    );
  }

  Future<void> showNewCreditCardAddedFlashBar(BuildContext context) async {
    if (_previousController?.isDisposed == false)
      await _previousController?.dismiss();

    _previousController = FlashController<dynamic>(
      context,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          margin: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 0.05.sh,
          ),
          backgroundColor: kcSecondaryDarkColor,
          borderRadius: kbr15,
          boxShadows: kElevationToShadow[0],
          position: FlashPosition.bottom,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          child: FlashBar(
            icon: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 12.w),
              child: SvgPicture.asset(
                'assets/warning.svg',
                width: 20.w,
                height: 20.h,
              ),
            ),
            content: Text(
              LocaleKeys.credit_card_added,
              style: kts16ButtonText,
            ).tr(),
          ),
        );
      },
      duration: const Duration(seconds: 2),
    );
    await _previousController?.show();
  }
}
