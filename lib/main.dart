import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_vaxx_card_client/screens/main/location_notifier.dart';
import 'constants.dart';
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
            supportedLocales: [Locale('en')],
            localizationsDelegates: [
              CountryLocalizations.delegate,
            ],
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
              '/': (ctx) => ChangeNotifierProvider(
                    create: (_) => LocationNotifier(),
                    child: MainScreen(),
                  ),
              '/auth': (ctx) => AuthScreen(),
            },
          );
        }

        return LoadingScreen();
      },
    );
  }
}
