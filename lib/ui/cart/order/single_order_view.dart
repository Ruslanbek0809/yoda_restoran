import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:timelines/timelines.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/models.dart';
import '../../widgets/widgets.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'order_view_model.dart';
import 'single_order_credit_cards/so_select_credit_cards_bottom_sheet.dart';
import 'single_order_view_model.dart';

class SingleOrderView extends StatelessWidget {
  final Order order;
  final OrderViewModel orderViewModel;
  const SingleOrderView({
    Key? key,
    required this.order,
    required this.orderViewModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleOrderViewModel>.reactive(
      onModelReady: (model) => model.initSingleOrder(),
      viewModelBuilder: () => SingleOrderViewModel(
        order: order,
        orderViewModel: orderViewModel,
      ),
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
              if (order.status == 4)
                // A CustomSlidableAction can have an icon and/or a label.
                CustomSlidableAction(
                  autoClose: false,
                  onPressed: (BuildContext context) async =>
                      await model.showOrderDeleteDialog(
                    () async {
                      showErrorFlashBar(
                        context: context,
                        msg: LocaleKeys.orderDeleteSuccess.tr(),
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
                  ),
                  backgroundColor: kcRedColor,
                  child: model.busy(order.id) && order.status == 4
                      ? ButtonLoading(color: kcWhiteColor)
                      : SvgPicture.asset(
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
                          style: kts18BoldText,
                        ),
                        SizedBox(height: 3.h),
                        //------------------ ORDER CREATED AT DATE and ORDER STATUS ---------------------//
                        Row(
                          children: [
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
                            Text(
                              ' #${order.orderNumber!.substring(order.orderNumber!.length - 4)}',
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
                        style: kts18BoldText,
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
                              unratedColor: kcPrimaryColor.withOpacity(0.4),
                              itemSize: 14.sp,
                              itemBuilder: (context, _) => Icon(
                                Icons.star_rounded,
                                color: kcPrimaryColor,
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
                    //------------------ ORDER TIMELINE ---------------------//
                    if (order.status! > 1)
                      Container(
                        height: 0.25,
                        color: kcDividerColor,
                        margin: EdgeInsets.only(
                          bottom: 12.h,
                          top: 10.h,
                          left: 15.w,
                        ),
                      ),
                    if (order.status! > 1)
                      SizedBox(
                        height: 40.h,
                        child: OrderTimeline(
                          order: order,
                          singleOrderViewModel: model,
                        ),
                      ),
                    Container(
                      height: 0.25,
                      color: kcDividerColor,
                      margin: EdgeInsets.only(
                        top: 14.h,
                        left: 15.w,
                      ),
                    ),
                    //------------------ DRIVER and DELIVERY ---------------------//
                    if (!order.selfPickUp!)
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.orderOperator,
                              style: kts16Text,
                            ).tr(),
                            Text(
                              order.restaurant!.phoneNumber != null
                                  ? order.restaurant!.phoneNumber.toString()
                                  : '',
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
                                    style: kts16BoldText,
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
                                            style: kts16BoldText,
                                          ),
                          ],
                        ),
                      ),
                    //------------------ SINGLE ORDER DIVIDER ---------------------//
                    if (order.promocode != null)
                      Container(
                        height: 0.25,
                        color: kcDividerColor,
                        margin: EdgeInsets.only(
                          top: 14.h,
                          left: 15.w,
                        ),
                      ),
                    //------------------ PROMOCODE PART ---------------------//
                    if (order.promocode != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            15.w,
                            order.selfPickUp! ? 14.h : 16.h,
                            15.w,
                            order.selfPickUp! ? 2.h : 4.h),
                        child: Row(
                          textBaseline: TextBaseline.ideographic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/percent.svg',
                                  color: kcGreenColor,
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
                              '-${formatNum(model.getPromocodePrice())} TMT',
                              style: kts16BoldText,
                            ),
                          ],
                        ),
                      ),
                    //------------------ SINGLE ORDER DIVIDER ---------------------//
                    if (!order.selfPickUp! || order.promocode != null)
                      Container(
                        height: 0.25,
                        color: kcDividerColor,
                        margin: EdgeInsets.only(
                          top: 12.h,
                          left: 15.w,
                        ),
                      ),
                    //------------------ USER DETAILS (DELIVERY DATETIME, PAYMENT TYPE, ADDRESS, NOTES) ---------------------//
                    Padding(
                      padding:
                          EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          !order.selfPickUp!
                              ? Text(
                                  LocaleKeys.deliveryTime,
                                  style: kts16Text,
                                ).tr()
                              : Text(
                                  LocaleKeys.preparationOrderTime,
                                  style: kts16Text,
                                ).tr(),
                          order.deliveryTime == null
                              ? Text(
                                  LocaleKeys.now,
                                  style: kts16BoldText,
                                ).tr()
                              : Text(
                                  DateFormat('HH:mm, dd.MM.yyyy')
                                      .format(order.deliveryTime!.toLocal()),
                                  style: kts16BoldText,
                                ),
                        ],
                      ),
                    ),
                    //------------------ ORDER PAYMENT TYPE ---------------------//
                    if (order.paymentType != null)
                      //------------------ ORDER ONLINE PAYMENT TYPE ---------------------//
                      order.paymentType!.id == 4
                          ?
                          //------------------ ORDER ONLINE If PAID ---------------------//
                          order.paid!
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.w, right: 15.w, top: 12.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocaleKeys.paymentType,
                                        style: kts16Text,
                                      ).tr(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: AppTheme().radius5,
                                          color: kcOnlinePaymentColor,
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4.w),
                                              child: Text(
                                                context.locale ==
                                                        context
                                                            .supportedLocales[0]
                                                    ? order.paymentType!.nameTk!
                                                    : order
                                                        .paymentType!.nameRu!,
                                                style: kts16WhiteBoldText,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/check_outlined_circle.svg',
                                              color: kcWhiteColor,
                                              width: 20.sp,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              //------------------ ORDER ONLINE If NOT PAID ---------------------//
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.w, right: 15.w, top: 12.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocaleKeys.paymentType,
                                        style: kts16Text,
                                      ).tr(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: AppTheme().radius5,
                                          color: kcSecondaryLightColor,
                                        ),
                                        child: Text(
                                          context.locale ==
                                                  context.supportedLocales[0]
                                              ? order.paymentType!.nameTk!
                                              : order.paymentType!.nameRu!,
                                          style: kts16BoldText,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                          //------------------ ORDER OTHER PAYMENT TYPES ---------------------//
                          : Padding(
                              padding: EdgeInsets.only(
                                  left: 15.w, right: 15.w, top: 12.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocaleKeys.paymentType,
                                    style: kts16Text,
                                  ).tr(),
                                  Text(
                                    context.locale ==
                                            context.supportedLocales[0]
                                        ? order.paymentType!.nameTk!
                                        : order.paymentType!.nameRu!,
                                    style: kts16BoldText,
                                  ),
                                ],
                              ),
                            ),
                    if (order.address != null && order.address!.isNotEmpty)
                      Padding(
                        padding:
                            EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/house_outlined.svg',
                              color: kcErrorEmptyColor,
                            ),
                            SizedBox(width: 7.w),
                            Flexible(
                              child: Text(
                                order.address!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: kts14IconText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (order.notes != null && order.notes!.isNotEmpty)
                      Padding(
                        padding:
                            EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/chat_circle_outlined.svg',
                              color: kcErrorEmptyColor,
                            ),
                            SizedBox(width: 7.w),
                            Flexible(
                              child: Text(
                                order.notes!,
                                style: kts14IconText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    //------------------ SINGLE ORDER DIVIDER ---------------------//
                    Container(
                      height: 0.25,
                      color: kcDividerColor,
                      margin: EdgeInsets.only(
                        top: 12.h,
                        left: 15.w,
                      ),
                    ),

                    //------------------ ORDERS TOTAL PRICE ---------------------//
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.h,
                        bottom: 4.h,
                        right: 15.w,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${formatNum(order.totPrice!)} TMT',
                          style: kts18BoldText,
                        ),
                      ),
                    ),
                    //------------------ ORDER MEAL LIST ---------------------//
                    Column(
                      children: order.orderItems!.map((_orderItem) {
                        String? _orderItemConcatenatedText =
                            model.getConcatenateVolsCustoms(_orderItem);

                        return Padding(
                          padding: EdgeInsets.only(
                            left: 15.w,
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
                                  padding: EdgeInsets.only(top: 2.h),
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
                        height: 0.25,
                        color: kcDividerColor,
                        margin: EdgeInsets.only(
                          top: 10.h,
                          bottom: 8.h,
                          left: 15.w,
                        ),
                      ),
                    if (order.rating != null &&
                        order.rating!.feedback!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 5.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                              initialRating: order.rating!.value!,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              allowHalfRating: false,
                              ignoreGestures: true,
                              glow: false,
                              unratedColor:
                                  kcSecondaryDarkColor.withOpacity(0.4),
                              itemSize: 14.sp,
                              itemBuilder: (context, _) => Icon(
                                Icons.star_rounded,
                                color: kcSecondaryDarkColor,
                              ),
                              onRatingUpdate: (val) {},
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              order.rating!.feedback!,
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: kcIconColor,
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
                              foregroundColor: kcSecondaryLightColor,
                              backgroundColor:
                                  kcSecondaryDarkColor, // ripple effect color
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
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.w),
                                        child: Text(
                                          LocaleKeys.rateOrder,
                                          style: ktsButtonWhite18Text,
                                        ).tr(),
                                      )
                                    ],
                                  )
                                : order.status == 2 || order.status == 3
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/phone.svg',
                                            color: kcWhiteColor,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: Text(
                                              LocaleKeys.orderOperatorButton,
                                              style: ktsButtonWhite18Text,
                                            ).tr(),
                                          )
                                        ],
                                      )
                                    : model.busy(order.id) && order.status == 1
                                        ? ButtonLoading()
                                        : Text(
                                            LocaleKeys.cancelOrder,
                                            style: ktsButtonWhite18Text,
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
                                  // await model.showCancelAcceptedOrderDialog();
                                  if (order.restaurant?.phoneNumber != null)
                                    await model.makePhoneCallToDriver(
                                        order.restaurant!.phoneNumber!);
                                  break;
                                case 3:
                                  if (order.restaurant?.phoneNumber != null)
                                    await model.makePhoneCallToDriver(
                                        order.restaurant!.phoneNumber!);
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 15.w),
                          child: SizedBox(
                            width: 0.35.sw,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: kcSecondaryLightColor,
                                backgroundColor:
                                    kcOrderDeleteButtonBackColor, // ripple effect color
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: AppTheme().radius10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 15.w),
                              ),
                              child: model.busy(order.id) && order.status == 4
                                  ? ButtonLoading(color: kcPrimaryColor)
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/trash.svg',
                                          color: kcDialogColor,
                                          width: 16.sp,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: Text(
                                            LocaleKeys.deleteOrder,
                                            style: kts12DialogText,
                                          ).tr(),
                                        )
                                      ],
                                    ),
                              onPressed: () async =>
                                  await model.showOrderDeleteDialog(
                                () async {
                                  showErrorFlashBar(
                                    context: context,
                                    msg: LocaleKeys.orderDeleteSuccess.tr(),
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
                              ),
                            ),
                          ),
                        ),
                      ),

                    //------------------ ONLINE PAYMENT ORDER BUTTON ---------------------//
                    if ((order.paymentType!.id == 4 &&
                            (!order.paid! && order.status == 1)) ||
                        (order.paymentType!.id == 4 &&
                            (!order.paid! && order.status == 2)))
                      SizedBox(
                        width: 1.sw,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 10.h),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: order.status == 1
                                  ? kcSecondaryLightColor
                                  : kcOnlinePaymentColor,
                              backgroundColor: order.status == 1
                                  ? kcSecondaryLightColor
                                  : kcOnlinePaymentColor, // ripple effect color
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: AppTheme().radius10),
                              padding: EdgeInsets.symmetric(vertical: 11.h),
                            ),
                            child: order.status == 2 && model.isLoading
                                ? ButtonLoading(fontSize: 28.sp)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/credit_card.svg',
                                        color: order.status == 1
                                            ? kcContactColor
                                            : kcWhiteColor,
                                        width: 28.w,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.w),
                                        child: Text(
                                          LocaleKeys.online_paymentType,
                                          style: order.status == 1
                                              ? ktsButton18ContactText
                                              : ktsButtonWhite18Text,
                                        ).tr(),
                                      )
                                    ],
                                  ),
                            onPressed: () async {
                              switch (order.status) {
                                case 1:
                                  break;
                                case 2:
                                  // await model.onConfirmButtonPressed(
                                  //   onSuccessForView:
                                  //       (paymentCreateBankOrder) async {
                                  //     // await showFlexibleBottomSheet(
                                  //     //   initHeight: 0.95,
                                  //     //   maxHeight: 0.95,
                                  //     //   duration: Duration(milliseconds: 250),
                                  //     //   context: context,
                                  //     //   bottomSheetColor: Colors.transparent,
                                  //     //   builder: (context, scrollController,
                                  //     //           offset) =>
                                  //     //       SingleOrderPaymentBottomSheetView(
                                  //     //     scrollCftroller: scrollController,
                                  //     //     offset: offset,
                                  //     //     paymentRegister: paymentRegister,
                                  //     //     order: order,
                                  //     //     orderViewModel: orderViewModel,
                                  //     //   ),
                                  //     // );

                                  //     await model
                                  //         .showCustomSendCodeConfirmationBottomSheet(
                                  //             paymentCreateBankOrder);
                                  //   },
                                  //   onFailForView: () async {
                                  //     await showErrorFlashBar(
                                  //       context: context,
                                  //       margin: EdgeInsets.only(
                                  //         left: 16.w,
                                  //         right: 16.w,
                                  //         bottom: 0.05.sh,
                                  //       ),
                                  //     );
                                  //   },
                                  // );

                                  await showFlexibleBottomSheet(
                                    isExpand: false,
                                    initHeight: 0.95,
                                    maxHeight: 0.95,
                                    duration: Duration(milliseconds: 250),
                                    context: context,
                                    bottomSheetColor: Colors.transparent,
                                    builder:
                                        (context, scrollController, offset) =>
                                            SOSelectCreditCardsBottomSheetView(
                                      scrollController: scrollController,
                                      offset: offset,
                                      order: order,
                                    ),
                                  );
                                  break;
                                default:
                                  break;
                              }
                            },
                          ),
                        ),
                      ),

//------------------ ONLINE PAYMENT INFO ---------------------//
                    if ((order.paymentType!.id == 4 &&
                            (!order.paid! && order.status == 1)) ||
                        (order.paymentType!.id == 4 &&
                            (!order.paid! && order.status == 2)))
                      Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 0.h, 15.w, 10.h),
                        child: Text(
                          order.status == 1
                              ? LocaleKeys.online_paymentType_info
                              : LocaleKeys.can_online_pay,
                          style: kts12DialogText,
                        ).tr(),
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

class OrderTimeline extends StatelessWidget {
  final Order order;
  final SingleOrderViewModel singleOrderViewModel;
  const OrderTimeline({
    Key? key,
    required this.order,
    required this.singleOrderViewModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        direction: Axis.horizontal,
        nodePosition: 1, // MOVES indicatorBuilder
        connectorTheme: ConnectorThemeData(
          thickness: 3.0,
          color: kcOrderTimelineColor,
        ),
        indicatorTheme: IndicatorThemeData(size: 15.0),
      ),
      // padding: EdgeInsets.only(top: 10.h),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemExtentBuilder: (_, __) =>
            1.sw / singleOrderViewModel.orderTimelines.length,
        itemCount: singleOrderViewModel.orderTimelines.length,
        connectorBuilder: (_, index, __) {
          if (singleOrderViewModel.orderTimelines[index].id <= order.status!)
            return SolidLineConnector(color: kcSecondaryDarkColor);
          else
            return SolidLineConnector(color: kcOrderTimelineColor);
        },
        indicatorBuilder: (_, index) {
          if (singleOrderViewModel.orderTimelines[index].id <= order.status!)
            return DotIndicator(
              color: kcSecondaryDarkColor,
              child: Icon(
                Icons.check,
                color: kcWhiteColor,
                size: 10.0,
              ),
            );
          else
            return DotIndicator(
              color: kcOrderTimelineColor,
              child: SizedBox(),
            );
        },

        /// TOP content of indicator
        oppositeContentsBuilder: (context, index) {
          if (singleOrderViewModel.orderTimelines[index].id <= order.status!)
            return Column(
              children: [
                Text(
                  singleOrderViewModel.orderTimelines[index].name,
                  style: kts10IconText,
                ),
                Text(
                  DateFormat('HH:mm').format(
                    singleOrderViewModel.orderTimelines[index].orderStatusAt
                        .toLocal(),
                  ),
                  style: kts10IconText,
                )
              ],
            );
          else
            SizedBox();
          return SizedBox();
        },

        /// BOTTOM content of indicator
        contentsBuilder: (_, __) => SizedBox(),
      ),
    );
  }
}
