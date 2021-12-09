// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:stacked_hooks/stacked_hooks.dart';
// import 'package:yoda_res/utils/utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class TestView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<TestViewModel>.reactive(
//       builder: (context, model, child) => Scaffold(body: TestWidget()),
//       viewModelBuilder: () => TestViewModel(),
//     );
//   }
// }

// class TestWidget extends HookViewModelWidget<TestViewModel> {
//   const TestWidget({Key? key}) : super(key: key, reactive: true);

//   @override
//   Widget buildViewModelWidget(BuildContext context, TestViewModel model) {
//     //-------------- CUSTOM SCROLL CONTROLLER ----------------//
//     final ScrollController _customScrollController = useScrollController();

//     /// To dispose a listener attached to ScrollController
//     useEffect(() {
//       void _customScrollListener() =>
//           model.updateLastScrollStatus(_customScrollController.hasClients &&
//               _customScrollController.offset >
//                   (0.55.sh - kToolbarHeight - 50.w));

//       _customScrollController.addListener(_customScrollListener);
//       return () =>
//           _customScrollController.removeListener(_customScrollListener);
//     }, [_customScrollController]); // _customScrollController, key, is specified

//     return CustomScrollView(
//       controller: _customScrollController,
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         SliverAppBar(
//           expandedHeight: 0.55.sh, // 55% of height of a screen
//           pinned: true,
//           backgroundColor: AppTheme.WHITE,
//           centerTitle: true,
//           title: AnimatedSwitcher(
//             duration: Duration(milliseconds: 300),
//             child: model.isShrink
//                 ? Padding(
//                     padding: EdgeInsets.only(left: 10, top: 5),
//                     child: Text(
//                       'Title',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   )
//                 : SizedBox(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TestViewModel extends BaseViewModel {
//   bool _isShrink = false;

//   bool get isShrink => _isShrink;

//   /// Function to change ACTIVE TAB
//   void updateLastScrollStatus(bool isReallyShrink) {
//     _isShrink = isReallyShrink;
//     notifyListeners();
//   }
// }
