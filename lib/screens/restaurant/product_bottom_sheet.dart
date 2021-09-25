import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showProductBottomSheet(BuildContext context) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
    context: context,
    builder: (ctx) {
      return ProductBottomSheetWidget();
    },
  );
}

class ProductBottomSheetWidget extends StatefulWidget {
  ProductBottomSheetWidget();

  @override
  _ProductBottomSheetWidgetState createState() =>
      _ProductBottomSheetWidgetState();
}

class _ProductBottomSheetWidgetState extends State<ProductBottomSheetWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.93.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.w),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}
