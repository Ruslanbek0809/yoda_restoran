import 'package:flutter/material.dart';

class ScrollableColumn extends StatelessWidget {
  const ScrollableColumn(
      {Key? key,
      this.controller,
      required this.children,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.textDirection,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.mainAxisSize = MainAxisSize.max,
      this.verticalDirection = VerticalDirection.down,
      this.textBaseline})
      : super(key: key);
  final ScrollController? controller;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Column(
              children: children,
              crossAxisAlignment: crossAxisAlignment,
              textDirection: textDirection,
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              verticalDirection: verticalDirection,
              textBaseline: textBaseline,
            ),
          ),
        ),
      ],
    );
  }
}
