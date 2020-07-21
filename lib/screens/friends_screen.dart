import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/registration_screen.dart';

class Friends extends StatelessWidget {
  final _firestore = Firestore.instance;
  // var data = _firestore.collection('users').orderBy('userName'); // for order

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.lightBlueAccent,
                child: Text(
                  'Friends',
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(
                  'Friends',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
