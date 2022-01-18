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
            appBar: MyAppbar(
              child: AppBar(
                backgroundColor: AppTheme.WHITE,
                elevation: 1,
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
                            horizontal: 5.w, vertical: 10.w),
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
                              orderStatusText = LocaleKeys.orderSent.tr();
                              break;
                            case 4:
                              orderStatusText = LocaleKeys.orderDelivered.tr();
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
                              child: ExpansionTile(
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
                                      Text(
                                        order.restaurant!.name!,
                                        style: ktsDefault18SemiBoldText,
                                      ),
                                      SizedBox(height: 5.h),
                                      //------------------ DATE and STATUS ---------------------//
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat('dd.MM.yyyy')
                                                .format(order.deliveryTime!),
                                            style: ktsDefault14Text,
                                          ),
                                          Text(
                                            ' - $orderStatusText',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppTheme.STATUS_COLOR,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //------------------ PROMOCODE ---------------------//
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${order.promocode != null ? orderTotalPriceWithPromocode.toInt() : order.totPrice!.toInt()} TMT',
                                      style: ktsDefault18SemiBoldText,
                                    ),
                                    Expanded(child: SizedBox()),
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
                                          Text(
                                            order.selfPickUp!
                                                ? '-'
                                                : order.status == 1
                                                    ? 'Bellenmedi'
                                                    : order.driver!.mobile!,
                                            style: ktsDefault16Text,
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
                                                      LocaleKeys.notAssignedYet,
                                                      style: ktsDefault16Text,
                                                    ).tr()
                                                  : Text(
                                                      '${order.dostawkaPrice!.toInt()} TMT',
                                                      style: ktsDefault16Text,
                                                    ),
                                        ],
                                      ),
                                    ),
                                  if (!order.selfPickUp!) SizedBox(height: 5.h),
                                  //------------------ PROMOCODE PART ---------------------//
                                  if (order.promocode != null)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 10.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/percent.svg',
                                                color: AppTheme.MAIN_DARK,
                                                width: 22.w,
                                              ),
                                              SizedBox(width: 7.w),
                                              Text(
                                                '${order.promocode!.name}',
                                                style: ktsDefault16Text,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${order.totPrice!.toInt()} TMT -${orderPromocodePrice.toInt()} TMT',
                                            style: ktsDefault16Text,
                                          ),
                                        ],
                                      ),
                                    ),
                                  //------------------ ORDER PRODUCT LIST ---------------------//
                                  Column(
                                    children:
                                        order.orderItems!.map((_orderItem) {
                                      String? _orderItemConcatenatedText =
                                          model.getConcatenateVolsCustoms(
                                              _orderItem);

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: 35.w,
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
                                                Text(
                                                  _orderItem.mealJson!.name!,
                                                  style: ktsDefault16Text,
                                                ),
                                                Text(
                                                  '${_orderItem.quantity!.toInt()} x ${_orderItem.price!.toInt()} TMT',
                                                  style: ktsDefault16Text,
                                                ),
                                              ],
                                            ),
                                            //------------------ OrderItem concatenated text ---------------------//
                                            if (_orderItem
                                                    .volumePrices!.isNotEmpty ||
                                                _orderItem.costumizedMeals!
                                                    .isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 10.w,
                                                  bottom: 5.h,
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
                                    SizedBox(
                                      width: 1.sw,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 10.h),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: AppTheme.MAIN_DARK,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    AppTheme().radius10),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12.h),
                                          ),
                                          child: order.status == 3
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                        style: ktsButton18Text,
                                                      ).tr(),
                                                  ],
                                                )
                                              // : order.status == 4
                                              //     ? Text(
                                              //         LocaleKeys.reOrder,
                                              //         style: ktsButton18Text,
                                              //       ).tr()
                                              : Text(
                                                  LocaleKeys.cancelOrder,
                                                  style: ktsButton18Text,
                                                ).tr(),
                                          onPressed: () async {
                                            switch (order.status) {
                                              case 1:
                                                await model
                                                    .showCancelWaitingOrderDialog();
                                                break;
                                              case 2:
                                                await model
                                                    .showCancelAcceptedOrderDialog();
                                                break;
                                              case 3:
                                                if (!order.selfPickUp!)
                                                  await model
                                                      .makePhoneCallToDriver(
                                                          order
                                                              .driver!.mobile!);
                                                break;
                                              case 4:
                                                await model
                                                    .showCancelWaitingOrderDialog();
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
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 1,
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
