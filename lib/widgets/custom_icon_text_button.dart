import 'package:flutter/material.dart';
import '../utils/utils.dart';

class CustomIconTextButton extends StatelessWidget {
  final String text;
  final Color color;
  final Widget icon;
  final Function onPressed;
  CustomIconTextButton(
      {required this.text,
      this.color = AppTheme.MAIN,
      required this.icon,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: icon,
      label: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
      onPressed: onPressed as void Function(),
    );
  }
}
