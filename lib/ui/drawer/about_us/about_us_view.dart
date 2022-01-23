import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../../utils/utils.dart';
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
            backgroundColor: AppTheme.WHITE,
            elevation: 0.5,
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
              LocaleKeys.about_us,
              style: ktsDefault22DarkText,
            ).tr(),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.aboutUsHello,
                  style: kts18Text,
                ).tr(),
                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Text(
                    LocaleKeys.aboutUsContent,
                    style: kts18Text,
                  ).tr(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Text(
                    LocaleKeys.aboutUsBonApetite,
                    style: kts18Text,
                  ).tr(),
                ),
                Spacer(),
                Divider(color: kcDividerColor),
                Padding(
                  padding: EdgeInsets.only(top: 7.h, bottom: 20.h),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/phone.svg',
                        color: kcContactColor,
                        width: 25.w,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        '+99364 687171',
                        style: kts16ContactText,
                      ),
                    ],
                  ),
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
