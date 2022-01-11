import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'order_view_model.dart';

class OrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
      onModelReady: (model) => model.getOrders(),
      builder: (context, model, child) => WillPopScope(
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
                'Sargytlarym',
                style: ktsDefault22DarkText,
              ),
            ),
          ),
          body: model.isBusy
              ? LoadingWidget()
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.w),
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
                        orderStatusText = 'Garaşylýar';
                        break;
                      case 2:
                        orderStatusText = 'Kabul edildi';
                        break;
                      case 3:
                        orderStatusText = 'Ugradyldy';
                        break;
                      case 4:
                        orderStatusText = 'Eltildi';
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
                              color: Theme.of(context).colorScheme.background),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                '${order.promocode != null ? orderTotalPriceWithPromocode : order.totPrice} TMT',
                                style: ktsDefault18SemiBoldText,
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //------------------ INNER PART ---------------------//
                            //------------------ DRIVER and DELIVERY ---------------------//
                            if (!order.selfPickUp!)
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 5.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sürüji:',
                                      style: ktsDefault16Text,
                                    ),
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
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Eltip bermek tölegi:',
                                      style: ktsDefault16Text,
                                    ),
                                    Text(
                                      order.selfPickUp!
                                          ? '0 TMT'
                                          : order.status == 1
                                              ? 'Bellenmedi'
                                              : '${order.dostawkaPrice.toString()} TMT',
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
                                      '${order.totPrice} TMT -$orderPromocodePrice TMT',
                                      style: ktsDefault16Text,
                                    ),
                                  ],
                                ),
                              ),
                            //------------------ ORDER PRODUCT LIST ---------------------//
                            Column(
                              children: order.orderItems!.map((_orderItem) {
                                String? _orderItemConcatenatedText =
                                    model.getConcatenateVolsCustoms(_orderItem);

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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _orderItem.mealJson!.name!,
                                            style: ktsDefault16Text,
                                          ),
                                          Text(
                                            '${_orderItem.quantity!.toInt()} x ${_orderItem.price} TMT',
                                            style: ktsDefault16Text,
                                          ),
                                        ],
                                      ),
                                      //------------------ OrderItem concatenated text ---------------------//
                                      if (_orderItem.volumePrices!.isNotEmpty ||
                                          _orderItem
                                              .costumizedMeals!.isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 10.w,
                                            bottom: 5.h,
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
                            //------------------ ORDER BUTTON ---------------------//
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
                                        borderRadius: AppTheme().radius10),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                  ),
                                  child: Text(
                                    order.status == 3
                                        ? 'Sürüji: ${order.driver!.mobile}'
                                        : order.status == 4
                                            ? 'Täzeden sargyt et'
                                            : 'Sargydy ýatyr',
                                    style: ktsButton18Text,
                                  ),
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
                                        await model.makePhoneCallToDriver(
                                            order.driver!.mobile!);
                                        break;
                                      case 4:
                                        // showDialog(
                                        //   context: context,
                                        //   barrierDismissible: true,
                                        //   builder: (context) => AlertDialog(
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius: AppTheme().radius20,
                                        //     ),
                                        //     title: Column(
                                        //       children: [
                                        //         SvgPicture.asset(
                                        //           'assets/delivery.svg',
                                        //           color: AppTheme.MAIN,
                                        //           width: 90.w,
                                        //           height: 90.w,
                                        //         ),
                                        //         SizedBox(height: 15.h),
                                        //         Text(
                                        //           'Soltan Restoran',
                                        //           textAlign: TextAlign.center,
                                        //           style: TextStyle(
                                        //             color: AppTheme.MAIN,
                                        //             fontSize: 22.sp,
                                        //             fontWeight:
                                        //                 FontWeight.normal,
                                        //           ),
                                        //         )
                                        //       ],
                                        //     ),
                                        //     content: Text(
                                        //       'Siziň sargydyňyz ugradyldy.',
                                        //       textAlign: TextAlign.center,
                                        //       style: TextStyle(
                                        //         fontSize: 18.sp,
                                        //         fontWeight: FontWeight.w600,
                                        //         color: AppTheme.GREEN_COLOR,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // );
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
      ),
      viewModelBuilder: () => OrderViewModel(),
    );
  }
}
