import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/shared/app_colors.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'home_search_view_model.dart';

class HomeSearchHook extends HookViewModelWidget<HomeSearchViewModel> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget buildViewModelWidget(BuildContext context, HomeSearchViewModel model) {
    model.log.i('model.searchText: ${model.searchText}');

    final _searchController = useTextEditingController(text: model.searchText);
    if (model.searchText!.isEmpty) _searchController.clear();
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
        onChanged: (value) {
          _debouncer.run(() => model.startMainSearch(value));
        },
        onSubmitted: (value) {
          _debouncer.run(() => model.startMainSearch(value));
        },
      ),
    );
  }
}
