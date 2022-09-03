import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';
import 'circle_progress_bar.dart';
import 'each_intro_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingWidget extends StatefulWidget {
  final List<EachIntroWidget> introductionList;

  final Function onTapSkipButton;

  OnBoardingWidget({
    Key? key,
    required this.introductionList,
    required this.onTapSkipButton,
  }) : super(key: key);

  @override
  _OnBoardingWidgetState createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  double progressPercent = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          PageView(
            physics: ClampingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: widget.introductionList,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Container(
          //       alignment: Alignment.topRight,
          //       child: TextButton(
          //         onPressed: () => widget.onTapSkipButton(),
          //         child: Text(
          //           'Skip',
          //           style: TextStyle(color: Colors.black, fontSize: 20),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Positioned(
            bottom: 0.075.sh,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70.w,
                  height: 70.w,
                  child: CircleProgressBar(
                    backgroundColor: kcSecondaryLightColor.withOpacity(0.25),
                    foregroundColor: kcPrimaryColor,
                    value: ((_currentPage + 1) *
                        1.0 /
                        widget.introductionList.length),
                  ),
                ),
                Container(
                  height: 55.w,
                  width: 55.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kcPrimaryColor,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _currentPage != widget.introductionList.length - 1
                          ? _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            )
                          : widget.onTapSkipButton();
                    },
                    icon: Icon(
                      _currentPage == widget.introductionList.length - 1
                          ? Icons.check_rounded
                          : Icons.arrow_forward_ios_rounded,
                      color: kcWhiteColor,
                    ),
                    iconSize: 20.w,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
