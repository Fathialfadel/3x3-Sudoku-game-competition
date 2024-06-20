import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sudoku_game_competition/controllers/game_controller.dart';

import 'circular_btn.dart';
class NumbersWidget extends StatelessWidget {
  NumbersWidget({Key? key}) : super(key: key);

  GameController gameController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: List.generate(5, (index) {
                int number = index + 1;

                return GestureDetector(
                  onTap: () => gameController.onNumberTap(number),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.015),
                      child: CircularButton(letter: number.toString())),
                );
              }),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: List.generate(4, (index) {
                int number = index + 6;

                return GestureDetector(
                  onTap: () => gameController.onNumberTap(number),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.015),
                      child: CircularButton(letter: number.toString())),
                );
              }),
            ),
          ),
        )
      ],
    );
  }
}
