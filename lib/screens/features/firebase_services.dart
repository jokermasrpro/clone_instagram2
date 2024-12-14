import 'package:clone_instagram/Moded/model_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirebaseServices {
  Future<ModelUser> userdetils({required userUid}) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    return ModelUser.convertSnapToModel(snap);
  }


  addPost({required Map postMap}) async {
    if (postMap['likes'].contains(FirebaseAuth.instance.currentUser!.uid)) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postMap['postId'])
          .update({
        'likes':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
    } else {
      FirebaseFirestore.instance
          .collection("posts")
          .doc(postMap['postId'])
          .update({
        'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
    }
  }

  deletePost({required Map postDelete}) async {
    if (FirebaseAuth.instance.currentUser!.uid == postDelete['uid']) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postDelete['postId'])
          .delete();
    }
  }

   delete_story({required Map story}) async {
      FirebaseFirestore.instance
          .collection('users')
          .doc(story['uid'])
          .update(
            {
              'stories':FieldValue.arrayRemove([story])
            }
          );
  }

  addcomment(
      {required comment,
      required userName,
      required userImage,
      required postId,
      required uid}) async {
    if (comment != '') {
      final uuid = Uuid().v4();
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comment')
          .doc(uuid)
          .set({
        'comment': comment,
        'userName': userName,
        'userImage': userImage,
        'postId': postId,
        'uid': uid,
        'commentId': uuid,
      }).then((val) {});
    }
  }

  follow({required userid}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'following': FieldValue.arrayUnion([userid])
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .update({
      'followers': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }


  unfollow({required userid})async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'following': FieldValue.arrayRemove([userid])
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .update({
      'followers': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
    });
  }
}
