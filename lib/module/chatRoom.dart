import 'package:flash_chat/Model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/chat_screen.dart';

class ChatRoom extends StatelessWidget {
  final String lastMessage, timeStamp;
  final UserData userData;

  ChatRoom({
    this.lastMessage,
    this.timeStamp,
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
        child: GestureDetector(
          onTap: () async {
            // Route Setting 한건 왜 안되는거지???? MaterialApp이 tap_screen에 하나 더 있어서.
            // Navigator.pushNamed(context, ChatScreen.id);
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
                    '$lastMessage\n$timeStamp',
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
        ),
      ),
    );
  }
}
