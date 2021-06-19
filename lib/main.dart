import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/center/main.dart';
import 'screens/view_card/main.dart';
import 'screens/add_card/main.dart';
import 'screens/auth/main.dart';
import 'screens/main/main.dart';
import 'screens/info/error.dart';
import 'screens/info/loading.dart';

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
            title: 'Covid',
            theme: ThemeData(
              primaryColor: Color(0xFF2661FA),
              accentColor: Color(0xFF2661FA),
              scaffoldBackgroundColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: "/",
            routes: {
              "/": (ctx) => MainScreen(),
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
