// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';
// import 'profile_view_model.dart';

// class ProfileGenderBottomSheetView extends StatelessWidget {
//   const ProfileGenderBottomSheetView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<ProfileViewModel>.reactive(
//       builder: (context, model, child) => Platform.isIOS
//           ? CupertinoActionSheet(
//               actions: <Widget>[
//                 CupertinoActionSheetAction(
//                   child: Text(
//                     'Erkek',
//                   ),
//                   onPressed: () {
//                     _genderController.text = 'Erkek';
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 CupertinoActionSheetAction(
//                   child: Text(
//                     'Aýal',
//                   ),
//                   onPressed: () {
//                     _genderController.text = 'Aýal';
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//               cancelButton: CupertinoActionSheetAction(
//                 isDestructiveAction: true,
//                 child: Text(
//                   'Ýap',
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             )
//           : BottomSheet(
//               onClosing: () {},
//               builder: (BuildContext context) {
//                 return Container(
//                   height: 186,
//                   child: ListView(
//                     children: <Widget>[
//                       ListTile(
//                         title: Center(
//                           child: Text(
//                             'Erkek',
//                           ),
//                         ),
//                         onTap: () {
//                           _genderController.text = 'Erkek';
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                       Divider(height: 8),
//                       ListTile(
//                         title: Center(
//                           child: Text(
//                             'Aýal',
//                           ),
//                         ),
//                         onTap: () {
//                           _genderController.text = 'Aýal';
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                       Divider(height: 8),
//                       ListTile(
//                         title: Center(
//                           child: Text(
//                             'Ýap',
//                             style: TextStyle(color: AppTheme.RED),
//                           ),
//                         ),
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//       viewModelBuilder: () => ProfileViewModel(),
//     );
//   }
// }
