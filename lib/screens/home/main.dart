import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/screens/info/loading.dart';

class HomeScreen extends StatelessWidget {
  bool checkLoggedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (!checkLoggedIn()) {
        Navigator.popAndPushNamed(context, "/auth");
      }
    });
    return !checkLoggedIn()
        ? LoadingScreen()
        : Scaffold(
            body: Center(
              child: GestureDetector(
                child: Text("Home"),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/auth");
                },
              ),
            ),
          );
  }
}
