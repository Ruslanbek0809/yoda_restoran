// TODO: Can be deleted

// import 'package:flutter/material.dart';
// import 'package:yoda_res/utils/utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class HomeSearchScreen extends SearchDelegate<String> {
//   HomeSearchScreen();

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         padding: EdgeInsets.only(right: 10.w),
//         icon: Icon(
//           Icons.clear,
//           size: 25.w,
//           color: AppTheme.DRAWER_DIVIDER,
//         ),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(
//         Icons.arrow_back_ios,
//         size: 20.w,
//         color: AppTheme.FONT_COLOR,
//       ),
//       onPressed: () {
//         // close(context, null); // Closes the search page and returns to the underlying route
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Container(height: 0, width: 0);
//   }

//   @override
//   String get searchFieldLabel => '';

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return SizedBox();
//   }

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return theme.copyWith(
//       appBarTheme: AppBarTheme(
//         backgroundColor: AppTheme.WHITE,
//         elevation: 0.5,
//       ),
//       textTheme: TextTheme(
//         headline6: TextStyle( 
//           fontSize: 18.sp,
//           fontWeight: FontWeight.normal,
//           color: AppTheme.MAIN_DARK,
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         border: InputBorder.none,
//         errorBorder: InputBorder.none,
//         enabledBorder: InputBorder.none,
//         focusedBorder: InputBorder.none,
//       ),
//     );
//   }
// }
