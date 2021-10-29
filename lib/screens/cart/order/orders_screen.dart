import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/utils.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orderList = [
    Order(1, 'Kebapçy', 123, OrderStatus(1, 'Garaşylýar'), foodList),
    Order(2, 'Hotdost', 80, OrderStatus(2, 'Kabul edildi'), foodList),
    Order(3, 'Palawkom', 123, OrderStatus(3, 'Ugradyldy'), foodList),
    Order(4, 'Burger Zone', 80, OrderStatus(4, 'Eltildi'), foodList),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.WHITE,
        elevation: 1,
        leadingWidth: 35.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppTheme.FONT_COLOR,
              size: 25,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Sargytlar',
          style: TextStyle(
            color: AppTheme.MAIN_DARK,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.w),
        itemCount: orderList.length,
        itemBuilder: (context, pos) {
          return Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              dividerTheme: DividerThemeData(
                  color: Theme.of(context).colorScheme.background),
            ),
            child: ExpansionTile(
              initiallyExpanded: false,
              title: SizedBox(),
              onExpansionChanged: (value) {
                printLog('onExpansionChanged()');
              },
              //// have to user SizedBox in leading
              leading: SizedBox(
                width: 0.7.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderList[pos].restaurantName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppTheme.FONT_COLOR,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.w),
                    //------------------ DATE and STATUS ---------------------//
                    Row(
                      children: [
                        Text(
                          '9 Ýanwar, 2021',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppTheme.FONT_COLOR,
                          ),
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
                  ],
                ),
              ),
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
                  SizedBox(height: 5.w),
                  Text(
                    orderList[pos].orderPrice.toString() + ' TMT',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.transparent,
                      fontWeight: FontWeight.w600,
                    ),
                  ), // Text widget is used to make UI look alike Figma UI
                ],
              ),
              children: orderList[pos]
                  .foodList
                  .map((orderFood) => Padding(
                        padding: EdgeInsets.only(
                          left: 30.w,
                          bottom: 5.w,
                          right: 15.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          );
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 7.w),
            child: Divider(
              thickness: 1,
              color: AppTheme.DRAWER_DIVIDER,
            ),
          );
        },
      ),
    );
  }
}
