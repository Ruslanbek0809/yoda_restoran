import 'package:flutter/material.dart';

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader({
    required this.categoriesWidget,
    required this.size,
  });
  final Widget categoriesWidget;
  final double size;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return categoriesWidget;
  }

  @override
  double get maxExtent => size;

  @override
  double get minExtent => size;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
