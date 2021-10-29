import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoda_res/utils/utils.dart';

import '../cart.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.WHITE,
        elevation: 0,
        leadingWidth: 35.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppTheme.FONT_COLOR,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
        itemCount: foodList.length,
        itemBuilder: (context, pos) {
          return CartWidget(food: foodList[pos]);
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
