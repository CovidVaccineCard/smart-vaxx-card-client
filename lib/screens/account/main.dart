import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  Widget getListView(BuildContext context) {
    var listView = ListView(
      children: [
        ListTile(
          leading: Icon(Icons.logout_outlined),
          title: Text("Logout"),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, "/auth");
          },
        ),
        ListTile(
          leading: Icon(Icons.help_sharp),
          title: Text("Help"),
          subtitle: Text("Contact:978XXXX989"),
        )
      ],
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        backgroundColor: Colors.blueAccent,
      ),
      body: getListView(context),
    );
  }
}
