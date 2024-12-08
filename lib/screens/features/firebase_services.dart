import 'package:clone_instagram/screens/Moded/model_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirebaseServices {
  Future<ModelUser> userdetils({required String userUid}) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .get();
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

//   addPost({required Map postMap}) async {
//   try {
//     final String userId = FirebaseAuth.instance.currentUser!.uid;
//     final postRef = FirebaseFirestore.instance.collection("posts").doc(postMap['postId']);

//     // التحقق مما إذا كان المستخدم قد أعجب بالمنشور
//     if (postMap['likes'].contains(userId)) {
//       // إزالة الإعجاب
//       await postRef.update({
//         'likes': FieldValue.arrayRemove([userId]),
//       });
//     } else {
//       // إضافة الإعجاب
//       await postRef.update({
//         'likes': FieldValue.arrayUnion([userId]),
//       });
//     }
//   } catch (e) {
//     print("خطأ في تحديث الإعجابات: $e");
//     // يمكنك هنا معالجة الخطأ مثلًا بإظهار رسالة للمستخدم
//   }
// }
// addPost({required Map postMap}) async {
//   try {
//     final String userId = FirebaseAuth.instance.currentUser!.uid;
//     final postRef = FirebaseFirestore.instance.collection("posts").doc(postMap['postId']);

//     // التحقق من وجود المستند
//     final docSnapshot = await postRef.get();
//     if (!docSnapshot.exists) {
//       print("المستند غير موجود.");
//       // هنا يمكنك إظهار رسالة للمستخدم أو اتخاذ إجراء آخر حسب الحاجة
//       return;
//     }

//     // التحقق مما إذا كان المستخدم قد أعجب بالمنشور
//     if (postMap['likes'].contains(userId)) {
//       // إزالة الإعجاب
//       await postRef.update({
//         'likes': FieldValue.arrayRemove([userId]),
//       });
//     } else {
//       // إضافة الإعجاب
//       await postRef.update({
//         'likes': FieldValue.arrayUnion([userId]),
//       });
//     }
//   } catch (e) {
//     print("خطأ في تحديث الإعجابات: $e");
//     // يمكنك هنا معالجة الخطأ مثلًا بإظهار رسالة للمستخدم
//   }
// }

  deletePost({required Map postDelete}) async {
    if (FirebaseAuth.instance.currentUser!.uid == postDelete['uid']) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postDelete['postId'])
          .delete();
    }
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
}
