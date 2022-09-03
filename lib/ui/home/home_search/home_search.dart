import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../home_view_model.dart';
import '../../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeSearch extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
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
                  color: kcSecondFontColor,
                ),
              ).tr(),
              Icon(
                CupertinoIcons.search,
                size: 22.w,
                color: kcFontColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
