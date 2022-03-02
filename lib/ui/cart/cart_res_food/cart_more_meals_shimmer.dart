// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:yoda_res/ui/widgets/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CartMoreMealsShimmerWidget extends StatelessWidget {
//   const CartMoreMealsShimmerWidget({
//     Key? key,
//     required this.itemWidth,
//   }) : super(key: key);

//   final double itemWidth;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             ...List.generate(
//               4,
//               (pos) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: itemWidth * 0.9 + (0.26.sw) - 5.w,
//                       width: itemWidth * 0.95,
//                       margin: EdgeInsets.all(5.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         boxShadow: <BoxShadow>[
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 3.0,
//                           )
//                         ],
//                       ),
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           YodaImage(
//                             image: 'assets/ph_product.png',
//                 height: 0.33.sw,
//                 width: 0.33.sw,
//                             borderRadius: 10.0,
//                           ),
//                           Shimmer.fromColors(
//                             baseColor: Colors.grey[300]!,
//                             highlightColor: Colors.grey[100]!,
//                             child: Container(
//                               height: itemWidth * 0.9,
//                               width: itemWidth * 0.95,
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.4),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10.0)),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Shimmer.fromColors(
//                       baseColor: Colors.grey[200]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: Container(
//                         height: itemWidth * 0.05,
//                         width: itemWidth * 0.75,
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 1.0, horizontal: 5.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(Radius.circular(3.0)),
//                         ),
//                       ),
//                     ),
//                     Shimmer.fromColors(
//                       baseColor: Colors.grey[200]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: Container(
//                         height: itemWidth * 0.05,
//                         width: itemWidth * 0.9,
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 1.0, horizontal: 5.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(Radius.circular(3.0)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
