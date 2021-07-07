import 'package:flutter/material.dart';

enum AuthState {
  WALKTHROUGH,
  LOGIN,
  OTP,
}

enum LoginState {
  IDLE,
  PENDING,
  SUCCESS,
  FAILED,
}

Color kPrimaryColor = const Color(0xFF166DE0);
Color kConfirmedColor = const Color(0xFFFF1242);
Color kActiveColor = const Color(0xFF017BFF);
Color kRecoveredColor = const Color(0xFF29A746);
Color kDeathColor = const Color(0xFF6D757D);

LinearGradient kGradientShimmer = const LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Colors.grey,
    Colors.grey,
  ],
);

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String mathFunc(Match match) {
  return '${match[1]}';
}
