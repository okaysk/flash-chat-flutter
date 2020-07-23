// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flash_chat/screens/registration_screen.dart';

final _firestore = Firestore.instance;

class Friends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // child: SingleChildScrollView( // ListView에서 이미 적용중.
        child: StreamBuilder(
          stream: _firestore.collection('users').orderBy('userName').snapshots(), // for order
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ));
            }

            final users = snapshot.data.documents;
            List<UserProfile> userProfiles = [];
            for (var user in users) {
              // print(user);
              print(user['id']);
              final email = user['email'];
              final userName = user['userName'];
              final phoneNumber = user['phoneNumber'];
              final userProfile = UserProfile(
                email: email,
                userName: userName,
                phoneNumber: phoneNumber,
              );
              // print('${userProfile.email} ${userProfile.userName}');
              userProfiles.add(userProfile);
            }

            // view user profiles
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    // reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                    children: userProfiles,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  final String userName, email, phoneNumber;

  UserProfile({this.userName, this.email, this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black54,
        elevation: 6.0,
        child: UserCard(userName: userName, email: email, phoneNumber: phoneNumber),
      ),
    );
  }
}

// 두명의 user docId를 합쳐서 roomId로 users Collection에 추가. 이후에 채팅방 목록에 사용됨.
void createRoomNum(String email) async {
  final snapshot1 = await _firestore.collection('users').where('email', isEqualTo: email).getDocuments();
  final snapshot2 = await _firestore.collection('users').where('email', isEqualTo: loggedInUser.email).getDocuments();

  String getId1 = snapshot1.documents.first.documentID;
  String getId2 = snapshot2.documents.first.documentID;
  String roomId;

  if (getId1.compareTo(getId2) == -1) {
    roomId = getId1 + getId2;
  } else {
    roomId = getId2 + getId1;
  }

  print(roomId);
  print('receiver: $email, sender: ${loggedInUser.email}');
  _firestore.collection('users').document(getId1).updateData(
    {
      "chatRoomId": roomId,
    },
  );
  _firestore.collection('users').document(getId2).updateData(
    {
      "chatRoomId": roomId,
    },
  );
}

class UserCard extends StatelessWidget {
  UserCard({this.email, this.phoneNumber, this.userName});

  final String userName;
  final String email;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Route Setting 한건 왜 안되는거지???? MaterialApp이 tap_screen에 하나 더 있어서.
        // Navigator.pushNamed(context, ChatScreen.id);
        // createRoomNum(docId, roomId);
        // _firestore.collection('users').document().documentID;
        // final message = _firestore.collection('users').where("userName", isEqualTo: userName).snapshots();

        createRoomNum(email);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(userName: userName, email: email)),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                '$userName',
                // textAlign: TextAlign.center,
                // textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 70.0,
            ),
            Expanded(
              flex: 3,
              // alignment: Alignment.centerRight,
              child: Text(
                '$email \n$phoneNumber',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
