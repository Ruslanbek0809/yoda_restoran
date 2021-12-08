import 'package:flutter/material.dart';

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader({
    required this.child,
    required this.size,
  });
  final Widget child;
  final double size;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
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
