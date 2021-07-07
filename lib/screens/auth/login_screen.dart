import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/anim/fade_animation.dart';
import 'package:smart_vaxx_card_client/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen(
      {required this.loginState,
      required this.loginHandler,
      required this.phNoController,
      required this.dialCode,
      required this.dialCodeHandler});

  final TextEditingController phNoController;
  final Function(String) loginHandler;
  final LoginState loginState;
  final String dialCode;
  final Function(String) dialCodeHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeAnimation(
            1.2,
            const Text(
              'Login',
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                children: <Widget>[
                  Row(
                      // color: Colors.transparent,
                      children: <Widget>[
                        SizedBox(
                          child: CountryCodePicker(
                            initialSelection: '+91',
                            showFlagMain: false,
                            onChanged: (CountryCode countryCode) {
                              if (countryCode.dialCode != null) {
                                dialCodeHandler(countryCode.dialCode!);
                                debugPrint(countryCode.dialCode!);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phNoController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.grey.withOpacity(.8)),
                              hintText: 'Phone number',
                            ),
                          ),
                        ),
                      ]),
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
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _auth(context);
                      },
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue[800]),
                        child: Center(
                          child: Text(
                            'Login',
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
    var phoneNumber = phNoController.text.trim();
    if (phoneNumber.isNotEmpty) {
      loginHandler(phoneNumber);
    }
  }
}
