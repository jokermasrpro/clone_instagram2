import 'package:clone_instagram/screens/auth_page/login_screen.dart';
import 'package:clone_instagram/screens/features/firebase_services.dart';
import 'package:clone_instagram/screens/provider.dart';
import 'package:clone_instagram/screens/widgets/post.dart';
import 'package:clone_instagram/screens/widgets/view_story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void fetch_current_user() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
  
  // @override
  // void initState() {
  //   super.initState();
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   userProvider.fetchuser(userid: FirebaseServices().uidGet());
  //   fetch_current_user();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          color: Colors.red,
          width: double.infinity,
          child: Container(
            color: Colors.black,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Instagram",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    // const Spacer(),
                    IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut().then(
                          (value) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.grey[110],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where('stories', isNotEqualTo: [])
                          .where('followers',
                              arrayContains:
                                  FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: Colors.pink,
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('${snapshot.error.toString()}'),
                          );
                        }
                        if (snapshot.hasData) {
                          final getData = snapshot.data!.docs;

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: getData.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> userStories =
                                  getData[index].data();
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ViewStory(
                                        userStories: userStories['stories'],
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.pink, width: 2),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                              'https://i.pinimg.com/736x/f4/05/a8/f405a89b972ef01be59c662757590dd5.jpg',
                                              )),
                                        ),
                                      ),
                                      Text(
                                        "name",
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(child: Text("null"));
                        }
                      }),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Erorr ${snapshot.error}",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> postMap =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return Post(
                              userMap: postMap,
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "wating.....",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
