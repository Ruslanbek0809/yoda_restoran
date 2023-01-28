import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/shared.dart';
import '../../restaurant/restaurant_view.dart';
import '../../widgets/widgets.dart';
import '../../../models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'single_ex_view_model.dart';

class SingleExReachText extends ViewModelWidget<SingleExViewModel> {
  final ExclusiveSingle singleEx;
  const SingleExReachText({required this.singleEx, Key? key})
      : super(key: key, reactive: true);
  @override
  Widget build(BuildContext context, SingleExViewModel model) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _TransitionAppBarDelegate(
            title: model.isBusy || model.hasError
                ? ''
                : singleEx.name ??
                    '', // for test: 'Birini alana 2 nji mugt aksiya edyas gelda'
            extent: model.isBusy || model.hasError ? 66.h : 0.175.sh,
            singleExViewModel: model,
          ),
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
                : SliverPadding(
                    padding: EdgeInsets.only(
                      top: 0.h,
                      bottom: 0.11.sh, // COMPENSATES SingleExBottomCart
                    ), // Changes based on exclusive part
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int pos) {
                          final seRich = model.seRiches[pos];
                          return seRich.restaurant != null
                              ? RestaurantView(
                                  restaurant: seRich.restaurant!,
                                )
                              : Html(
                                  data: seRich.richText,
                                  style: {
                                    "body": Style(
                                        margin: EdgeInsets.zero,
                                        padding:
                                            EdgeInsets.zero), // GENERAL BODY
                                    "p": Style(
                                        margin: EdgeInsets.fromLTRB(
                                            16.w, 0.h, 16.w, 10.h),
                                        padding: EdgeInsets.zero), // NORMAL
                                    "pre": Style(
                                        margin: EdgeInsets.fromLTRB(
                                            16.w, 0.h, 16.w, 10.h),
                                        padding: EdgeInsets.zero), // FORMATTED
                                    "h1": Style(
                                        margin: EdgeInsets.fromLTRB(
                                            16.w, 0.h, 16.w, 10.h),
                                        padding: EdgeInsets.zero),
                                    "h2": Style(
                                        margin: EdgeInsets.fromLTRB(
                                            16.w, 0.h, 16.w, 10.h),
                                        padding: EdgeInsets.zero),
                                    "h3": Style(
                                        margin: EdgeInsets.fromLTRB(
                                            16.w, 0.h, 16.w, 10.h),
                                        padding: EdgeInsets.zero),
                                    "h4": Style(
                                        margin: EdgeInsets.fromLTRB(
                                            16.w, 0.h, 16.w, 10.h),
                                        padding: EdgeInsets.zero),
                                  },
                                  onLinkTap: (url, _, __, ___) async {
                                    final Uri launchUri = Uri(
                                      scheme: 'https',
                                      path: url,
                                    );
                                    await launchUrl(launchUri);
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
                                    return null;
                                  },
                                );
                        },
                        childCount: model.seRiches.length,
                      ),
                    ),
                  ),
      ],
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  final _titleMarginTween = EdgeInsetsTween(
    begin: EdgeInsets.only(bottom: 5.h, left: 16.w, right: 16.w),
    end: EdgeInsets.only(left: 48.w, right: 48.w, top: 32.h),
  );
  final _leftIconMarginTween = EdgeInsetsTween(
    begin: EdgeInsets.only(bottom: 18.h),
    end: EdgeInsets.only(top: 27.h),
  );
  final _rightIconMarginTween = EdgeInsetsTween(
    begin: EdgeInsets.only(bottom: 18.h),
    end: EdgeInsets.only(top: 27.h),
  );

  final _titleAlignTween =
      AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft);
  final _leftIconAlignTween =
      AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft);
  final _rightIconAlignTween =
      AlignmentTween(begin: Alignment.bottomRight, end: Alignment.topRight);

  final String title;
  final double extent;
  final SingleExViewModel singleExViewModel;

  _TransitionAppBarDelegate(
      {required this.title,
      this.extent = 250,
      required this.singleExViewModel});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double tempVal = 50 * maxExtent / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;

    final titleMargin = _titleMarginTween
        .lerp(progress); // for animated title change 1.0 to progress

    final rightIconMargin = _rightIconMarginTween
        .lerp(1.0); // for animated title change 1.0 to progress
    final leftIconMargin = _leftIconMarginTween
        .lerp(1.0); // for animated icon change 1.0 to progress

    final titleAlign = _titleAlignTween.lerp(progress);
    final leftIconAlign = _leftIconAlignTween
        .lerp(1.0); // for animated title change 1.0 to progress
    final rightIconAlign = _rightIconAlignTween
        .lerp(1.0); // for animated icon change 1.0 to progress

    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 65.h,
          constraints: BoxConstraints(maxHeight: minExtent),
          color: kcWhiteColor,
        ),
        Padding(
          padding: leftIconMargin,
          child: Align(
            alignment: leftIconAlign,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Platform.isIOS
                    ? Icons.arrow_back_ios_rounded
                    : Icons.arrow_back_rounded,
                size: 22.w,
                color: kcFontColor,
                // color: progress < 0.4 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        Padding(
          padding: titleMargin,
          child: Align(
            alignment: titleAlign,
            child: Text(
              title,
              // 'Birini alana 2nji gaty beter mugt indi nm edeli',
              maxLines: shrinkOffset > tempVal ? 1 : 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: kcFontColor,
                // color: progress < 0.4 ? Colors.white : Colors.black,
                fontSize: 20.sp + (4 * (1 - progress)),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: rightIconMargin,
          child: Align(
            alignment: rightIconAlign,
            child: IconButton(
              onPressed: singleExViewModel.createDynamicLink,
              icon: Icon(
                Icons.share_rounded,
                size: 22.w,
                color: kcFontColor,
                // color: progress < 0.4 ? Colors.white : Colors.black,
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
  double get minExtent => extent;

  @override
  bool shouldRebuild(_TransitionAppBarDelegate oldDelegate) {
    return title != oldDelegate.title;
  }
}
