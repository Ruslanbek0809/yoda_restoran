import 'dart:io';

import 'package:flutter/material.dart';
import 'utils.dart';

enum FormValidation { phoneInvalid }

/// Platform Types
final bool isIos = Platform.isIOS;
final bool isAndroid = Platform.isAndroid;

/// Logging
const kLOG_TAG = '[Belent Online]';
const kLOG_ENABLE = true;
void printLog(dynamic data) {
  if (kLOG_ENABLE) {
    // final now = DateTime.now().toUtc().toString().split(' ').last;
    // debugPrint('[$now]$kLOG_TAG${data.toString()}');
    debugPrint('${data.toString()}');
  }
}

/// Device Type
String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
  printLog('getDeviceType(): ${data.size.shortestSide}');
  return data.size.shortestSide < 600 ? Constants.PHONE : Constants.TABLET;
}

/// Hex Color
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}


/// Keyboard Actions
// KeyboardActionsConfig buildKeyboardActionsConfig(
//     BuildContext context, List<FocusNode> list) {
//   String currentLang =
//       Provider.of<LangProvider>(context, listen: false).currentLang;
//   return KeyboardActionsConfig(
//     keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
//     keyboardBarColor: Colors.grey[200],
//     nextFocus: true,
//     actions: list
//         .map((e) => KeyboardActionsItem(focusNode: e, toolbarButtons: [
//               (node) {
//                 return GestureDetector(
//                   onTap: () => node.unfocus(),
//                   child: Container(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       i18n(currentLang, ki18nKbrdClose),
//                       style: TextStyle(
//                           color: AppTheme.textColor,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ),
//                 );
//               },
//             ]))
//         .toList(),
//   );
// }

// ScrollableListTabView(
          //   tabHeight: 48,
          //   bodyAnimationDuration: const Duration(milliseconds: 300),
          //   tabAnimationCurve: Curves.ease,
          //   tabAnimationDuration: const Duration(milliseconds: 300),
          //   bodyAnimationCurve: Curves.linear,
          //   tabs: [
          //     ScrollableListTab(
          //         tab: ListTab(
          //             tabLabel: Text('Label 1'),
          //             innerLabel: Text('Label 1'),
          //             icon: Icon(Icons.group)),
          //         body: ListView.builder(
          //           shrinkWrap: true,
          //           physics: NeverScrollableScrollPhysics(),
          //           itemCount: 10,
          //           itemBuilder: (_, index) => ListTile(
          //             leading: Container(
          //               height: 40,
          //               width: 40,
          //               decoration: BoxDecoration(
          //                   shape: BoxShape.circle, color: Colors.grey),
          //               alignment: Alignment.center,
          //               child: Text(index.toString()),
          //             ),
          //             title: Text('List element $index'),
          //           ),
          //         )),
          //     ScrollableListTab(
          //         tab: ListTab(
          //             tabLabel: Text('Label 1'),
          //             innerLabel: Text('Label 1'),
          //             icon: Icon(Icons.group)),
          //         body: ListView.builder(
          //           shrinkWrap: true,
          //           physics: NeverScrollableScrollPhysics(),
          //           itemCount: 10,
          //           itemBuilder: (_, index) => ListTile(
          //             leading: Container(
          //               height: 40,
          //               width: 40,
          //               decoration: BoxDecoration(
          //                   shape: BoxShape.circle, color: Colors.grey),
          //               alignment: Alignment.center,
          //               child: Text(index.toString()),
          //             ),
          //             title: Text('List element $index'),
          //           ),
          //         )),
          //   ],
          // ),