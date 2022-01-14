import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/shared/app_colors.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_search_view_model.dart';

class SearchBox extends HookViewModelWidget<HomeSearchViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, HomeSearchViewModel model) {
    final _searchController = useTextEditingController();
    return Container(
      decoration: BoxDecoration(
        color: kcWhiteColor,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      margin: EdgeInsets.symmetric(vertical: 5.h),
      child: TextField(
        style: TextStyle(
          fontSize: 18.sp,
          color: AppTheme.MAIN_DARK,
        ),
        decoration: InputDecoration(
          fillColor: AppTheme.WHITE,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
        ),
        controller: _searchController,
        autofocus: true,
        onChanged: model.startMainSearch,
        onSubmitted: model.startMainSearch,
      ),
    );
  }
}
