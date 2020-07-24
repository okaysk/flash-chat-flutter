// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/provider/user_provider.dart';
import 'package:flash_chat/screens/chatList_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/friends_screen.dart';

class TapScreen extends StatelessWidget {
  static const String id = 'tap_screen';

  @override
  Widget build(BuildContext context) {
    // return MaterialApp( 얘는 App당 1개. 그 이상은 드문 케이스.
    // Future Builder를 갖고 appBar안에 userDatar가 null인 경우
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          // bottom: menu(),
          // title: Text('Hello ${UserProvider.instance.userData.email}'), // 불러오는 동안 null.
          title: Text('Hello'), // 임시방편.
        ),
        bottomNavigationBar: menu(),
        body: TabBarView(
          children: <Widget>[
            // Navigator.pushNamed(context, ChatScreen.id),
            // Icon(Icons.people),
            Friends(),
            // Icon(Icons.chat),
            // ChatScreen(),
            ChatList(),
          ],
        ),
      ),
    );
  }
}

Widget menu() {
  return Container(
    color: Colors.lightBlueAccent,
    child: TabBar(
      unselectedLabelColor: Colors.white38,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Colors.white,
      tabs: <Widget>[
        Tab(
          text: "Friends",
          icon: Icon(Icons.people),
        ),
        Tab(
          text: "ChatRooms",
          icon: Icon(Icons.chat),
        ),
      ],
    ),
  );
}
