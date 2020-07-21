import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:flash_chat/screens/friends_screen.dart';

class TapScreen extends StatelessWidget {
  static const String id = 'room_screen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightBlueAccent,
              // bottom: menu(),
              title: Text('SK Chat'),
            ),
            bottomNavigationBar: menu(),
            body: TabBarView(
              children: <Widget>[
                // Navigator.pushNamed(context, ChatScreen.id),
                // Icon(Icons.people),
                Friends(),
                // Icon(Icons.chat),
                ChatScreen(),
              ],
            )),
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
