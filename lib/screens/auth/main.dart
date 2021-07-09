import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_vaxx_card_client/anim/fade_animation.dart';
import 'package:smart_vaxx_card_client/constants.dart';
import 'walk_through.dart';
import 'package:smart_vaxx_card_client/screens/info/loading.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool checkLoggedIn() {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  void initState() {
    super.initState();
    if (checkLoggedIn()) Navigator.popAndPushNamed(context, '/');
  }

  Future<bool> signinWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (doc.exists) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().disconnect();
        final snackBar =
            SnackBar(content: Text('Login unsuccesful: Restricted access'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
      return true;
    } catch (err) {
      debugPrint(err.toString());
      final snackBar = SnackBar(content: Text('Login failed'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (checkLoggedIn()) return LoadingScreen();
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -50,
              left: 0,
              child: FadeAnimation(
                1,
                Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/one.png'), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -100,
              left: 0,
              child: FadeAnimation(
                1.3,
                Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/one.png'), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -150,
              left: 0,
              child: FadeAnimation(
                1.6,
                Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/one.png'), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            WalkThrough(nextHandler: signinWithGoogle),
          ],
        ),
      ),
    );
  }
}
