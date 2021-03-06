import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smart_vaxx_card_client/constants.dart';
import 'package:smart_vaxx_card_client/screens/account/main.dart';
import 'package:smart_vaxx_card_client/screens/home/main.dart';
import 'package:smart_vaxx_card_client/screens/info/loading.dart';
import 'package:smart_vaxx_card_client/screens/link_card/arguments.dart';
import 'package:smart_vaxx_card_client/screens/link_card/main.dart';
import 'package:smart_vaxx_card_client/screens/upload_form/main.dart';
import 'package:smart_vaxx_card_client/screens/vaccination_center/main.dart';
import 'package:smart_vaxx_card_client/screens/vaxx_cards/main.dart';

import 'location_notifier.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selected = 0;
  List<Widget>? _widgetOptions;
  bool isDeepLink = true;

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final deepLink = dynamicLink?.link;

      if (deepLink != null) {
        final queryParams = deepLink.queryParameters;
        if (queryParams.isNotEmpty) {
          final cardId = queryParams['cardId'];
          if (cardId != null) {
            setState(() {
              isDeepLink = true;
            });
            await Navigator.popAndPushNamed(context, LinkCardScreen.routeName,
                arguments: LinkCardScreenArguments(cardId));
          }
        }
      } else {
        setState(() {
          isDeepLink = false;
        });
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      final queryParams = deepLink.queryParameters;
      if (queryParams.isNotEmpty) {
        final cardId = queryParams['cardId'];
        if (cardId != null) {
          setState(() {
            isDeepLink = true;
          });
          await Navigator.popAndPushNamed(context, LinkCardScreen.routeName,
              arguments: LinkCardScreenArguments(cardId));
        }
      }
    } else {
      setState(() {
        isDeepLink = false;
      });
    }
  }

  Future<void> requestLocation() async {
    var location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        LocationNotifier.of(context).status = LocationStatus.NO_LOCATION;
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        LocationNotifier.of(context).status = LocationStatus.NO_PERMISSION;
        return;
      }
    }
    LocationNotifier.of(context).status = LocationStatus.CHECKING;
    var data = await location.getLocation();
    LocationNotifier.of(context).data = data;
    debugPrint('location: ${data.latitude}, ${data.longitude}');
    LocationNotifier.of(context).status = LocationStatus.SUCCESS;
  }

  void init() async {
    await initDynamicLinks();
    if (checkLoggedIn() && !isDeepLink) {
      await requestLocation();
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  List<Widget> getWidgets() {
    var widgetOptions = _widgetOptions ??
        <Widget>[
          HomeScreen(),
          UploadFormScreen(),
          VaxxCardScreen(),
          VaccinationCenterScreen(),
          AccountScreen(),
        ];
    _widgetOptions = widgetOptions;
    return widgetOptions;
  }

  bool checkLoggedIn() {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  void _onItemTap(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (!checkLoggedIn() && !isDeepLink) {
        Navigator.popAndPushNamed(context, '/auth');
      }
    });
    return !checkLoggedIn() || isDeepLink
        ? LoadingScreen()
        : Scaffold(
            body: Center(
              child: getWidgets().elementAt(_selected),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  backgroundColor: kPrimaryColor,
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  backgroundColor: kPrimaryColor,
                  icon: Icon(Icons.add),
                  label: 'Upload',
                ),
                BottomNavigationBarItem(
                  backgroundColor: kPrimaryColor,
                  icon: Icon(Icons.folder_shared),
                  label: 'Card',
                ),
                BottomNavigationBarItem(
                  backgroundColor: kPrimaryColor,
                  icon: Icon(Icons.near_me_sharp),
                  label: 'Center',
                ),
                BottomNavigationBarItem(
                  backgroundColor: kPrimaryColor,
                  icon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
              currentIndex: _selected,
              onTap: _onItemTap,
            ),
          );
  }
}
