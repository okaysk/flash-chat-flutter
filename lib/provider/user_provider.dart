import 'package:flash_chat/Model/user_data.dart';
import 'package:flutter/cupertino.dart';

class UserProvider {
  UserProvider._();

  static UserProvider instance = UserProvider._();

  UserData userData;

// 두명의 user docId를 합쳐서 roomId로 users Collection에 추가. 이후에 채팅방 목록에 사용됨.
  String createRoomNum(UserData user1, UserData user2) {
    // final snapshot1 = await _firestore.collection('users').where('email', isEqualTo: email).getDocuments();
    // final snapshot2 = await _firestore.collection('users').where('email', isEqualTo: loggedInUser.email).getDocuments();

    // String getId1 = snapshot1.documents.first.documentID;
    // String getId2 = snapshot2.documents.first.documentID;
    String roomId;

    if (user1.uid.compareTo(user2.uid) == -1) {
      roomId = user1.uid + user2.uid;
    } else {
      roomId = user2.uid + user1.uid;
    }

    print(roomId);

    return roomId;
    //print('receiver: $email, sender: ${loggedInUser.email}');
    // _firestore.collection('users').document(getId1).updateData(
    //   {
    //     "chatRoomId": roomId,
    //   },
    // );
    // _firestore.collection('users').document(getId2).updateData(
    //   {
    //     "chatRoomId": roomId,
    //   },
    // );
  }
}
