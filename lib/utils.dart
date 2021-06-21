import 'package:flutter/material.dart';

final displayColors = [
  {
    'start': Color(0xff6DC8F3),
    'end': Color(0xff73A1F9),
  },
  {
    'start': Color(0xffFFB157),
    'end': Color(0xffFFA057),
  },
  {
    'start': Color(0xffFF5B95),
    'end': Color(0xffF8556D),
  },
  {
    'start': Color(0xffD76EF5),
    'end': Color(0xff8F7AFE),
  },
  {
    'start': Color(0xff42E695),
    'end': Color(0xff3BB2B8),
  },
];

Map<String, Color> getColor(int index) {
  return displayColors[index % displayColors.length];
}
