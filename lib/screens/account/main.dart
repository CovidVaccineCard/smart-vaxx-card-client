import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountScreen extends StatelessWidget {
  Widget getListView(BuildContext context) {
    var listView = ListView(
      children: [
        ListTile(
          leading: Icon(Icons.logout_outlined),
          title: const Text('Logout'),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().disconnect();
            await Navigator.popAndPushNamed(context, '/auth');
          },
        ),
        ListTile(
          leading: Icon(Icons.help_sharp),
          title: const Text('Help'),
          subtitle: const Text('Contact:978XXXX989'),
        )
      ],
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: const Text('Account'),
      ),
      body: getListView(context),
    );
  }
}
