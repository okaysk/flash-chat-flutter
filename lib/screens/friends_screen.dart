// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/Model/user_data.dart';
import 'package:flash_chat/provider/user_provider.dart';
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
        // child: StreamBuilder(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').orderBy('userName').snapshots(), // for order
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ));
            }

            final List<UserData> users = snapshot.data.documents.map((doc) => UserData.fromFirebase(doc)).toList();

            // view user profiles
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    // reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                    children: List.generate(users.length, (index) {
                      return UserProfile(userData: users[index]);
                    }),
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
  final UserData userData;

  UserProfile({
    this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black54,
        elevation: 6.0,
        child: UserCard(userData: userData),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  UserCard({
    this.userData,
  });

  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Route Setting 한건 왜 안되는거지???? MaterialApp이 tap_screen에 하나 더 있어서.
        // Navigator.pushNamed(context, ChatScreen.id);
        // createRoomNum(docId, roomId);
        // _firestore.collection('users').document().documentID;
        // final message = _firestore.collection('users').where("userName", isEqualTo: userName).snapshots();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              opponentUserData: userData,
            ),
          ),
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
                '${userData.userName}',
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
                '${userData.email} \n${userData.phoneNumber}',
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
