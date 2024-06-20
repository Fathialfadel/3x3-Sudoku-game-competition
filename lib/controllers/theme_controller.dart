import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;
  final _storage = GetStorage();
  //ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  //



  @override
  void onInit() {
    super.onInit();
    // Load saved theme preference on controller initialization
    isDarkMode.value = _storage.read('isDarkMode') ?? false;
  }

  ThemeMode get theme =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  void switchTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write('isDarkMode', isDarkMode.value);
  }

  Color get grey100 => isDarkMode.value ? Colors.grey[300]! : Colors.grey[100]!;
  Color get grey200 => isDarkMode.value ? Colors.grey[400]! : Colors.grey[200]!;
  Color get grey300 => isDarkMode.value ? Colors.grey[500]! : Colors.grey[300]!;
  Color get grey400 => isDarkMode.value ? Colors.grey[600]! : Colors.grey[400]!;

  Color get textcolor => isDarkMode.value ? Colors.white : Colors.black;
  Color get textcolor2 => isDarkMode.value ? Colors.grey[800]! : Colors.grey;

  Color get brown50 => isDarkMode.value ? Colors.brown[200]! : Colors.brown[50]!;
  Color get brown100 => isDarkMode.value ? Colors.brown[300]! : Colors.blue[100]!;
}
