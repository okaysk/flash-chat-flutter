import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/Model/user_data.dart';
import 'package:flash_chat/provider/user_provider.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/module/chatRoom.dart';

class ChatList extends StatelessWidget {
  static const String id = 'chagtList_screen';
  // final some = _firestore.collection('users').orderBy('chatRoomId').snapshots();
  // print(some.documents.length);
  final _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          //stream: _firestore.collection('users').orderBy('chatRoomId').snapshots(), // chatRoomId가 없는 것도 있어.
          stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
          // stream: _firestore.collection("messages").orderBy('chatRoomId').orderBy('timestamp').snapshots().distinct(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              );
            }

            //final snapshot2 = _firestore.collection('messages').orderBy('text').snapshots();
            // final snapshot3 = await _firestore.collection('messages').getDocuments();
            // print(snapshot3.documents.first.data);
            // for(var doc in snapshot2.documents){
            //   print(doc);
            // }

            // final some = await _firestore.collection('messages').getDocuments();
            // print(snapshot2.data['1234'][0]['email'].toString());

            List<ChatRoom> roomList = []; // (중복 제거 가능?)
            // Set<ChatRoom> roomList;
            final rooms = snapshot.data.documents.reversed;
            // print('How long it is : ${rooms.length}');
            Set<String> roomId = {};
            for (var room in rooms) {
              // 날짜 최신 데이터로 들어온 것 중에서 id 중복을 제거하고.
              if (roomId.add(room['chatRoomId'])) {
                print('\n\t\t${room['chatRoomId']}\n\t\t${room['text']} ${room['timestamp'].toDate()}');
                final lastMessage = room['text']; // 최신 데이터
                final timestamp = room['timestamp'].toDate().toString();
                var userData;

                // snapshots
                if (UserProvider.instance.userData.email == room['sender']) {
                  final userDataDoc = _firestore.collection('users').where('email', isEqualTo: room['receiver']).snapshots();
                  userData = userDataDoc.first;
                } else {
                  final userDataDoc = _firestore.collection('users').where('email', isEqualTo: room['sender']).snapshots();
                  userData = userDataDoc.first;
                }

                // async랑 StreamBuilder랑 같이 들어가니까 안됨.
                // if (UserProvider.instance.userData.email == room['sender']) {
                //   final userDataDoc = await _firestore.collection('users').where('email', isEqualTo: room['receiver']).getDocuments();
                //   userData = userDataDoc.documents.first;
                // } else {
                //   final userDataDoc = await _firestore.collection('users').where('email', isEqualTo: room['sender']).getDocuments();
                //   userData = userDataDoc.documents.first;
                // }

                roomList.add(ChatRoom(
                  lastMessage: lastMessage,
                  timeStamp: timestamp,
                  userData: userData,
                ));
              }
              // if(roomId.add(room['chatRoomId']){

              // }

              // roomList.add(ChatRoom())
            }

            // Iterator<ChatRoom> it = roomList.iterator;

            return ListView(
              children: roomList,
              // children: List.generate(roomList.length, (index) {
              //   return ChatRoom(roomList[index]);
              // }),
            );
          },
        ),
      ),
    );
  }
}
