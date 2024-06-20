import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sudoku_game_competition/controllers/game_controller.dart';
import 'package:sudoku_game_competition/home/sudoku_board.dart';
import 'package:sudoku_game_competition/controllers/theme_controller.dart';

import 'controllers/score_controller.dart';

void main()async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final GameController gameController = Get.put(GameController());
  final ScoreController scoreController = Get.put(ScoreController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => GetMaterialApp(
        themeMode: themeController.theme,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: SudokuBoard(),
      ),
    );
  }
}


