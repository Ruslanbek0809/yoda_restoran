import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/shared.dart';
import '../../utils/utils.dart';

class CustomBarBottomSheet extends StatelessWidget {
  final Widget child;
  final bool isMealBottomSheet;
  const CustomBarBottomSheet({
    Key? key,
    required this.child,
    this.isMealBottomSheet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //*-------------- BOTTOM SHEET DRAGGER -------------- //
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              height: 5,
              width: 48,
              decoration: BoxDecoration(
                  color: kcWhiteColor, borderRadius: BorderRadius.circular(6)),
            ),
          ),
          //*-------------- BODY Part -------------- //
          Expanded(
            child: Material(
              color: isMealBottomSheet ? kcSecondaryLightColor : kcWhiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constants.BORDER_RADIUS_20),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
