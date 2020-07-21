import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
// import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/tap_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'welcome_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  bool showSpinner = false;
  String email, password;
  String userName, phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 100.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.start,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                onChanged: (value) {
                  userName = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your userName',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.start,
                onChanged: (value) {
                  phoneNumber = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your phoneNumber',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              RoundedButton(
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    // behind the method is Future<> type. That's asynchronous method.
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamedAndRemoveUntil(context, TapScreen.id, (Route<dynamic> route) => route.settings.name == WelcomeScreen.id);
                      // Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                    _firestore.collection('users').add({
                      'email': email,
                      'userName': userName,
                      'phoneNumber': phoneNumber,
                    });
                  } catch (e) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
