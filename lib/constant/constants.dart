import 'package:flutter/material.dart';

class Constants {
  static List<List<Color?>> numberscolor = [
    [Colors.black, Colors.black, Colors.black],
    [Colors.black, Colors.black, Colors.black],
    [Colors.black, Colors.black, Colors.black],
  ];

  static List<List<Color?>> boxcolor = [
    [Colors.white, Colors.white, Colors.white],
    [Colors.white, Colors.white, Colors.white],
    [Colors.white, Colors.white, Colors.white],
  ];

  static void resetColors() {
    numberscolor = [
      [Colors.black, Colors.black, Colors.black],
      [Colors.black, Colors.black, Colors.black],
      [Colors.black, Colors.black, Colors.black],
    ];

    boxcolor = [
      [Colors.white, Colors.white, Colors.white],
      [Colors.white, Colors.white, Colors.white],
      [Colors.white, Colors.white, Colors.white],
    ];
  }
}
