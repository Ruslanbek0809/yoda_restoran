import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'about_us_view_model.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AboutUsViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.navToHomeByRemovingAll(); // Workaround
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kcWhiteColor,
            elevation: 0.5,
            leadingWidth: 35.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: kcFontColor,
                  size: 25.w,
                ),
                onPressed: model.navToHomeByRemovingAll,
              ),
            ),
            centerTitle: true,
            title: Text(
              LocaleKeys.about_us,
              style: kts22DarkText,
            ).tr(),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Text(
                    LocaleKeys.aboutUsHello,
                    style: kts18Text,
                  ).tr(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 15.h),
                  child: Text(
                    LocaleKeys.aboutUsContent,
                    style: kts18Text,
                  ).tr(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 15.h),
                  child: Text(
                    LocaleKeys.aboutUsBonApetite,
                    style: kts18Text,
                  ).tr(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w, top: 24.h),
                  child: Divider(color: kcDividerColor),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 24.w,
                    top: 10.h,
                    bottom: 10.h,
                    right: 16.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.about_us_terms_of_use,
                        style: kts16IconBoldText,
                      ).tr(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20.sp,
                        color: kcIconColor,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Divider(color: kcDividerColor),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => AboutUsViewModel(),
    );
  }
}
