import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../shared/shared.dart';
import '../../../utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_search_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeSearchHook extends HookViewModelWidget<HomeSearchViewModel> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget buildViewModelWidget(BuildContext context, HomeSearchViewModel model) {
    model.log.v('buildViewModelWidget CALLED');
    final _searchController = useTextEditingController(text: model.searchText);

    // final update = useValueListenable(_searchController);
    // useEffect(() {
    //   _searchController = update;
    // }, [update]);
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
            color: kcSecondaryDarkColor,
          ),
          decoration: InputDecoration(
            fillColor: kcWhiteColor,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: LocaleKeys.search.tr(),
            hintStyle: kts14HelperText,
          ),
          controller: _searchController,
          autofocus: true,
          onChanged: (value) => _debouncer.run(() {
                model.startMainSearch(value);
              }),
          onSubmitted: (value) =>
              _debouncer.run(() => model.startMainSearch(value))),
    );
  }
}
