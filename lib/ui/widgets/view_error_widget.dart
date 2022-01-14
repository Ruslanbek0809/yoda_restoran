import 'package:flutter/material.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';

class ViewErrorWidget extends StatelessWidget {
  final Function? modelCallBack;
  ViewErrorWidget({this.modelCallBack});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Näsazlyk ýüze çykdy. Täzeden synanşyň!',
              style: kts18Text,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: 0.7.sw,
            child: CustomTextChildButton(
              child: Text('Täzele', style: kts18Text),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              borderRadius: kbr15,
              color: kcSecondaryLightColor,
              onPressed: () {
                modelCallBack!();
              },
            ),
          ),
        ],
      ),
    );
  }
}
