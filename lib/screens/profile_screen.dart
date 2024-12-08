import 'package:clone_instagram/screens/features/firebase_services.dart';
import 'package:clone_instagram/screens/provider.dart';
import 'package:clone_instagram/screens/view_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userUID});
  final String userUID;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List following;
  late bool inFolloing;

  void fetch_current_user() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
        following = snapshot.data()!['following'];
        inFolloing= following.contains(widget.userUID);
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchuser(userid: widget.userUID);
    fetch_current_user();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.getuser == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (_) => ViewImage(
                          //         image: userProvider.getuser!.userImage)));
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Container(
                                  child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userProvider.getuser!.userImage,
                                ),
                                radius: 50,
                              ));
                            },
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userProvider.getuser!.userImage),
                          radius: 30,
                        ),
                      ),
                      Text(
                        userProvider.getuser!.userName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Column(
                    children: [
                      Text(
                        "5",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Posts",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Column(
                    children: [
                      Text(
                        "2220",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                   Column(
                    children: [
                      Text(
                        "${following.length}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Following",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        FirebaseAuth.instance.currentUser!.uid ==
                                userProvider.getuser!.uid
                            ? Colors.grey[900]
                            : Colors.blue),
                  ),
                  onPressed: () {
                    if (inFolloing){
                      return;
                    }
                    else{
                      FirebaseServices().follow(userid: widget.userUID);
                    }
                  },
                  child: Text(
                    FirebaseAuth.instance.currentUser!.uid ==
                            userProvider.getuser!.uid
                        ? "Edit Profile"
                        : "Followe",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.userUID)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error.toString()}"),
                        );
                      }
                      if (snapshot.hasData) {
                        return GridView.count(
                          // itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          // gridDelegate:
                          //     const SliverGridDelegateWithFixedCrossAxisCount(
                          //         crossAxisCount: 3),
                          crossAxisCount: 3,

                          // children:List.generate (snapshot.data!.docs.l, (index)) {
                          //
                          // },
                          children: List.generate(snapshot.data!.docs.length,
                              (index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ViewImage(
                                        image: snapshot.data!.docs[index]
                                            ['imagePost'])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image(
                                  image: NetworkImage(
                                      snapshot.data!.docs[index]['imagePost']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                        );
                      } else {
                        return const Center(child: Text("No posts available"));
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
