import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'main_cat_all_item_hook.dart';
import 'main_cat_item_hook.dart';
import 'main_cat_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainCatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainCatViewModel>.nonReactive(
      builder: (context, model, child) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: model.mainCats!.take(10).map((mainCategory) {
              return model.mainCats!.indexOf(mainCategory) !=
                      model.mainCats!.take(10).length - 1
                  ? MainCatItemHook(mainCategory: mainCategory)
                  : MainCatAllItemHook();
            }).toList(), // mainCategories!.take(6) is used to take only 6 from the list
          ),
        ),
      ),
      viewModelBuilder: () => MainCatViewModel(),
    );
  }
}
