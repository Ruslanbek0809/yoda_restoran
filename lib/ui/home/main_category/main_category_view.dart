import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/ui/home/main_category/main_category_item.dart';
import 'main_category_view_model.dart';

class MainCategoryView extends StatelessWidget {
  final List<MainCategory>? mainCategories;
  const MainCategoryView({Key? key, this.mainCategories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainCategoryViewModel>.nonReactive(
      builder: (context, model, child) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: mainCategories!.map((mainCategory) {
            return MainCategoryItem(mainCategory: mainCategory);
          }).toList(),
        ),
      ),
      viewModelBuilder: () => MainCategoryViewModel(),
    );
  }
}
