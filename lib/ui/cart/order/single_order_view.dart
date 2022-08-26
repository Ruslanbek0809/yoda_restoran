import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

import 'order_view_model.dart';
import 'single_order_view_model.dart';

class SingleOrderView extends StatelessWidget {
  final Order order;
  final OrderViewModel orderViewModel;
  const SingleOrderView(
      {Key? key, required this.order, required this.orderViewModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleOrderViewModel>.reactive(
      onModelReady: (model) => model.initSingleOrder(),
      viewModelBuilder: () => SingleOrderViewModel(order, orderViewModel),
      builder: (context, model, child) {
        return Slidable(
          // Specify a key if the Slidable is dismissible.
          key: ValueKey(order.id),

          /// ADDS bool condition to model.currentOrderExpansionState
          enabled: !model.currentOrderExpansionState && order.status == 4,
          endActionPane: ActionPane(
            dragDismissible: false,
            extentRatio: 0.25,
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // // A pane can dismiss the Slidable.
            // dismissible: DismissiblePane(onDismissed: () {}),

            // All actions are defined in the children parameter.
            children: [
              // A CustomSlidableAction can have an icon and/or a label.
              CustomSlidableAction(
                onPressed: (BuildContext context) async {},
                backgroundColor: kcRedColor,
                child: SvgPicture.asset(
                  'assets/trash.svg',
                  color: kcWhiteColor,
                  width: 24.sp,
                ),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                dividerTheme: DividerThemeData(
                    color: Theme.of(context).colorScheme.background),
              ),
              child: ClipRRect(
                borderRadius: AppTheme().radius16,
                child: ExpansionTile(
                  initiallyExpanded: order.status == 2 || order.status == 1,
                  title: SizedBox(),
                  onExpansionChanged: (value) {
                    model.changeCurrentOrderExpansionState(value);
                    printLog(
                        'onExpansionChanged() value and _currentOrderExpansionState: $value');
                  },

                  /// had to use SizedBox in leading bc of tileWidth issue
                  leading: SizedBox(
                    width: 0.7.sw,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //------------------ RESTAURANT NAME ---------------------//
                        SizedBox(height: 2.h),
                        Text(
                          order.restaurant!.name!,
                          overflow: TextOverflow.ellipsis,
                          style: ktsDefault18SemiBoldText,
                        ),
                        SizedBox(height: 3.h),
                        //------------------ DATE and STATUS ---------------------//
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/clock_light.svg',
                              width: 18.w,
                            ),
                            SizedBox(width: 5.w),
                            order.deliveryTime == null
                                ? order.status == 4
                                    ? Text(
                                        DateFormat('HH:mm, dd.MM.yyyy')
                                            .format(order.createdAt!.toLocal()),
                                        style: kts14Text,
                                      )
                                    : Text(
                                        LocaleKeys.now,
                                        style: kts14Text,
                                      ).tr()
                                : Text(
                                    DateFormat('HH:mm, dd.MM.yyyy')
                                        .format(order.deliveryTime!.toLocal()),
                                    style: kts14Text,
                                  ),

                            /// if order.rating NOT null, SHOW orderStatusText here
                            if (order.rating != null)
                              Text(
                                ' - ${model.orderStatusText}',
                                style: kts14HelperText,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //------------------ ORDER PRICE and STATUS/RATING  ---------------------//
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${order.promocode != null ? formatNum(model.getTotalOrderSumWithPromocode()) : formatNum(order.dostawkaPrice != null ? (order.totPrice! + order.dostawkaPrice!) : order.totPrice!)} TMT',
                        style: ktsDefault18SemiBoldText,
                      ),
                      SizedBox(height: 2.h),

                      /// if order.rating NOT null
                      order.rating != null
                          ? RatingBar.builder(
                              initialRating: order.rating!.value!,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              allowHalfRating: false,
                              ignoreGestures: true,
                              glow: false,
                              unratedColor: AppTheme.MAIN.withOpacity(0.4),
                              itemSize: 14.sp,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: AppTheme.MAIN,
                              ),
                              onRatingUpdate: (val) {},
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: AppTheme().radius5,
                                color: kcSecondaryLightColor,
                              ),
                              child: Text(
                                model.orderStatusText,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: kcFontColor,
                                ),
                              ),
                            ),
                    ],
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //------------------ INNER PART ---------------------//
                    //------------------ DRIVER and DELIVERY ---------------------//
                    if (!order.selfPickUp!)
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.driver,
                              style: kts16Text,
                            ).tr(),
                            order.selfPickUp!
                                ? Text(
                                    '-',
                                    style: kts16Text,
                                  )
                                : order.status == 1
                                    ? Text(
                                        LocaleKeys.notAssignedYet,
                                        style: kts16Text,
                                        overflow: TextOverflow.visible,
                                      ).tr()
                                    : order.driver == null ||
                                            (order.driver!.mobile == null ||
                                                order.driver!.mobile!.isEmpty)
                                        ? SizedBox()
                                        : Text(
                                            order.driver!.mobile!,
                                            style: kts16Text,
                                          ),
                          ],
                        ),
                      ),
                    if (!order.selfPickUp!)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.deliveryPrice,
                              style: kts16Text,
                            ).tr(),
                            order.selfPickUp!
                                ? Text(
                                    '0 TMT',
                                    style: kts16Text,
                                  )
                                : order.status == 1
                                    ? Text(
                                        LocaleKeys.notAssignedYet,
                                        overflow: TextOverflow.fade,
                                        style: kts16Text,
                                      ).tr()
                                    : order.dostawkaPrice == null
                                        ? SizedBox()
                                        : Text(
                                            '${formatNum(order.dostawkaPrice!)} TMT',
                                            style: kts16Text,
                                          ),
                          ],
                        ),
                      ),
                    //------------------ PROMOCODE PART ---------------------//
                    if (order.promocode != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            15.w,
                            order.selfPickUp! ? 15.h : 17.h,
                            15.w,
                            order.selfPickUp! ? 0.h : 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/percent.svg',
                                  color: kcSecondaryDarkColor,
                                  width: 22.w,
                                ),
                                SizedBox(width: 7.w),
                                Text(
                                  order.promocode!.name!,
                                  style: kts16Text,
                                ),
                              ],
                            ),
                            Text(
                              '${formatNum(order.totPrice!)} TMT -${formatNum(model.getPromocodePrice())} TMT',
                              style: kts16Text,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 15.h),
                    //------------------ ORDER MEAL LIST ---------------------//
                    Column(
                      children: order.orderItems!.map((_orderItem) {
                        String? _orderItemConcatenatedText =
                            model.getConcatenateVolsCustoms(_orderItem);

                        return Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            bottom: 5.h,
                            right: 15.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _orderItem.mealJson!.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: kts16Text,
                                    ),
                                  ),
                                  Text(
                                    '${formatNum(_orderItem.quantity!)} x ${formatNum(_orderItem.price!)} TMT',
                                    style: kts16Text,
                                  ),
                                ],
                              ),
                              //------------------ OrderItem concatenated text ---------------------//
                              if (_orderItem.volumePrices!.isNotEmpty ||
                                  _orderItem.costumizedMeals!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    bottom: 0.h,
                                    top: 2.h,
                                  ),
                                  child: Text(
                                    _orderItemConcatenatedText!,
                                    overflow: TextOverflow.ellipsis,
                                    style: kts14HelperText,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    //------------------ ORDER RATING BUTTON/FEEDBACK ---------------------//
                    if (order.rating != null &&
                        order.rating!.feedback!.isNotEmpty)
                      Container(
                        width: 1.sw,
                        margin: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 5.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: AppTheme().radius10,
                          color: kcSecondaryLightColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.ratingYourFeedback,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: kcErrorEmptyColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ).tr(),
                            SizedBox(height: 5.h),
                            Text(
                              order.rating!.feedback!,
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: kcErrorEmptyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    //------------------ ORDER BUTTON ---------------------//

                    if (order.status != 4 ||
                        (order.status == 4 && order.rating == null))
                      SizedBox(height: 5.h),
                    if (order.status != 4 ||
                        (order.status == 4 && order.rating == null))
                      SizedBox(
                        width: 1.sw,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: kcSecondaryDarkColor,
                              primary:
                                  kcSecondaryLightColor, // ripple effect color
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: AppTheme().radius10),
                              padding: EdgeInsets.symmetric(vertical: 11.h),
                            ),
                            child: order.status == 4
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star_border_rounded,
                                        size: 26.0,
                                        color: kcWhiteColor,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        LocaleKeys.rateOrder,
                                        style: ktsButton18Text,
                                      ).tr()
                                    ],
                                  )
                                : order.status == 3
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          !order.selfPickUp!
                                              ? Text(
                                                  LocaleKeys.driver,
                                                  style: ktsButton18Text,
                                                ).tr()
                                              : Text(
                                                  LocaleKeys.selfPickUp,
                                                  style: ktsButton18Text,
                                                ).tr(),
                                          if (!order.selfPickUp!)
                                            Text(
                                              ' ${order.driver!.mobile}',
                                              style: ktsButton18Text,
                                            ).tr(),
                                        ],
                                      )
                                    // : order.status == 4
                                    //     ? Text(
                                    //         LocaleKeys.reOrder,
                                    //         style: ktsButton18Text,
                                    //       ).tr()
                                    : model.busy(order.id) && order.status == 1
                                        ? ButtonLoading()
                                        : Text(
                                            LocaleKeys.cancelOrder,
                                            style: ktsButton18Text,
                                          ).tr(),
                            onPressed: () async {
                              switch (order.status) {
                                case 1:
                                  await model.showCancelWaitingOrderDialog(
                                    order.id!,
                                    () async {
                                      showErrorFlashBar(
                                        context: context,
                                        msg: LocaleKeys.orderCancelSuccess.tr(),
                                        margin: EdgeInsets.only(
                                          left: 0.1.sw,
                                          right: 0.1.sw,
                                          bottom: 0.05.sh,
                                        ),
                                      );
                                    },
                                    () async {
                                      showErrorFlashBar(
                                        context: context,
                                        margin: EdgeInsets.only(
                                          left: 0.1.sw,
                                          right: 0.1.sw,
                                          bottom: 0.05.sh,
                                        ),
                                      );
                                    },
                                  );
                                  break;
                                case 2:
                                  await model.showCancelAcceptedOrderDialog();
                                  break;
                                case 3:
                                  if (!order.selfPickUp!)
                                    await model.makePhoneCallToDriver(
                                        order.driver!.mobile!);
                                  break;
                                case 4:
                                  await model.showRateOrderDialog(order);
                                  break;
                                default:
                                  break;
                              }
                            },
                          ),
                        ),
                      ),

                    //------------------ ORDER DELETE BUTTON ---------------------//
                    if (order.status == 4)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            primary:
                                kcSecondaryLightColor, // ripple effect color
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: AppTheme().radius10),
                            padding: EdgeInsets.symmetric(
                                vertical: 6.h, horizontal: 15.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/trash.svg',
                                color: kcDialogColor,
                                width: 20.sp,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 7.w),
                                child: Text(
                                  LocaleKeys.deleteOrder,
                                  style: kts16DialogText,
                                ).tr(),
                              )
                            ],
                          ),
                          onPressed: () async {},
                          // onPressed: () async =>
                          //     await model.showAddressRemoveDialog(
                          //   addressesViewModel,
                          //   address,
                          // ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
