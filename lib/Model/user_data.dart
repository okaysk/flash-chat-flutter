import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  UserData({
    this.userName,
    this.email,
    this.phoneNumber,
    this.uid,
  });

  final String userName;
  final String email;
  final String phoneNumber;
  final String uid;

  factory UserData.fromFirebase(DocumentSnapshot doc) {
    return UserData(
      uid: doc.documentID,
      email: doc['email'],
      userName: doc['userName'],
      phoneNumber: doc['phoneNumber'],
    );
  }
}
