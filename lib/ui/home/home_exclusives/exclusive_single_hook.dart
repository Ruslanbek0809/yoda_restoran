import 'package:flutter/material.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/ui/home/home_exclusives/exclusive_single_view_model.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExclusiveSingleHook
    extends HookViewModelWidget<ExclusiveSingleViewModel> {
  final ExclusiveSingle exclusiveSingle;
  const ExclusiveSingleHook({required this.exclusiveSingle, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, ExclusiveSingleViewModel model) {
    double itemWidth = (1.sw - 12.w - 20.h) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth + 0.15.sh; // 0.32.sw is for item height

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 150,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.fromLTRB(48, 16, 16,
                16), // left padding 48 moves title a bit to give a size for leading back icon
            // centerTitle: true,
            title: Text(
              'Maslahat beryaris',
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Container(
              child: ListTile(
            title: Text("${index}a"),
          ));
        }, childCount: 25))
        //------------------ ARROW BACK ---------------------//
        // SliverAppBar(
        //   expandedHeight: 0.55.sh,
        //   pinned: true,
        //   stretch: true,
        //   floating: false,
        //   backgroundColor: AppTheme.WHITE,
        //   centerTitle: true,
        //   title: SizedBox(),
        //   leading: AnimatedSwitcher(
        //     duration: Duration(milliseconds: 300),
        //     child: Container(
        //       height: 50.w,
        //       width: 50.w,
        //       margin: EdgeInsets.only(left: 10.w, top: 5.w),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: kcWhiteColor,
        //         // color: model.isShrink ? Colors.transparent : AppTheme.WHITE,
        //         // boxShadow: _isShrink ? [] : [AppTheme().buttonShadow],
        //       ),
        //       child: Material(
        //         color: kcWhiteColor,
        //         // color: model.isShrink ? Colors.transparent : kcWhiteColor,
        //         shape: CircleBorder(),
        //         elevation: 0,
        //         child: InkWell(
        //           customBorder: CircleBorder(),
        //           onTap: () => Navigator.pop(context),
        //           child: Icon(
        //             Icons.arrow_back,
        //             size: 27.w,
        //             color: AppTheme.BLACK,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        //   actions: [],
        // ),
//------------------ MEAL LIST ---------------------//
        // SliverPadding(
        //   padding: EdgeInsets.only(
        //       bottom: 0.11.sh), // COMPENSATES ResDetailsBottomCart height
        //   sliver: SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //       (BuildContext context, int index) {
        //         final resCategory = model.resCategories![index];
        //         final resCategoryMeals = resCategory.meals;
        //         return Column(
        //           children: [
        //             Container(
        //               alignment: Alignment.centerLeft,
        //               padding: EdgeInsets.only(left: 12.w, top: 5.h),
        //               child: Text(
        //                 resCategory.resCategoryModel!.name!,
        //                 style: TextStyle(
        //                   fontSize: 16.sp,
        //                   color: kcSecondFontColor,
        //                 ),
        //               ),
        //             ),

        //             // Container(
        //             //   alignment: Alignment.centerLeft,
        //             //   padding: EdgeInsets.only(left: 12.w, top: 12.h),
        //             //   child: Text(
        //             //     resCategory.resCategoryModel!.name!,
        //             //     style: TextStyle(
        //             //       fontSize: 22.sp,
        //             //       fontWeight: FontWeight.bold,
        //             //       color: AppTheme.MAIN_DARK,
        //             //     ),
        //             //   ),
        //             // ),
        //             GridView.builder(
        //               shrinkWrap: true,
        //               physics: NeverScrollableScrollPhysics(),
        //               padding: EdgeInsets.symmetric(
        //                 vertical: 12.h,
        //                 horizontal: 10.w,
        //               ),
        //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                 crossAxisCount: 2,
        //                 mainAxisSpacing: 10.h, //spaceTopBottom
        //                 crossAxisSpacing: 6.w, //spaceLeftRight
        //                 childAspectRatio: itemWidth / itemHeight,
        //               ),
        //               itemCount: resCategoryMeals!.length,
        //               itemBuilder: (context, pos) {
        //                 return MealView(
        //                   meal: resCategoryMeals[pos],
        //                   restaurant:
        //                       restaurant, // Needed for add meal with conditions only in CART
        //                 );
        //               },
        //             ),
        //           ],
        //         );
        //       },
        //       childCount: model.resCategories!.length,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
