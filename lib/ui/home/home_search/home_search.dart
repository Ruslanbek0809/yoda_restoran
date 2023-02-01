import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import '../home_view_model.dart';

class HomeSearch extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          right: 10.r,
          left: getValueForScreenType<double>(
            context: context,
            mobile: 0.r,
            tablet: 10.r,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 12.r),
        decoration: BoxDecoration(
          borderRadius: AppTheme().radius20,
          color: Theme.of(context).cardColor,
          boxShadow: [AppTheme().searchShadow],
        ),
        child: InkWell(
          onTap: model.navToHomeSearchView,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                LocaleKeys.search,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: kcSecondaryFontColor,
                ),
              ).tr(),
              Icon(
                CupertinoIcons.search,
                size: 22.sp,
                color: kcFontColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
