// import 'package:clone_instagram/screens/login_screen.dart';
// import 'package:clone_instagram/screens/provider.dart';
// import 'package:clone_instagram/shard/widgets/button_nav.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) {
//             return UserProvider();
//           },
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
//           scaffoldBackgroundColor: Colors.black,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         ),
//         home: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator(
//                 color: Colors.white,
//               );
//             } else if (snapshot.hasError) {
//               return Scaffold(
//                 body: Center(
//                   child: Column(
//                     children: [
//                       Text("${snapshot.error}"),
//                       ElevatedButton(
//                           onPressed: () {}, child: const Text("restart")),
//                     ],
//                   ),
//                 ),
//               );
//             } else if (snapshot.hasData) {
//               return const ButtonNav();
//             } else if (snapshot.data == null) {
//               return const LoginScreen();
//             } else {
//               return const Scaffold();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoPickerScreen(),
    );
  }
}

class VideoPickerScreen extends StatefulWidget {
  @override
  _VideoPickerScreenState createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  VideoPlayerController? _controller;
  bool _isVideoSelected = false;

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  Future<void> _pickVideo() async {
    // طلب إذن الوصول إلى الملفات
    await _requestPermission();

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _controller = VideoPlayerController.file(
          File(pickedFile.path),
        )..initialize().then((_) {
            setState(() {
              _isVideoSelected = true;
            });
            _controller?.play();
          });
    })
  }

  }

  Future<void> _requestPermission() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      // إذا لم يتم منح الإذن، يمكن إظهار رسالة أو التعامل مع الوضع.
      print('Permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select and Play Video'),
      ),
      body: Center(
        child: _isVideoSelected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      setState(() {
                        _controller?.value.isPlaying ?? false
                            ? _controller?.pause()
                            : _controller?.play();
                      });
                    },
                  )
                ],
              )
            : ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Pick a Video'),
              ),
      ),
    );
  }
}
