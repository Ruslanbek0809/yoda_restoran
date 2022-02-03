import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'order_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class OrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
      onModelReady: (model) => model.getOrders(),
      builder: (context, model, child) {
        /// When the app is open and it receives a push notification
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          model.log.v('OrdersView OnMESSAGE with data ${message.data}');
          model.getOrders();
        });
        return WillPopScope(
          onWillPop: () async {
            model.navToHomeByRemovingAll(); // Workaround
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.WHITE,
              elevation: 0.5,
              leadingWidth: 35.w,
              leading: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppTheme.FONT_COLOR,
                    size: 25.w,
                  ),
                  onPressed: model.navToHomeByRemovingAll,
                ),
              ),
              centerTitle: true,
              title: Text(
                LocaleKeys.myOrders,
                style: ktsDefault22DarkText,
              ).tr(),
            ),
            body: model.isBusy || model.isFetchingOrders
                ? LoadingWidget()
                : model.orders!.isEmpty
                    ? EmptyWidget(
                        text: LocaleKeys.noOrdersYet,
                        svg: 'assets/empty_orders.svg',
                      )
                    : ListView.separated(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 10.h,
                        ),
                        itemCount: model.orders!.length,
                        itemBuilder: (context, pos) {
                          Order order = model.orders![pos];
                          num? orderPromocodePrice = model.getPromocodePrice(
                              order); // GETS promocode price for this order
                          num? orderTotalPriceWithPromocode =
                              model.getTotalOrderSumWithPromocode(
                                  order); // GETS total order price with promocode price subtracted
                          String orderStatusText = '';
                          switch (order.status) {
                            case 1:
                              orderStatusText = LocaleKeys.orderWaiting.tr();
                              break;
                            case 2:
                              orderStatusText = LocaleKeys.orderAccepted.tr();
                              break;
                            case 3:
                              orderStatusText = order.selfPickUp!
                                  ? LocaleKeys.orderReady.tr()
                                  : LocaleKeys.orderSent.tr();
                              break;
                            case 4:
                              orderStatusText = order.selfPickUp!
                                  ? LocaleKeys.orderTaken.tr()
                                  : LocaleKeys.orderDelivered.tr();
                              break;
                            default:
                              break;
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                                dividerTheme: DividerThemeData(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                              ),
                              // DateFormat('dd-MM-yyyy HH:mm').format(deliveryTime!.toLocal())
                              child: ClipRRect(
                                borderRadius: AppTheme().radius16,
                                child: ExpansionTile(
                                  // backgroundColor: kcSecondaryLightColor,
                                  // collapsedBackgroundColor:
                                  //     kcSecondaryLightColor,
                                  initiallyExpanded:
                                      order.status == 2 || order.status == 1,
                                  title: SizedBox(),
                                  onExpansionChanged: (value) {
                                    printLog('onExpansionChanged()');
                                  },
                                  //// have to use SizedBox in leading bc of tileWidth issue
                                  leading: SizedBox(
                                    width: 0.7.sw,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/clock_light.svg',
                                                  width: 18.w,
                                                ),
                                                SizedBox(width: 5.w),
                                                order.deliveryTime == null
                                                    ? Text(
                                                        LocaleKeys.now,
                                                        style: ktsDefault14Text,
                                                      ).tr()
                                                    : Text(
                                                        DateFormat(
                                                                'HH:mm, dd.MM.yyyy')
                                                            .format(order
                                                                .deliveryTime!
                                                                .toLocal()),
                                                        style: ktsDefault14Text,
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  //------------------ ORDER PRICE and STATUS  ---------------------//
                                  trailing: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${order.promocode != null ? formatNum(orderTotalPriceWithPromocode) : formatNum(order.dostawkaPrice != null ? (order.totPrice! + order.dostawkaPrice!) : order.totPrice!)} TMT',
                                        style: ktsDefault18SemiBoldText,
                                      ),
                                      SizedBox(height: 2.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 7.w,
                                          vertical: 1.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: AppTheme().radius5,
                                          color: kcSecondaryLightColor,
                                        ),
                                        child: Text(
                                          orderStatusText,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: kcFontColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    //------------------ INNER PART ---------------------//
                                    //------------------ DRIVER and DELIVERY ---------------------//
                                    if (!order.selfPickUp!)
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            15.w, 10.h, 15.w, 5.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              LocaleKeys.driver,
                                              style: ktsDefault16Text,
                                            ).tr(),
                                            order.selfPickUp!
                                                ? Text(
                                                    '-',
                                                    style: ktsDefault16Text,
                                                  )
                                                : order.status == 1
                                                    ? Text(
                                                        LocaleKeys
                                                            .notAssignedYet,
                                                        style: ktsDefault16Text,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ).tr()
                                                    : order.driver == null ||
                                                            (order.driver!
                                                                        .mobile ==
                                                                    null ||
                                                                order
                                                                    .driver!
                                                                    .mobile!
                                                                    .isEmpty)
                                                        ? SizedBox()
                                                        : Text(
                                                            order.driver!
                                                                .mobile!,
                                                            style:
                                                                ktsDefault16Text,
                                                          ),
                                          ],
                                        ),
                                      ),
                                    if (!order.selfPickUp!)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              LocaleKeys.deliveryPrice,
                                              style: ktsDefault16Text,
                                            ).tr(),
                                            order.selfPickUp!
                                                ? Text(
                                                    '0 TMT',
                                                    style: ktsDefault16Text,
                                                  )
                                                : order.status == 1
                                                    ? Text(
                                                        LocaleKeys
                                                            .notAssignedYet,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        style: ktsDefault16Text,
                                                      ).tr()
                                                    : order.dostawkaPrice ==
                                                            null
                                                        ? SizedBox()
                                                        : Text(
                                                            '${formatNum(order.dostawkaPrice!)} TMT',
                                                            style:
                                                                ktsDefault16Text,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  style: ktsDefault16Text,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${formatNum(order.totPrice!)} TMT -${formatNum(orderPromocodePrice)} TMT',
                                              style: ktsDefault16Text,
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(height: 15.h),
                                    //------------------ ORDER MEAL LIST ---------------------//
                                    Column(
                                      children:
                                          order.orderItems!.map((_orderItem) {
                                        String? _orderItemConcatenatedText =
                                            model.getConcatenateVolsCustoms(
                                                _orderItem);

                                        return Padding(
                                          padding: EdgeInsets.only(
                                            left: 16.w,
                                            bottom: 5.h,
                                            right: 15.w,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _orderItem
                                                          .mealJson!.name!,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: ktsDefault16Text,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${formatNum(_orderItem.quantity!)} x ${formatNum(_orderItem.price!)} TMT',
                                                    style: ktsDefault16Text,
                                                  ),
                                                ],
                                              ),
                                              //------------------ OrderItem concatenated text ---------------------//
                                              if (_orderItem.volumePrices!
                                                      .isNotEmpty ||
                                                  _orderItem.costumizedMeals!
                                                      .isNotEmpty)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 10.w,
                                                    bottom: 0.h,
                                                    top: 2.h,
                                                  ),
                                                  child: Text(
                                                    _orderItemConcatenatedText!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: kts14HelperText,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    //------------------ ORDER BUTTON ---------------------//
                                    if (order.status != 4)
                                      SizedBox(height: 5.h),
                                    if (order.status != 4)
                                      SizedBox(
                                        width: 1.sw,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 10.h),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  AppTheme.MAIN_DARK,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      AppTheme().radius10),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 11.h),
                                            ),
                                            child: order.status == 3
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      !order.selfPickUp!
                                                          ? Text(
                                                              LocaleKeys.driver,
                                                              style:
                                                                  ktsButton18Text,
                                                            ).tr()
                                                          : Text(
                                                              LocaleKeys
                                                                  .selfPickUp,
                                                              style:
                                                                  ktsButton18Text,
                                                            ).tr(),
                                                      if (!order.selfPickUp!)
                                                        Text(
                                                          ' ${order.driver!.mobile}',
                                                          style:
                                                              ktsButton18Text,
                                                        ).tr(),
                                                    ],
                                                  )
                                                // : order.status == 4
                                                //     ? Text(
                                                //         LocaleKeys.reOrder,
                                                //         style: ktsButton18Text,
                                                //       ).tr()
                                                : model.busy(order.id) &&
                                                        order.status == 1
                                                    ? ButtonLoading()
                                                    : Text(
                                                        LocaleKeys.cancelOrder,
                                                        style: ktsButton18Text,
                                                      ).tr(),
                                            onPressed: () async {
                                              switch (order.status) {
                                                case 1:
                                                  await model
                                                      .showCancelWaitingOrderDialog(
                                                    order.id!,
                                                    () async {
                                                      showErrorFlashBar(
                                                        context: context,
                                                        msg: LocaleKeys
                                                            .orderCancelSuccess
                                                            .tr(),
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
                                                  await model
                                                      .showCancelAcceptedOrderDialog();
                                                  break;
                                                case 3:
                                                  if (!order.selfPickUp!)
                                                    await model
                                                        .makePhoneCallToDriver(
                                                            order.driver!
                                                                .mobile!);
                                                  break;
                                                case 4:
                                                  break;
                                                default:
                                                  break;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 0.5,
                            color: AppTheme.DRAWER_DIVIDER,
                          );
                        },
                      ),
          ),
        );
      },
      viewModelBuilder: () => OrderViewModel(),
    );
  }
}
