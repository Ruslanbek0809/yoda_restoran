import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class MomentStoryView extends StatefulWidget {
  @override
  State<MomentStoryView> createState() => _MomentStoryViewState();
}

class _MomentStoryViewState extends State<MomentStoryView> {
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return StoryView(
      controller: controller,
      storyItems: [
        StoryItem.text(
          title:
              "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
          backgroundColor: Colors.orange,
          roundedTop: true,
        ),
        StoryItem.inlineImage(
          url:
              "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
          controller: controller,
          caption: Text(
            "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black54,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
