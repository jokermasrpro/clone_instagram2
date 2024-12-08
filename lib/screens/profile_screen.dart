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
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
   

  @override
  Widget build(BuildContext context) {
     final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchuser(userid: widget.userUID);
  
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ViewImage(
                                  image: userProvider.getuser!.userImage)));
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
                        "Followrs",
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
                        "155",
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
                    backgroundColor: WidgetStatePropertyAll(Colors.grey[900]),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Edite Profile",
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
                        .where('uid',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Erorr ${snapshot.error.toString()}"),
                        );
                      }
                      if (snapshot.hasData) {
                        final docs = snapshot.data!.docs;
                        return GridView.builder(
                          itemCount: docs.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ViewImage(
                                        image: docs[index]['imagePost'])));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Image(
                                  image: NetworkImage(docs[index]['imagePost']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text("Defult"),
                        );
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


// import 'package:clone_instagram/screens/provider.dart';
// import 'package:clone_instagram/screens/view_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key, required this.userUID});
//   final String userUID;

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     userProvider.fetchuser(userUID: widget.userUID);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);

//     // التأكد من أن بيانات المستخدم تم تحميلها
//     if (userProvider.getuser == null) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => ViewImage(
//                                 image: userProvider.getuser!.userImage,
//                               ),
//                             ),
//                           );
//                         },
//                         child: CircleAvatar(
//                           backgroundImage: NetworkImage(userProvider.getuser!.userImage),
//                           radius: 30,
//                         ),
//                       ),
//                       Text(
//                         userProvider.getuser!.userName,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )
//                     ],
//                   ),
//                   const Column(
//                     children: [
//                       Text(
//                         "5",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "Posts",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Column(
//                     children: [
//                       Text(
//                         "2220",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "Followers",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Column(
//                     children: [
//                       Text(
//                         "155",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "Following",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
//                   ),
//                   onPressed: () {},
//                   child: const Text(
//                     "Edit Profile",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Expanded(
//                 child: FutureBuilder(
//                   future: FirebaseFirestore.instance
//                       .collection('posts')
//                       .where('uid', isEqualTo: widget.userUID)
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       return Center(
//                         child: Text("Error: ${snapshot.error.toString()}"),
//                       );
//                     }
//                     if (snapshot.hasData) {
//                       final docs = snapshot.data!.docs;
//                       return GridView.builder(
//                         itemCount: docs.length,
//                         shrinkWrap: true,
//                         physics: const BouncingScrollPhysics(),
//                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                         ),
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (_) => ViewImage(
//                                     image: docs[index]['imagePost'],
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.all(2.0),
//                               child: Image(
//                                 image: NetworkImage(docs[index]['imagePost']),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     } else {
//                       return const Center(child: Text("No posts available"));
//                     }
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
