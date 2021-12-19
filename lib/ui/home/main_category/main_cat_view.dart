import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/ui/home/main_category/main_cat_all_item.dart';
import 'package:yoda_res/ui/home/main_category/main_cat_item_hook.dart';
import 'main_cat_view_model.dart';

class MainCatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainCatViewModel>.nonReactive(
      builder: (context, model, child) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: model.mainCats!.take(6).map((mainCategory) {
            return model.mainCats!.indexOf(mainCategory) !=
                    model.mainCats!.take(6).length - 1
                ? MainCatItemHook(mainCategory: mainCategory)
                : MainCatAllItem();
          }).toList(), // mainCategories!.take(6) is used to take only 6 from the list
        ),
      ),
      viewModelBuilder: () => MainCatViewModel(),
    );
  }
}
