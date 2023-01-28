import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import 'main_cat_all_item_hook.dart';
import 'main_cat_filter_item_hook.dart';
import 'main_cat_item_hook.dart';
import 'main_cat_view_model.dart';

class MainCatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainCatViewModel>.nonReactive(
      builder: (context, model, child) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Row(
            children: [
              //*----------------- FILTER MAIN CAT (NOTE: Manually added) ---------------------//
              if ((model.mainCats ?? []).isNotEmpty) MainCatFilterItemHook(),
              //*----------------- Fetched MAIN CATS ---------------------//
              if ((model.mainCats ?? []).isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: model.mainCats!
                      .take(10)
                      .map(
                        (mainCategory) =>
                            MainCatItemHook(mainCategory: mainCategory),
                      )
                      .toList(), // mainCategories!.take(10) is used to take only 6 from the list
                ),
              //*----------------- ALL MAIN CAT (NOTE: Manually added) ---------------------//
              if ((model.mainCats ?? []).isNotEmpty) MainCatAllItemHook(),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => MainCatViewModel(),
    );
  }
}
