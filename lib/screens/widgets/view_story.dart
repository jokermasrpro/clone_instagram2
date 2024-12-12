import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class ViewStory extends StatelessWidget {
  const ViewStory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StoryController();
    List<StoryItem> storyItems = [
      StoryItem.text(title: "hello", backgroundColor: Colors.blueGrey),
      StoryItem.pageImage(
          url:
              'https://i.pinimg.com/736x/f4/05/a8/f405a89b972ef01be59c662757590dd5.jpg',
          controller: controller),
    ]; //

    return StoryView(
      controller: controller, // pass controller here too
      repeat: false, // should the stories be slid forever
      onComplete: () {
        Navigator.pop(context);
      },
      onVerticalSwipeComplete: (direction) {
        if (direction == Direction.down) {
          Navigator.pop(context);
        }
      },
      storyItems:
          storyItems, // To disable vertical swipe gestures, ignore this parameter.
    );
  }
}
