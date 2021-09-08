// import 'package:flutter/material.dart';

// final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: MyWidget(),
//         ),
//       ),
//     );
//   }
// }

// class MyWidget extends StatefulWidget {
//   const MyWidget() : super();

//   @override
//   _MyWidgetState createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   int currTab = 0;
//   ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController()
//       ..addListener(() {
//         //print("offset = ${_scrollController.offset}");
//         currTab = (_scrollController.offset) ~/ (100 * 30);
//         print(currTab);
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _scrollController
//         .dispose(); // it is a good practice to dispose the controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 for (int i = 0; i < 5; i++)
//                   InkWell(
//                       child: Container(
//                           decoration: new BoxDecoration(
//                               color: i == currTab ? Colors.red : Colors.blue,
//                               borderRadius:
//                                   new BorderRadius.all(Radius.circular(10.0))),
//                           width: 100,
//                           child: Text(
//                             "Tab " + i.toString(),
//                             style: TextStyle(color: Colors.white),
//                             textAlign: TextAlign.center,
//                           )),
//                       onTap: () {
//                         _scrollController.jumpTo(i * (100 * 30).toDouble());
//                       })
//               ],
//             ),
//             Expanded(
//                 child: ListView(
//               controller: _scrollController,
//               children: <Widget>[
//                 for (int i = 0; i < 100; i++)
//                   Container(
//                       color: Colors.deepOrange,
//                       height: 30,
//                       child: Text("Content at 0 -" + i.toString())),
//                 for (int i = 0; i < 100; i++)
//                   Container(
//                       color: Colors.deepPurple,
//                       height: 30,
//                       child: Text("Content at 1 -" + i.toString())),
//                 for (int i = 0; i < 100; i++)
//                   Container(
//                       color: Colors.green,
//                       height: 30,
//                       child: Text("Content at 2 -" + i.toString())),
//                 for (int i = 0; i < 100; i++)
//                   Container(
//                       color: Colors.pink,
//                       height: 30,
//                       child: Text("Content at 3 -" + i.toString())),
//                 for (int i = 0; i < 100; i++)
//                   Container(
//                       color: Colors.grey,
//                       height: 30,
//                       child: Text("Content at 4 -" + i.toString())),
//               ],
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:yoda_res/yoda_res_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(YodaResApp());
}
