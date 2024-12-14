import 'package:clone_instagram/screens/features/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class ViewStory extends StatefulWidget {
  List userStories;
  ViewStory({super.key, required this.userStories});

  @override
  State<ViewStory> createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  @override
  Widget build(BuildContext context) {
    final controller = StoryController();
    // List<StoryItem> storyItems = [
    //   StoryItem.text(title: "hello", backgroundColor: Colors.blueGrey),
    //   StoryItem.pageImage(
    //       url:
    //           'https://i.pinimg.com/736x/f4/05/a8/f405a89b972ef01be59c662757590dd5.jpg',
    //       controller: controller),
    // ]; //
    late Map deleteMap;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/profile.jpg',
            ),
            radius: 60,
          ),
        ),
        title: Text(
          "JokerMasr",
          style: TextStyle(color: Colors.white),
        ),
        actions: [IconButton(onPressed: () {
          PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'option2'){
                  FirebaseServices().delete_story(story: deleteMap);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'option1',
                    child: Text('hide story'),
                  ),
                  PopupMenuItem<String>(
                    value: 'option2',
                    child: Text('delete story'),
                  ),
                 
                ];
              },
            );
        
        }, icon: Icon(Icons.more_vert,color: Colors.white,))],
      ),
      body: StoryView(
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
        storyItems: widget.userStories.map((myMap) {
          deleteMap = myMap;
          if (myMap['content'] != null) {
            return StoryItem.pageImage(
                url: myMap['content'], controller: controller);
          } else {
            return StoryItem.text(
                title: myMap['des'], backgroundColor: Colors.black);
          }
        }).toList(), // To disable vertical swipe gestures, ignore this parameter.
      ),
      
    );
  }
}
