library scrollable_list_tabview;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'scrollable_list_tab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Duration _kScrollDuration = const Duration(milliseconds: 150);
const EdgeInsetsGeometry _kTabMargin =
    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0);

const SizedBox _kSizedBoxW8 = const SizedBox(width: 8.0);

class ScrollableListTabView extends StatefulWidget {
  /// Create a new [ScrollableListTabView]
  const ScrollableListTabView(
      {Key? key,
      required this.tabs,
      this.tabHeight = kToolbarHeight,
      this.tabAnimationDuration = _kScrollDuration,
      this.bodyAnimationDuration = _kScrollDuration,
      this.tabAnimationCurve = Curves.decelerate,
      this.bodyAnimationCurve = Curves.decelerate})
      : assert(tabAnimationDuration != null, bodyAnimationDuration != null),
        assert(tabAnimationCurve != null, bodyAnimationCurve != null),
        assert(tabHeight != null),
        assert(tabs != null),
        super(key: key);

  /// List of tabs to be rendered.
  final List<ScrollableListTab> tabs;

  /// Height of the tab at the top of the view.
  final double tabHeight;

  /// Duration of tab change animation.
  final Duration tabAnimationDuration;

  /// Duration of inner scroll view animation.
  final Duration bodyAnimationDuration;

  /// Animation curve used when animating tab change.
  final Curve tabAnimationCurve;

  /// Animation curve used when changing index of inner [ScrollView]s.
  final Curve bodyAnimationCurve;

  @override
  _ScrollableListTabViewState createState() => _ScrollableListTabViewState();
}

class _ScrollableListTabViewState extends State<ScrollableListTabView> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);

  final ItemScrollController _bodyScrollController = ItemScrollController();
  final ItemPositionsListener _bodyPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController _tabScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    _bodyPositionsListener.itemPositions.addListener(_onInnerViewScrolled);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.tabHeight,
          margin:
              const EdgeInsets.only(bottom: 5.0), //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 2.0,
              ),
            ],
          ),
          child: ScrollablePositionedList.builder(
            itemCount: widget.tabs.length,
            scrollDirection: Axis.horizontal,
            itemScrollController: _tabScrollController,
            padding: EdgeInsets.symmetric(vertical: 2.5),
            itemBuilder: (context, index) {
              var tab = widget.tabs[index].tab;
              return ValueListenableBuilder<int>(
                  valueListenable: _index,
                  builder: (_, i, __) {
                    var selected = index == i;
                    var borderColor = selected
                        ? tab.activeBackgroundColor
                        : Colors.transparent;
                    return Container(
                      height: 35.w,
                      margin: _kTabMargin,
                      decoration: BoxDecoration(
                          color: selected
                              ? tab.activeBackgroundColor
                              : tab.inactiveBackgroundColor,
                          borderRadius: tab.borderRadius),
                      child: OutlinedButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                selected ? Colors.white : Colors.grey),
                            backgroundColor: MaterialStateProperty.all(selected
                                ? tab.activeBackgroundColor
                                : tab.inactiveBackgroundColor),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            side: MaterialStateProperty.all(BorderSide(
                              width: 1,
                              color: borderColor,
                            )),
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: tab.borderRadius))),
                        child: _buildTab(index),
                        onPressed: () => _onTabPressed(index),
                      ),
                    );
                  });
            },
          ),
        ),
        Expanded(
          child: ScrollablePositionedList.builder(
            itemScrollController: _bodyScrollController,
            itemPositionsListener: _bodyPositionsListener,
            itemCount: widget.tabs.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: _kTabMargin.add(const EdgeInsets.all(5.0)),
                  child: _buildInnerTab(index),
                ),
                Flexible(
                  child: widget.tabs[index].body,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInnerTab(int index) {
    var tab = widget.tabs[index].tab;
    var textStyle = TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold);
    return Builder(
      builder: (_) {
        if (tab.icon == null) return tab.innerLabel;
        if (!tab.showIconOnList)
          return DefaultTextStyle(style: textStyle, child: tab.innerLabel);
        return DefaultTextStyle(
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [tab.icon!, _kSizedBoxW8, tab.innerLabel],
          ),
        );
      },
    );
  }

  Widget _buildTab(int index) {
    var tab = widget.tabs[index].tab;
    if (tab.icon == null) return tab.tabLabel;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [tab.icon!, _kSizedBoxW8, tab.tabLabel],
    );
  }

  void _onInnerViewScrolled() async {
    var positions = _bodyPositionsListener.itemPositions.value;

    /// Target [ScrollView] is not attached to any views and/or has no listeners.
    if (positions == null || positions.isEmpty) return;

    /// Capture the index of the first [ItemPosition]. If the saved index is same
    /// with the current one do nothing and return.
    var firstIndex =
        _bodyPositionsListener.itemPositions.value.elementAt(0).index;
    if (_index.value == firstIndex) return;

    /// A new index has been detected.
    await _handleTabScroll(firstIndex);
  }

  Future<void> _handleTabScroll(int index) async {
    _index.value = index;
    await _tabScrollController.scrollTo(
        index: _index.value,
        duration: widget.tabAnimationDuration,
        curve: widget.tabAnimationCurve);
  }

  /// When a new tab has been pressed both [_tabScrollController] and
  /// [_bodyScrollController] should notify their views.
  void _onTabPressed(int index) async {
    await _tabScrollController.scrollTo(
        index: index,
        duration: widget.tabAnimationDuration,
        curve: widget.tabAnimationCurve);
    await _bodyScrollController.scrollTo(
        index: index,
        duration: widget.bodyAnimationDuration,
        curve: widget.bodyAnimationCurve);
    _index.value = index;
  }

  @override
  void dispose() {
    _bodyPositionsListener.itemPositions.removeListener(_onInnerViewScrolled);
    return super.dispose();
  }
}
