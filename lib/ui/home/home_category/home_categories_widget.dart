import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../utils/utils.dart';
import 'home_category.dart';

class HomeCategoriesWidget extends StatelessWidget {
  final List<HomeCategory> homeCategories;
  const HomeCategoriesWidget({Key? key, required this.homeCategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: homeCategories.mapIndexed((category, pos) {
          return HomeCategoryWidget(
            homeCategory: category,
            pos: pos,
            homeCatLength: homeCategories.length,
          );
        }).toList(),
      ),
    );
  }
}
