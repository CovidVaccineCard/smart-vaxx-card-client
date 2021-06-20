import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'screens/auth/main.dart';
import 'screens/main/main.dart';
import 'screens/info/error.dart';
import 'screens/info/loading.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
  //     .copyWith(statusBarIconBrightness: Brightness.dark));
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
            debugShowCheckedModeBanner: false,
            title: 'Covid',
            theme: ThemeData(
              primaryColor: kPrimaryColor,
              accentColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: '/',
            routes: {
              '/': (ctx) => MainScreen(),
              '/auth': (ctx) => AuthScreen(),
            },
          );
        }

        return LoadingScreen();
      },
    );
  }
}
