import 'package:flutter/material.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class ViewErrorWidget extends StatelessWidget {
  final Function? modelCallBack;
  ViewErrorWidget({this.modelCallBack});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          YodaImage(
            image: 'assets/error.jpg',
            height: 0.4.sh,
            width: 0.7.sw,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              LocaleKeys.smthWentWrong,
              style: kts18ErrorText,
              textAlign: TextAlign.center,
            ).tr(),
          ),
          SizedBox(height: 35.h),
          SizedBox(
            width: 0.7.sw,
            child: CustomTextChildButton(
              child: Text(LocaleKeys.reload, style: kts18Text).tr(),
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
