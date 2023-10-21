import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:story_view/story_view.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';

import '../../../../models/models.dart';
import '../../../../utils/utils.dart';
import 'moment_story_view_model.dart';

class MomentStoryView extends StatefulWidget {
  final Restaurant restaurant;
  const MomentStoryView({required this.restaurant, Key? key}) : super(key: key);

  @override
  State<MomentStoryView> createState() => _MomentStoryViewState();
}

class _MomentStoryViewState extends State<MomentStoryView> {
  Restaurant get restaurant => widget.restaurant;

  final StoryController controller = StoryController();
  List<StoryItem> stories = [];

  @override
  void initState() {
    super.initState();
    restaurant.stories?.forEach((story) {
      if (story.file != null) {
        if (story.isImage!) {
          stories.add(StoryItem.pageImage(
            url: story.file!,
            controller: controller,
            duration: Duration(
              milliseconds: story.durationS != null
                  ? (story.durationS! * 1000).toInt()
                  : (5 * 1000).toInt(),
            ),
          ));
        } else {
          stories.add(
            StoryItem.pageVideo(
              story.file!,
              controller: controller,
              duration: Duration(
                milliseconds: story.durationS != null
                    ? (story.durationS! * 1000).toInt()
                    : (5 * 1000).toInt(),
              ),
            ),
          );
        }
      } else {
        stories.add(
          StoryItem.text(
            title: story.caption ?? '',
            textStyle: TextStyle(
              fontSize: 18.sp,
              color: story.captionColor != null
                  ? HexColor(story.captionColor!)
                  : kcFontColor,
            ),
            backgroundColor: story.backgroundColor != null
                ? HexColor(story.backgroundColor!)
                : kcPrimaryColor,
            duration: Duration(
              milliseconds: story.durationS != null
                  ? (story.durationS! * 1000).toInt()
                  : (5 * 1000).toInt(),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final safeTopPadding = MediaQuery.of(context).padding.top;
    final safeBottomPadding = MediaQuery.of(context).padding.bottom;

    return ViewModelBuilder<MomentStoryViewModel>.reactive(
      viewModelBuilder: () => MomentStoryViewModel(),
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: Stack(
              children: [
                //*----------------- MOMENTS ---------------------//
                StoryView(
                  storyItems: stories,
                  controller: controller,
                  onComplete: () {
                    Navigator.of(context).pop();
                  },
                  onVerticalSwipeComplete: (v) {
                    if (v == Direction.down) {
                      Navigator.pop(context);
                    }
                  },
                  onStoryShow: (storyItem) {
                    int pos = stories.indexOf(storyItem);

                    // the reason for doing setState only after the first
                    // position is becuase by the first iteration, the layout
                    // hasn't been laid yet, thus raising some exception
                    // (each child need to be laid exactly once)
                    if (pos > 0) {
                      setState(() {
                        // when = widget.stories![pos].when;
                      });
                    }
                  },
                ),
                //*----------------- YODA RESTORAN LOGO/TITLE ---------------------//
                Container(
                  padding: EdgeInsets.only(
                    top: safeTopPadding +
                        16 +
                        5 +
                        2, //* top safea are height + progress bar vertical padding + progress bar height + additional padding between progress bar and logo
                    left: 16,
                    right: 16,
                  ),
                  child: SvgPicture.asset(
                    'assets/yoda_restoran_stories.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
                //*----------------- SHADER EFFECT ---------------------//
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: safeBottomPadding +
                        24 +
                        48 +
                        24, //* bottom safea are height + bottom side height of button + button height + top side height of button
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.1)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          tileMode: TileMode.mirror,
                        ).createShader(bounds);
                      },
                      child: Container(
                        width: 1.sw,
                        height: safeBottomPadding +
                            24 +
                            48 +
                            24, //* bottom safea are height + bottom side height of button + button height + top side height of button
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: safeBottomPadding +
                      24, //* bottom safea are height + bottom side height of button
                  left: 16,
                  right: 16,
                  child: Container(
                    width: 1.sw,
                    child: CustomTextChildButton(
                      child: Text(
                        restaurant.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kts18Text,
                      ),
                      color: kcWhiteColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      borderRadius: kbr12,
                      onPressed: () async =>
                          await model.navToResDetailsView(restaurant),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
