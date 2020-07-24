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
                UserData userData;

                // snapshots (stream 이렇게 받아오면 안돼)
                // if (UserProvider.instance.userData.email == room['sender']) {
                //   final Stream<QuerySnapshot> userDataDoc = _firestore.collection('users').where('email', isEqualTo: room['receiver']).snapshots();
                //   userData = userDataDoc.first;
                // } else {
                //   final Stream<QuerySnapshot> userDataDoc = _firestore.collection('users').where('email', isEqualTo: room['sender']).snapshots();
                //   userData = userDataDoc.first;
                // }

                // async랑 StreamBuilder랑 같이 들어가니까 안됨. (전체를 다 불러오는게 문제. DB를 가능한 불러오지마)
                if (UserProvider.instance.userData.email == room['sender']) {
                  print(room['sender']);
                  // final userDataDoc = await _firestore.collection('users').where('email', isEqualTo: room['receiver']).getDocuments();
                  userData = UserProvider.instance.friends.firstWhere((userData) => userData.email == room['receiver'], orElse: () => null);
                  // userData = userDataDoc.documents.first;
                } else {
                  print(room['receiver']);

                  // userData = UserProvider.instance.friends.where((email) => email == room['sender']).toList().first; //exception처리 따로
                  userData = UserProvider.instance.friends.firstWhere((userData) => userData.email == room['sender'], orElse: () => null);
                  // final userDataDoc = await _firestore.collection('users').where('email', isEqualTo: room['sender']).getDocuments();
                  // userData = userDataDoc.documents.first;
                }
                // print('User DATA : ${userData.email}');
                print('USERPROVIDER : ${UserProvider.instance.userData.email}');
                print('USERDATA $userData');

                roomList.add(ChatRoom(
                  lastMessage: lastMessage,
                  timeStamp: timestamp,
                  userData: userData,
                ));
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

Future<UserData> test() {}
