import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/utils/util_functions.dart';
import 'home_category.dart';
import 'home_category_view_model.dart';

class HomeCategoryView extends StatelessWidget {
  final List<Category> homeCategories;
  const HomeCategoryView({Key? key, required this.homeCategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeCategoryViewModel>.nonReactive(
      builder: (context, model, child) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: homeCategories.mapIndexed((category, pos) {
            return HomeCategory(
              homeCategory: category,
              pos: pos,
              homeCatLength: homeCategories.length,
            );
          }).toList(),
        ),
      ),
      viewModelBuilder: () => HomeCategoryViewModel(),
    );
  }
}
