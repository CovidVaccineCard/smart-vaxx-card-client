import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_vaxx_card_client/anim/fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/constants.dart';

class OTP extends StatelessWidget {
  final TextEditingController otpController;
  final Function(String) otpHandler;
  final LoginState loginState;

  OTP(
      {required this.loginState,
      required this.otpHandler,
      required this.otpController});

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
              "OTP Verification",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
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
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: otpController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(.8)),
                        hintText: "OTP",
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
              child: InkWell(
                onTap: () => _auth(context),
                child: Container(
                  width: 120,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue[800]),
                  child: Center(
                    child: Text(
                      "Verify",
                      style: TextStyle(color: Colors.white.withOpacity(.7)),
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

  Future<void> _auth(BuildContext ctx) async {
    String otp = otpController.text.trim();
    if (otp.length == 6) {
      otpHandler(otp);
    }
  }
}
