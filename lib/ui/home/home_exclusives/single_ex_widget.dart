import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/restaurant/restaurant_view.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';
import 'package:yoda_res/utils/utils.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'single_ex_view_model.dart';

class SingleExWidget extends ViewModelWidget<SingleExViewModel> {
  final ExclusiveSingle singleEx;
  const SingleExWidget({required this.singleEx, Key? key})
      : super(key: key, reactive: true);
  @override
  Widget build(BuildContext context, SingleExViewModel model) {
    double itemWidth = (1.sw - 12.w - 20.h) / 2;
    // (screenwidth - Gridview crossAxisSpacing * 2 - Gridview mainAxisSpacing * 2) / crossAxisCount
    double itemHeight = itemWidth + 0.15.sh; // 0.32.sw is for item height

    return CustomScrollView(
      slivers: [
        // SliverPersistentHeader(
        //   pinned: true,
        //   delegate: _TransitionAppBarDelegate(
        //     title: 'Maslahat beryaris',
        //     extent: 250,
        //   ),
        // ),

        SliverAppBar(
          expandedHeight: model.isBusy || model.hasError ? 0.05.sh : 0.175.sh,
          pinned: true,
          stretch: true,
          backgroundColor: AppTheme.WHITE,
          leading: BackButtonWidget(),
          flexibleSpace: model.isBusy || model.hasError
              ? SizedBox()
              : FlexibleSpaceBar(
                  titlePadding: EdgeInsets.fromLTRB(54.w, 16.h, 16.w,
                      12.h), // left padding 54.w moves title a bit to give a size for leading back icon
                  title: Text(
                    singleEx.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: kts20DarkText,
                  ),
                ),
          //------------------ ACTIONS FAV ---------------------//
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.share,
                size: 24.w,
                color: kcSecondaryDarkColor,
              ),
            )
          ],
        ),
        model.isBusy
            ? SliverToBoxAdapter(
                child: Padding(
                padding: EdgeInsets.only(top: 0.4.sh),
                child: LoadingWidget(),
              ))
            : model.hasError
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.2.sh),
                      child: ViewErrorWidget(
                        modelCallBack: () async => await model.initialise(),
                      ),
                    ),
                  )
                :
                // SliverList(
                //     delegate: SliverChildBuilderDelegate((context, index) {
                //     return Container(
                //         child: ListTile(
                //       title: Text("${index}a"),
                //     ));
                //   }, childCount: 25)),
                SliverPadding(
                    padding: EdgeInsets.only(
                      top: 0.h,
                      bottom: 0.11.sh, // COMPENSATES HomeBottomCart
                    ), // Changes based on exclusive part
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int pos) {
                          final seRich = model.seRiches[pos];
                          return

                              // seRich restaurant widget
                              seRich.restaurant != null
                                  ? RestaurantView(
                                      restaurant: seRich.restaurant!,
                                    )
                                  // seRich reachText widget
                                  : Html(
                                      data: seRich.richText,
                                      // shrinkWrap: true,
                                      style: {
                                        "body": Style(
                                            margin: EdgeInsets.zero,
                                            padding: EdgeInsets.zero),
                                        "p": Style(
                                            fontSize: FontSize(14.sp),
                                            margin: EdgeInsets.fromLTRB(
                                                16.w, 0.h, 16.w, 10.h),
                                            padding: EdgeInsets.zero),
                                      },
                                      onLinkTap: (url, _, __, ___) async {
                                        final Uri launchUri = Uri(
                                          scheme: 'https',
                                          path: url,
                                        );
                                        await launch(launchUri.toString());
                                      },
                                      onImageTap: (src, _, __, ___) {
                                        print(src);
                                      },
                                      onImageError: (exception, stackTrace) {
                                        print(exception);
                                      },
                                      onCssParseError: (css, messages) {
                                        print("css that errored: $css");
                                        print("error messages:");
                                        messages.forEach((element) {
                                          print(element);
                                        });
                                      },
                                    );
                        },
                        childCount: model.seRiches.length,
                      ),
                    ),
                  ),
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

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  final _titleMarginTween = EdgeInsetsTween(
    begin: EdgeInsets.only(bottom: 20),
    end: EdgeInsets.only(left: 64.0, top: 45.0),
  );

  final _rightIconMarginTween = EdgeInsetsTween(
    begin: EdgeInsets.only(bottom: 20),
    end: EdgeInsets.only(top: 45.0),
  );

  final _titleAlignTween =
      AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.topLeft);
  final _rightIconAlignTween =
      AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft);
  final _iconAlignTween =
      AlignmentTween(begin: Alignment.bottomRight, end: Alignment.topRight);

  final String title;
  final double extent;

  _TransitionAppBarDelegate({required this.title, this.extent = 250});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 72 * maxExtent / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;

    final titleMargin = _titleMarginTween.lerp(progress);
    final rightIconMargin = _rightIconMarginTween.lerp(progress);

    final avatarAlign = _titleAlignTween.lerp(progress);
    final rightIconAlign = _rightIconAlignTween.lerp(progress);
    final iconAlign = _iconAlignTween.lerp(progress);

    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 80,
          constraints: BoxConstraints(maxHeight: minExtent),
          color: Colors.white,
        ),
        Padding(
          padding: rightIconMargin,
          child: Align(
            alignment: rightIconAlign,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                  // color: progress < 0.4 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: titleMargin,
          child: Align(
            alignment: avatarAlign,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                // color: progress < 0.4 ? Colors.white : Colors.black,
                fontSize: 18 + (5 * (1 - progress)),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: titleMargin,
          child: Align(
            alignment: iconAlign,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.black,
                  // color: progress < 0.4 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(_TransitionAppBarDelegate oldDelegate) {
    return title != oldDelegate.title;
  }
}
