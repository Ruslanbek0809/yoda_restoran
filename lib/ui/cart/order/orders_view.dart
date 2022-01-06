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
                    return Padding(
                      padding: EdgeInsets.only(top: 5.w),
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
                                      ' - ${orderList[pos].orderStatus.name}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppTheme.STATUS_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                // if (orderList[pos].orderStatus.id == 3)
                                //   Text(
                                //     'Sürüji: Sultan +993 64 687171',
                                //     style: TextStyle(
                                //       fontSize: 14.sp,
                                //       color: AppTheme.STATUS_COLOR,
                                //     ),
                                //   ),
                              ],
                            ),
                          ),
                          //------------------ PROMOCODE ---------------------//
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                orderList[pos].orderPrice.toString() + ' TMT',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppTheme.FONT_COLOR,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //------------------ INNER PART ---------------------//
                            //------------------ DRIVER and DELIVERY ---------------------//
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 5.h),
                              child: Text(
                                'Sürüji: +993 64 687171',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppTheme.FONT_COLOR,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Eltip bermek tölegi:',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                  Text(
                                    '20 TMT',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppTheme.FONT_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            //------------------ ORDER PRODUCT LIST ---------------------//
                            Column(
                              children: orderList[pos]
                                  .foodList
                                  .map((orderFood) => Padding(
                                        padding: EdgeInsets.only(
                                          left: 35.w,
                                          bottom: 5.w,
                                          right: 15.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              orderFood.name,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: AppTheme.FONT_COLOR,
                                              ),
                                            ),
                                            Text(
                                              '1 x ${orderFood.price} TMT',
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: AppTheme.FONT_COLOR,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 35.w, bottom: 5.w),
                              child: Text(
                                '+ Ajy sos',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppTheme.DRAWER_ICON,
                                ),
                              ),
                            ),
                            //------------------ ORDER BUTTON ---------------------//
                            SizedBox(
                              width: 1.sw,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 10.w),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppTheme.MAIN_DARK,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: AppTheme().radius10),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.w),
                                  ),
                                  child: Text(
                                    orderList[pos].orderStatus.id == 3
                                        ? 'Sürüji: Sultan +993 64 687171'
                                        : orderList[pos].orderStatus.id == 4
                                            ? 'Täzeden sargyt et'
                                            : 'Sargydy ýatyr',
                                    style: TextStyle(
                                      color: AppTheme.WHITE,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  onPressed: () {
                                    //------------------ onPressed() ---------------------//
                                    if (orderList[pos].orderStatus.id == 1) {
                                      Navigator.of(context)
                                          .pushNamed(RouteList.rateUs);
                                    } else if (orderList[pos].orderStatus.id ==
                                        2) {
                                      if (!Platform.isIOS)
                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              'Sargyt taýýarlanýar',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color:
                                                    AppTheme.DIALOG_TITLE_COLOR,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            content: Text(
                                              'Sargydy ýatyrmak üçin restorana jaň ediň!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppTheme.FONT_COLOR,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                      else
                                        showCupertinoDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) =>
                                              CupertinoAlertDialog(
                                            title: Text(
                                              'Sargyt taýýarlanylýar',
                                              style: TextStyle(
                                                color:
                                                    AppTheme.DIALOG_TITLE_COLOR,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            content: Text(
                                              'Sargydy ýatyrmak üçin restorana jaň ediň!',
                                              style: TextStyle(
                                                color: AppTheme.FONT_COLOR,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                    } else if (orderList[pos].orderStatus.id ==
                                        3) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: AppTheme().radius20,
                                          ),
                                          title: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/circle_wavy_check.svg',
                                                color: AppTheme.MAIN,
                                                width: 120.w,
                                                height: 120.w,
                                              ),
                                              SizedBox(height: 10.w),
                                              Text(
                                                'Soltan Restoran',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppTheme.MAIN,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              )
                                            ],
                                          ),
                                          content: Text(
                                            'Siziň sargydyňyz kabul edildi!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.GREEN_COLOR,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (orderList[pos].orderStatus.id ==
                                        4) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: AppTheme().radius20,
                                          ),
                                          title: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/delivery.svg',
                                                color: AppTheme.MAIN,
                                                width: 90.w,
                                                height: 90.w,
                                              ),
                                              SizedBox(height: 15.h),
                                              Text(
                                                'Soltan Restoran',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppTheme.MAIN,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              )
                                            ],
                                          ),
                                          content: Text(
                                            'Siziň sargydyňyz ugradyldy.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.GREEN_COLOR,
                                            ),
                                          ),
                                        ),
                                      );
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
