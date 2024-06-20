import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
class SudokuCell extends StatelessWidget {
  final int? number;
  final Color? numbersColor;
  final Color? boxColor;
  final RxBool taped;
  final bool isOriginal;

  SudokuCell({
    required this.number,
    required this.numbersColor,
    required this.boxColor,
    required this.taped,
    required this.isOriginal,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx((){
      return Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: themeController.textcolor,width: taped.value?2:1),
          borderRadius: BorderRadius.circular(10),
          gradient: RadialGradient(
            colors: isOriginal
                ? [themeController.grey200, themeController.grey400]
                : [themeController.grey100, themeController.grey300],
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Center(
                child: Text(
                  number?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 34,
                    color: numbersColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
             if(taped.value) Center(child: Lottie.asset("assets/lottie/Spiral.json",width: 45))
            ],
          ),
        ),
      );
    }
    );
  }
}