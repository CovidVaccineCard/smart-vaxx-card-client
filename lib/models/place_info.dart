import 'package:flutter/material.dart';

class PlaceInfo {
  final String name;

  final String location;
  final int days;
  final Color startColor;
  final Color endColor;

  PlaceInfo(
    this.name,
    this.startColor,
    this.endColor,
    this.days,
    this.location,
  );
}
