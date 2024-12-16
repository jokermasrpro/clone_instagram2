import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String uid;
  ChatScreen({super.key, required this.uid});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final user = _auth.currentUser;
      await FirebaseFirestore.instance.collection('chatsUsers').doc(widget.uid).update({
        'myId': user.uid,
        'frindId': widget.uid,
        'text': _messageController.text,
        'createdAt': Timestamp.now(),
       
      });
      _messageController.clear();
    }
  }



// التأكد من أن map يحتوي على 'chatId'
if (map.containsKey('chatId')) {
  String chatId = map['chatId']; // استخدم chatId من الـ map
  
  // إجراء استعلام على مجموعة معينة باستخدام chatId
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('chats') // اسم المجموعة (collection) التي تحتوي على بيانات الدردشة
      .where('chatId', isEqualTo: chatId) // فلترة البيانات باستخدام chatId
      .get(); // جلب النتائج

  // التحقق من وجود نتائج
  if (querySnapshot.docs.isNotEmpty) {
    // معالجة البيانات التي تم جلبها
    for (var doc in querySnapshot.docs) {
      print('Chat Data: ${doc.data()}');
      // يمكنك هنا العمل على البيانات المستردة
    }
  } else {
    print('No data found for the specified chatId');
  }
} else {
  print('chatId is not present in the map');
}



  chekuser() async{
    await  FirebaseFirestore.instance
                          .collection("users")
                          // .where('stories', isNotEqualTo: [])
                          .where('chats',
                              arrayContains:
                                  FirebaseAuth.instance.currentUser!.uid)
                          .snapshots();
    await FirebaseFirestore.instance.collection('users').where('chats',isEqualTo: widget.uid).get();
  }

  @override
  void initState() {
    // TODO: implement initState
    chekuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chat",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(



              stream: FirebaseFirestore.instance.collection('chatsUsers').where('userId',isEqualTo: widget.uid || 'myId',),
              // stream: FirebaseFirestore.instance.collection('chatsUsers').doc(widget.uid).collection('chatUser').snapshots(),

              // stream: FirebaseFirestore.instance
              //     .collection('users')
              //     .orderBy('createdAt', descending: true)
              //     .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final chatDocs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) => ListTile(
                    title: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),

                              
                              color: chatDocs == _auth.currentUser!.uid ? Colors.grey[850] : null,
                              gradient: LinearGradient(
                                begin: AlignmentDirectional(0, 1),
                                colors: chatDocs == _auth.currentUser!.uid ? [
                                  
                                  const Color.fromARGB(255, 13, 114, 197),
                                  const Color.fromARGB(255, 139, 40, 253)
                                ] : null ,
                              ),
                            ),
                            child: Text(
                              chatDocs[index]['text'],
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Colors.blue,
                    controller: _messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.grey,
                        ),
                        onPressed: _sendMessage,
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

