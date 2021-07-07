import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/anim/fade_animation.dart';
import 'package:smart_vaxx_card_client/constants.dart';
import 'login_screen.dart';
import 'otp_screen.dart';
import 'walk_through.dart';
import 'package:smart_vaxx_card_client/screens/info/loading.dart';

class AuthScreen extends StatefulWidget {
  final phNoController = TextEditingController();
  final otpController = TextEditingController();
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthState _authState;
  late LoginState _loginState;
  String _verificationId = '';
  String _dialCode = '+91';

  @override
  void initState() {
    _authState = AuthState.WALKTHROUGH;
    _loginState = LoginState.IDLE;
    super.initState();
  }

  bool checkLoggedIn() {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Widget _buildScreen(AuthState state) {
    switch (state) {
      case AuthState.WALKTHROUGH:
        return WalkThrough(nextHandler: () {
          setState(() {
            _authState = AuthState.LOGIN;
          });
        });
      case AuthState.LOGIN:
        return LoginScreen(
          phNoController: widget.phNoController,
          dialCode: _dialCode,
          dialCodeHandler: (String dialCode) {
            setState(() {
              _dialCode = dialCode;
            });
          },
          loginState: _loginState,
          loginHandler: (String data) {
            setState(() {
              _loginState = LoginState.PENDING;
            });
            debugPrint(_dialCode + data);
            FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: _dialCode + data,
              verificationFailed: (e) {
                setState(() {
                  _loginState = LoginState.FAILED;
                });
              },
              codeSent: (id, token) {
                setState(() {
                  _authState = AuthState.OTP;
                  _verificationId = id;
                });
              },
              codeAutoRetrievalTimeout: (v) {},
              verificationCompleted: (c) {},
            );
          },
        );
      case AuthState.OTP:
        return OTP(
            otpController: widget.otpController,
            loginState: _loginState,
            otpHandler: (String data) {
              if (_verificationId.trim().isNotEmpty) {
                FirebaseAuth.instance
                    .signInWithCredential(
                      PhoneAuthProvider.credential(
                          verificationId: _verificationId, smsCode: data),
                    )
                    .then((value) => {
                          setState(() {
                            _loginState = LoginState.SUCCESS;
                          })
                        })
                    .catchError((e) {
                  setState(() {
                    _loginState = LoginState.FAILED;
                  });
                });
              }
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (checkLoggedIn()) {
        Navigator.popAndPushNamed(context, '/');
      }
    });
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
            _buildScreen(_authState),
          ],
        ),
      ),
    );
  }
}
