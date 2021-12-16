import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Horizontal Spacing: Use const when there is not flutter_screenutil package
Widget horizontalSpaceTiny = SizedBox(width: 5.w);
Widget horizontalSpaceSmall = SizedBox(width: 10.w);
Widget horizontalSpaceRegular = SizedBox(width: 18.w);
Widget horizontalSpaceMedium = SizedBox(width: 25.w);
Widget horizontalSpaceLarge = SizedBox(width: 50.w);

// Vertical Spacing
Widget verticalSpaceTiny = SizedBox(height: 5.h);
Widget verticalSpaceSmall = SizedBox(height: 10.h);
Widget verticalSpaceRegular = SizedBox(height: 18.h);
Widget verticalSpaceMedium = SizedBox(height: 25.h);
Widget verticalSpaceLarge = SizedBox(height: 50.h);

// Screen Size helpers
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;

/// Radiuses
final kbr20 = BorderRadius.circular(20.0);
final kbr15 = BorderRadius.circular(15.0);
final kbr12 = BorderRadius.circular(12.0);
final kbr10 = BorderRadius.circular(10.0);
final kbr5 = BorderRadius.circular(5.0);
