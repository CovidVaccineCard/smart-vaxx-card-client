import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_vaxx_card_client/anim/fade_animation.dart';
import 'package:smart_vaxx_card_client/constants.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _phNoController = TextEditingController();
  final Function(String) loginHandler;
  final LoginState loginState;

  LoginScreen({required this.loginState, required this.loginHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeAnimation(
            1.2,
            Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FadeAnimation(
            1.5,
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                children: <Widget>[
                  Container(
                    // color: Colors.transparent,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phNoController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(.8)),
                        hintText: "Phone number",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          FadeAnimation(
            1.8,
            Center(
              child: loginState == LoginState.PENDING
                  ? CircularProgressIndicator()
                  : InkWell(
                      onTap: () => _auth(context),
                      child: Container(
                        width: 120,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue[800]),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white.withOpacity(.7),
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _auth(BuildContext context) {
    String phoneNumber = _phNoController.text.trim();
    if (phoneNumber.isNotEmpty && phoneNumber.length == 10) {
      loginHandler(phoneNumber);
    }
  }
}
