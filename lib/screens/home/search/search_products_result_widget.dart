// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../home.dart';

// class SearchProductsResultWidget extends StatefulWidget {
//   final String searchName;

//   const SearchProductsResultWidget({required this.searchName});

//   @override
//   _SearchProductsResultWidgetState createState() =>
//       _SearchProductsResultWidgetState();
// }

// class _SearchProductsResultWidgetState
//     extends State<SearchProductsResultWidget> {
//   final _refreshController = RefreshController();

//   // SearchProvider get _searchPvd =>
//   //     Provider.of<SearchProvider>(context, listen: false);

//   @override
//   void dispose() {
//     _refreshController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double leftRightPaddings = 12.5.w;
//     final double itemWidth = 0.5.sw -
//         leftRightPaddings; // width for each image subtracted by lr paddings
//     final double textHeight = 0.26.sw;
//     return Consumer<SearchProvider>(
//       builder: (_, model, __) {
//         final _products = model.products;

//         if (_products == null) {
//           return LoadingWidget();
//         }

//         if (_products.isEmpty) {
//           return ErrorEmptyWidgett(onTap: () {}, show: false, isEmpty: true);
//         }

//         return SmartRefresher(
//           header: MaterialClassicHeader(
//             backgroundColor: AppTheme.MAIN,
//           ),
//           controller: _refreshController,
//           enablePullUp: !model.isProductsEnd,
//           enablePullDown: false,
//           onRefresh: () => _searchPvd.refreshProducts(),
//           onLoading: () => _searchPvd.loadProducts(
//               searchText: widget.searchName, controller: _refreshController),
//           footer: kCustomFooter(context),
//           child: GridView.builder(
//             physics: BouncingScrollPhysics(),
//             padding: EdgeInsets.symmetric(
//                 vertical: getDeviceType() == MyConstants.PHONE ? 15.w : 7.w,
//                 horizontal: getDeviceType() == MyConstants.PHONE ? 5.w : 3.w),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               childAspectRatio: itemWidth / (itemWidth + textHeight),
//               crossAxisCount: getDeviceType() == MyConstants.PHONE ? 2 : 4,
//               mainAxisSpacing: 10.0, //spaceTopBottom
//               crossAxisSpacing: 10.0, //spaceLeftRight
//             ),
//             itemCount: _products.length,
//             itemBuilder: (context, pos) {
//               final product = _products[pos];
//               return ProductWidget(product: product);
//             },
//           ),
//         );
//       },
//     );
//   }
// }
