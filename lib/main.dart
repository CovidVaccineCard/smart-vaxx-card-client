import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'center/main.dart';
import 'view_card/main.dart';
import 'add_card/main.dart';
import 'auth/main.dart';
import 'home/main.dart';
import 'info/error.dart';
import 'info/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SmartVaxxCardApp());
}

class SmartVaxxCardApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        if (snapshot.hasData) {
          return MaterialApp(
            initialRoute: "/",
            routes: {
              "/": (ctx) => HomeScreen(),
              "/auth": (ctx) => AuthScreen(),
              "/centers/:centerId": (ctx) => CenterScreen(),
              "/card/add": (ctx) => AddCardScreen(),
              "/card/view/:cardId": (ctx) => ViewCardScreen(),
            },
          );
        }

        return LoadingScreen();
      },
    );
  }
}
