// import 'package:flutter/material.dart';

// class RestaurantDetailsScreen extends StatefulWidget {
//   const RestaurantDetailsScreen({Key? key}) : super(key: key);

//   @override
//   _RestaurantDetailsScreenState createState() =>
//       _RestaurantDetailsScreenState();
// }

// class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

import 'dart:math' as math;
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yoda_res/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SamplePage extends StatefulWidget {
  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 250.0;

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabs = <String>[
    "Ertirki",
    "Abetky",
    "Ortanky",
  ];
  late TabController _tabController;
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });
  }

  final ValueNotifier<double> _titlePaddingNotifier =
      ValueNotifier(SamplePage._kBasePadding);

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (_scrollController.hasClients) {
      return min(
          SamplePage._kBasePadding + kCollapsedPadding,
          SamplePage._kBasePadding +
              (kCollapsedPadding * _scrollController.offset) /
                  (SamplePage.kExpandedHeight - kToolbarHeight));
    }

    return SamplePage._kBasePadding;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: SamplePage.kExpandedHeight,
              floating: false,
              pinned: true,
              primary: true,
              flexibleSpace: MyFlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                centerTitle: false,
                title: ValueListenableBuilder(
                  valueListenable: _titlePaddingNotifier,
                  builder: (context, value, child) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: double.parse(value.toString())),
                      child: Text("Kebapcy"),
                    );
                  },
                ),
                background: Container(color: Colors.green),
                // titlePadding:
                //     EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                // foreground: SizedBox(),
                titlePaddingTween: EdgeInsetsTween(
                    begin: EdgeInsets.only(left: 16.0, bottom: 40),
                    end: EdgeInsets.only(
                        left: 16.0,
                        bottom:
                            16)), // begin is when appBar is fully expanded and end is when appBar is collapsed
              ),
            ),
            SliverAppBar(
              expandedHeight: 50.w,
              floating: false,
              pinned: true,
              automaticallyImplyLeading:
                  false, // Used for removing back buttoon.
              title: TabBar(
                controller: _tabController,
                // These are the widgets to put in each tab in the tab bar.
                tabs: _tabs.map((String name) => Tab(text: name)).toList(),
              ),
            ),
            // SliverPersistentHeader(
            //   pinned: true,
            //   floating: true,
            //   delegate: ContestTabHeader(
            //     categoriesWidget: Container(
            //       color: Colors.white,
            //       child: TabBar(
            //         controller: _tabController,
            //         // These are the widgets to put in each tab in the tab bar.
            //         tabs: _tabs.map((String name) => Tab(text: name)).toList(),
            //       ),
            //     ),
            //     size: 50.w,
            //   ),
            // ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          // These are the contents of the tab views, below the tabs.
          children: _tabs.map((String tab) {
            return ListView(
              children: [
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: Text(tab),
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.red,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MyFlexibleSpaceBar extends StatefulWidget {
  const MyFlexibleSpaceBar({
    Key? key,
    required this.title,
    // required this.foreground,
    required this.background,
    required this.centerTitle,
    this.titlePadding,
    required this.titlePaddingTween,
    this.collapseMode = CollapseMode.parallax,
    this.stretchModes = const <StretchMode>[StretchMode.zoomBackground],
  })  : assert(collapseMode != null),
        super(key: key);

  /// The primary contents of the flexible space bar when expanded.
  ///
  /// Typically a [Text] widget.
  final Widget title;
  // final Widget foreground;

  /// Shown behind the [title] when expanded.
  ///
  /// Typically an [Image] widget with [Image.fit] set to [BoxFit.cover].
  final Widget background;

  /// Whether the title should be centered.
  ///
  /// By default this property is true if the current target platform
  /// is [TargetPlatform.iOS] or [TargetPlatform.macOS], false otherwise.
  final bool centerTitle;

  /// Collapse effect while scrolling.
  ///
  /// Defaults to [CollapseMode.parallax].
  final CollapseMode collapseMode;

  /// Stretch effect while over-scrolling.
  ///
  /// Defaults to include [StretchMode.zoomBackground].
  final List<StretchMode> stretchModes;

  /// Defines how far the [title] is inset from either the widget's
  /// bottom-left or its center.
  ///
  /// Typically this property is used to adjust how far the title is
  /// is inset from the bottom-left and it is specified along with
  /// [centerTitle] false.
  ///
  /// By default the value of this property is
  /// `EdgeInsetsDirectional.only(start: 72, bottom: 16)` if the title is
  /// not centered, `EdgeInsetsDirectional.only(start: 0, bottom: 16)` otherwise.
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsTween? titlePaddingTween;
  @override
  _MyFlexibleSpaceBarState createState() => _MyFlexibleSpaceBarState();
}

class _MyFlexibleSpaceBarState extends State<MyFlexibleSpaceBar> {
  bool _getEffectiveCenterTitle(ThemeData theme) {
    if (widget.centerTitle != null) return widget.centerTitle;
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
  }

  Alignment _getTitleAlignment(bool effectiveCenterTitle) {
    if (effectiveCenterTitle) return Alignment.bottomCenter;
    final TextDirection textDirection = Directionality.of(context);
    assert(textDirection != null);
    switch (textDirection) {
      case TextDirection.rtl:
        return Alignment.bottomRight;
      case TextDirection.ltr:
        return Alignment.bottomLeft;
    }
  }

  double _getCollapsePadding(double t, FlexibleSpaceBarSettings settings) {
    switch (widget.collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent);
      case CollapseMode.none:
        return 0.0;
      case CollapseMode.parallax:
        final double deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final FlexibleSpaceBarSettings? settings = context
          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
      assert(
        settings != null,
        'A FlexibleSpaceBar must be wrapped in the widget returned by FlexibleSpaceBar.createSettings().',
      );
      final List<Widget> children = <Widget>[];
      final double deltaExtent = settings!.maxExtent - settings.minExtent;
// 0.0 -> Expanded
// 1.0 -> Collapsed to toolbar
      final double t =
          (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0);
// background
      if (widget.background != null) {
        final double fadeStart =
            math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const double fadeEnd = 1.0;
        assert(fadeStart <= fadeEnd);
        final double opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
        double height = settings.maxExtent;
// StretchMode.zoomBackground
        if (widget.stretchModes.contains(StretchMode.zoomBackground) &&
            constraints.maxHeight > height) {
          height = constraints.maxHeight;
        }
        children.add(Positioned(
          top: _getCollapsePadding(t, settings),
          left: 0.0,
          right: 0.0,
          height: height,
          child: Opacity(
// IOS is relying on this semantics node to correctly traverse
// through the app bar when it is collapsed.
            alwaysIncludeSemantics: true,
            opacity: opacity,
            child: widget.background,
          ),
        ));
// StretchMode.blurBackground
        if (widget.stretchModes.contains(StretchMode.blurBackground) &&
            constraints.maxHeight > settings.maxExtent) {
          final double blurAmount =
              (constraints.maxHeight - settings.maxExtent) / 10;
          children.add(Positioned.fill(
              child: BackdropFilter(
                  child: Container(
                    color: Colors.transparent,
                  ),
                  filter: ui.ImageFilter.blur(
                    sigmaX: blurAmount,
                    sigmaY: blurAmount,
                  ))));
        }
      }
// title
      if (widget.title != null) {
        final ThemeData theme = Theme.of(context);
        Widget title;
        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            title = widget.title;
            break;
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            title = Semantics(
              namesRoute: true,
              child: widget.title,
            );
            break;
        }
// StretchMode.fadeTitle
        if (widget.stretchModes.contains(StretchMode.fadeTitle) &&
            constraints.maxHeight > settings.maxExtent) {
          final double stretchOpacity = 1 -
              (((constraints.maxHeight - settings.maxExtent) / 100)
                  .clamp(0.0, 1.0));
          title = Opacity(
            opacity: stretchOpacity,
            child: title,
          );
        }
        final double opacity = settings.toolbarOpacity;
        if (opacity > 0.0) {
          TextStyle? titleStyle = theme.primaryTextTheme.headline6;
          titleStyle = titleStyle!
              .copyWith(color: titleStyle.color!.withOpacity(opacity));
          final bool effectiveCenterTitle = _getEffectiveCenterTitle(theme);
          final padding = widget.titlePadding ??
              widget.titlePaddingTween?.transform(t) ??
              EdgeInsetsDirectional.only(
                start: effectiveCenterTitle ? 0.0 : 72.0,
                bottom: 16.0,
              );
          final double scaleValue =
              Tween<double>(begin: 1.5, end: 1.0).transform(t);
          final Matrix4 scaleTransform = Matrix4.identity()
            ..scale(scaleValue, scaleValue, 1.0);
          final Alignment titleAlignment =
              _getTitleAlignment(effectiveCenterTitle);
          children.add(Container(
            padding: padding,
            child: Transform(
              alignment: titleAlignment,
              transform: scaleTransform,
              child: Align(
                alignment: titleAlignment,
                child: DefaultTextStyle(
                  style: titleStyle,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      width: constraints.maxWidth / scaleValue,
                      alignment: titleAlignment,
                      child: title,
                    );
                  }),
                ),
              ),
            ),
          ));
        }
      }
      // children.add(widget.foreground);
      return ClipRect(child: Stack(children: children));
    });
  }
}
