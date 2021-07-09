import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_vaxx_card_client/anim/fade_animation.dart';

import 'signin_button.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({required this.nextHandler});

  final Future<bool> Function() nextHandler;

  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      // child: buildSignUp(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeAnimation(
              1,
              const Text(
                'Welcome',
                style: TextStyle(color: Colors.white, fontSize: 50),
              )),
          SizedBox(
            height: 15,
          ),
          FadeAnimation(
              1.3,
              Text(
                "We promise that you'll have the most secure Storage System.",
                style: TextStyle(
                    color: Colors.white.withOpacity(.7),
                    height: 1.4,
                    fontSize: 20),
              )),
          SizedBox(
            height: 180,
          ),
          FadeAnimation(
            1.6,
            Center(
              child: Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue.withOpacity(.4)),
                child: InkWell(
                  onTap: () async {
                    var isLogged = await widget.nextHandler();
                    if (isLogged) {
                      // navigate
                      await Navigator.of(context).popAndPushNamed('/');
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.google,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
