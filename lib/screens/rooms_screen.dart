import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/module/chatRoom.dart';

final _firestore = Firestore.instance;

class RoomsScreen extends StatelessWidget {
  // final some = _firestore.collection('users').orderBy('chatRoomId').snapshots();
  // print(some.documents.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _firestore.collection('users').orderBy('chatRoomId').snapshots(), // chatRoomId가 없는 것도 있어.
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              );
            }

            final snapshot2 = _firestore.collection('messages').orderBy('text').snapshots();
            // snapshot2

            // final snapshot3 = await _firestore.collection('messages').getDocuments();
            // print(snapshot3.documents.first.data);
            // for(var doc in snapshot2.documents){
            //   print(doc);
            // }

            // final some = await _firestore.collection('messages').getDocuments();
            // print(snapshot2.data['1234'][0]['email'].toString());

            List<ChatRoom> roomList = [];
            final rooms = snapshot.data.documents;
            for (var room in rooms) {
              // receiver쪽만 만들어주기 위해서 if문.
              if (loggedInUser.email != room['email']) {
                // final로 하면 안되나 ?
                // final snapshot2 = _firestore.collection('messages').where(orderBy('text').snapshots();
                // snapshot2.

                // Room 그려주기
                print(room['chatRoomId']);
                print(room['userName']);
                // roomList.add(ChatRoom(email: , lastMessage: , userName: , timeStamp: ,));
              }
            }

            return ListView(
              children: roomList,
            );
          },
        ),
      ),
    );
  }
}

// class ChatStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: _firestore.collection('messages').orderBy('userName').snapshots(), // for order
//     );
//   }
// }
