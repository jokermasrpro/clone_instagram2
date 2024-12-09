import 'package:cloud_firestore/cloud_firestore.dart';

class ModelUser {
  final String userName, email, password, userImage, uid;
  final List following;
  final List followers;

  // Constructor
  ModelUser(
    this.userName,
    this.email,
    this.followers,
    this.following,
    this.password,
    this.userImage,
    this.uid,
  );

  
  Map<String, dynamic> convertToMap() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'followers': followers,
      'following': following,
      'userImage': userImage,
      'uid': uid,
    };
  }

  static ModelUser convertSnapToModel(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ModelUser(
      snapshot['userName'],
      snapshot['email'],
      snapshot['followers'],
      snapshot['following'],
      snapshot['password'],
      snapshot['userImage'], 
      snapshot['uid'],
    );
  }

  
}

