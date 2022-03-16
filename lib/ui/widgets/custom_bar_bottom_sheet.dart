import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoda_res/shared/shared.dart';
import '../../utils/utils.dart';

class CustomBarBottomSheet extends StatelessWidget {
  final Widget child;
  const CustomBarBottomSheet({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --------------- BOTTOM SHEET DRAGGER -------------- //
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                height: 5,
                width: 48,
                decoration: BoxDecoration(
                    color: kcWhiteColor,
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
            // --------------- BODY Part -------------- //
            Expanded(
              child: Material(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constants.BORDER_RADIUS_20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Constants.BORDER_RADIUS_20),
                    ),
                    color: kcWhiteColor,
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
