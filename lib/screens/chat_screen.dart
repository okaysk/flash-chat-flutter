import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final String userName, email;

  const ChatScreen({Key key, this.userName, this.email}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrenUser();
  }

  void getCurrenUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {}
  }

  bool test(Route<dynamic> route) {
    // print(route.settings.name);
    // print(route.isFirst);
    return route.settings.name == WelcomeScreen.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // hide back button
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                // Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id, (Route<dynamic> route) => route.settings.name == WelcomeScreen.id);
                // Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                // Navigator.popUntil(context, (route) => route.settings.name == WelcomeScreen.id);
                // Navigator.popUntil(context, test);
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat ${widget.email}'), //${widget.email}
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Messagestream(
              email: widget.email,
              userName: widget.userName,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      //messageText + loggedInUer.email
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'receiver': widget.email,
                        'timestamp': FieldValue.serverTimestamp(), // for order
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messagestream extends StatelessWidget {
  final String email, userName;

  Messagestream({this.email, this.userName});

  @override
  Widget build(BuildContext context) {
    // Stream<QuerySnapshot> stream2 = _firestore.collection('messages').orderBy('timestamp').snapshots();
    // Stream<QuerySnapshot> stream3 = _firestore.collection('messages').orderBy('timestamp').snapshots();
    // Stream<QuerySnapshot> stream4 = stream2 + stream3;

    return StreamBuilder<QuerySnapshot>(
      // stream: _firestore.collection('messages').orderBy('timestamp').snapshots(), // for order
      // stream: _firestore.collection('messages').where("sender", isEqualTo: userName).orderBy('timestamp').snapshots(),
      // stream: _firestore.collection('messages').where("sender", isEqualTo: email).where("receiver", isEqualTo: loggedInUser.email).orderBy('timestamp').snapshots(),
      // stream: stream4,
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
      // stream: _firestore.collection('messages').where("receiver", isEqualTo: email).orderBy('timestamp').snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('No data!!');
          print(snapshot.data);
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
          // return Expanded(
          //   child: ListView(
          //     reverse: true,
          //     padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          //     // children: messageBubbles,
          //   ),
          // );
        }
        print('Yes data');
        // print(snapshot.data.documents.first.documentID);

        final messages = snapshot.data.documents.reversed;
        // print(messages.first.documentID);
        // final senderMessages = snapshot.data.documents.wher
        // snapshot.data.documents.retainWhere((sender) => sender == loggedInUser.email);
        // final receiverMessages = snapshot.data.documents;
        // print(senderMessages);

        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          if (message.data['sender'] == email || message.data['receiver'] == email) {
            print('sender: ${message.data['sender']}, receiver: ${message.data['receiver']}');
            print('This is ID!!! ${message.documentID}');
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];
            final currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender, text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 6.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
