import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:yoda_res/library/flutter_datetime_picker.dart';
import 'package:yoda_res/screens/home/home.dart';
import '../../utils/utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.WHITE,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: AppTheme.WHITE,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: AppTheme.FONT_COLOR,
            size: 25.w,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.WHITE,
          borderRadius: AppTheme().containerRadius,
        ),
        padding: EdgeInsets.only(top: 5.w, left: 25.w, right: 25.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
