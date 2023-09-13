import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:story_view/story_view.dart';
import 'package:yoda_res/shared/shared.dart';
import 'package:yoda_res/ui/home/moments/moments_view.dart';
import 'package:yoda_res/ui/widgets/widgets.dart';

class MomentStoryView extends StatefulWidget {
  final List<MomentModel> moments;
  const MomentStoryView({required this.moments, Key? key}) : super(key: key);

  @override
  State<MomentStoryView> createState() => _MomentStoryViewState();
}

class _MomentStoryViewState extends State<MomentStoryView> {
  List<MomentModel> get moments => widget.moments;

  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    moments.forEach((moment) {
      if (moment.type == MediaType.text) {
        storyItems.add(
          StoryItem.text(
            title: moment.caption!,
            backgroundColor: kcPrimaryColor,
            // backgroundColor: HexColor(kcPrimaryColor),
            duration: Duration(
              milliseconds: (moment.duration * 1000).toInt(),
            ),
          ),
        );
      }

      if (moment.type == MediaType.image) {
        storyItems.add(StoryItem.pageImage(
          url: moment.url!,
          controller: controller,
          duration: Duration(
            milliseconds: (moment.duration * 1000).toInt(),
          ),
        ));
      }

      if (moment.type == MediaType.video) {
        storyItems.add(
          StoryItem.pageVideo(
            moment.url!,
            controller: controller,
            caption: 'Video',
            duration: Duration(milliseconds: (moment.duration * 1000).toInt()),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //*----------------- MOMENTS ---------------------//
          StoryView(
            storyItems: storyItems,
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
              int pos = storyItems.indexOf(storyItem);

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
              top: 48,
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
              height: 28 + 48 + 24,
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.025)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Container(
                  width: 1.sw,
                  height: 28 + 48 + 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 16,
            right: 16,
            child: Container(
              width: 1.sw,
              child: CustomTextChildButton(
                child: Text(
                  'Yoda Restoran',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kts18Text,
                ),
                color: kcWhiteColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                borderRadius: kbr12,
                onPressed: () async {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
