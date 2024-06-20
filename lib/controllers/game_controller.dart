import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sudoku_game_competition/controllers/score_controller.dart';

import '../constant/constants.dart';
import '../utils/utils.dart';

class GameController extends GetxController {
  late Timer gameTimer; // المؤقت للعبة
  int currentRow = 99; // الصف الذي يقف عليه المؤشر حاليا الرقم 99 ليس له معني
  int currentCol = 99; // العمود الذي يقف عليه المؤشر حاليا
  RxInt remainingTime = 60.obs; // الوقت المتبقي
  int totalTime = 60; // الوقت الإجمالي
  late List<List<int?>> board; // لوحة اللعب
  late List<List<bool>> original; // ارقام اللوحة الأصلية التي لا يمكن تغيرها
  RxInt hintsUsed = 0.obs; // عدد الإشارات المستخدمة
  RxList moveStack = [].obs; // مكدس الحركات

  @override
  void onInit() {
    generateBoard(); // إنشاء اللوحة عند بدء التطبيق
    startTimer(); // بدء المؤقت
    super.onInit();
  }

  // الحصول على تلميح يتم بالترتيب من اول خليه الي الاخر
  int? getHint(int row, int col) {
    for (int i = 1; i <= 9; i++) { // الأرقام في لعبة السودوكو من 1 إلى 9
      if (SudokuUtils.isValidInput(row, col, i, board)) {
        return i;
      } else if (Constants.numberscolor[row][col]==Colors.red) {
      }
    }
    return null;
  }

  // استخدام تلميح
  void useHint() {
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] == null || Constants.numberscolor[row][col] == Colors.red) {
          if (hintsUsed < 1) {
            if (getHint(row, col) != null) {
              board[row][col] = getHint(row, col);
              Constants.numberscolor[row][col] = Colors.green;
              moveStack.add({'row': row, 'col': col});
              hintsUsed++;
              if (SudokuUtils.isBoardCompleteAndValid(board, Constants.numberscolor)) {
                gameTimer.cancel();
                showWinDialog(); // عرض نافذة الفوز
              }
              update();
              return;
            } else {
              Get.snackbar(
                  "No Hint Available",
                  "No valid hint available for this cell.",
                  duration: Duration(seconds: 8)
              );
              return;
            }
          } else {
            Get.snackbar(
                "Hint Used",
                "You've already used your hint for this level. Good luck!",
                duration: Duration(seconds: 8)
            );
            return;
          }
        }
      }
    }
    Get.snackbar(
        "Board Complete",
        "There are no empty cells to fill with a hint.",
        duration: Duration(seconds: 8)
    );
  }

  // التراجع عن الحركة الأخيرة
  void undo() {
    if (moveStack.isNotEmpty) {
      final lastMove = moveStack.removeLast();
      int row = lastMove['row'];
      int col = lastMove['col'];
      board[row][col] = null;
      update();
      Get.snackbar(
        "Undo",
        "The last move has been undone.",
      );
    } else {
      Get.snackbar(
          "Undo",
          "No moves to undo.",
          duration: Duration(seconds: 8)
      );
    }
  }

  // بدء المؤقت
  void startTimer() {
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime--;
      } else {
        timer.cancel();
        showTimeOutDialog(); // عرض نافذة انتهاء الوقت
      }
    });
  }

  // إيقاف المؤقت
  void pauseTimer() {
    gameTimer.cancel();
  }

  // استئناف المؤقت
  void resumeTimer() {
    startTimer();
  }

  // إعادة تعيين المؤقت
  void resetTimer() {
    remainingTime.value = totalTime;
  }

  // عرض نافذة الفوز
  void showWinDialog() {
    int timeTaken = totalTime-remainingTime.value;
    int stars = calculateScore(remainingTime.value);
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Congratulations!',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('You completed the Sudoku puzzle \n in $timeTaken seconds!'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: index < stars ? Colors.amber : Colors.grey,
                size: 30,
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            generateBoard();
            remainingTime.value = 60;
            hintsUsed.value = 0;
            moveStack.clear();
            Constants.resetColors();
            startTimer();
            update();
          },
          child: Text('Play Again'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            SystemNavigator.pop();
          },
          child: Text('Exit'),
        ),
      ],
    );
  }

  //   عند النقر على رقم معين من ال 9 ارقام بديل لوحه المفاتيح
  void onNumberTap(int number) {
    if (currentRow != 99) {
      if (SudokuUtils.isValidInput(currentRow, currentCol, number, board)) {
        board[currentRow][currentCol] = number;
        Constants.numberscolor[currentRow][currentCol] = Colors.black;
      } else {
        board[currentRow][currentCol] = number;
        Constants.numberscolor[currentRow][currentCol] = Colors.red;
      }
      // تخزين الحالة الحالية لكي يتم استخدامها للتراجع undo
      moveStack.add({
        'row': currentRow,
        'col': currentCol,
      });

      if (SudokuUtils.isBoardCompleteAndValid(board, Constants.numberscolor)) {
        gameTimer.cancel();
        saveScore(); // حفظ النقاط
        showWinDialog(); // عرض نافذة الفوز
      }
    }
    update();
  }

  // عرض نافذة انتهاء الوقت
  void showTimeOutDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Time Out!',
      content: Text('You ran out of time!'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            generateBoard();
            remainingTime.value = 60;
            hintsUsed.value = 0;
            moveStack.clear();
            Constants.resetColors();
            startTimer();
            update();
          },
          child: Text('Try Again'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            SystemNavigator.pop();
          },
          child: Text('Exit'),
        ),
      ],
    );
  }

  // إنشاء لوحة اللعب
  void generateBoard() {
    board = List.generate(3, (_) => List.generate(3, (_) => null));
    original = List.generate(3, (_) => List.generate(3, (_) => false));

    Random rand = Random();
    int filledCells = 4; // عدد الخلايا المملوءة مسبقاً

    while (filledCells > 0) {
      int row = rand.nextInt(3);
      int col = rand.nextInt(3);
      if (board[row][col] == null) {
        int number;
        do {
          number = rand.nextInt(9) + 1;
        } while (!SudokuUtils.isValidInput(row, col, number, board));
        board[row][col] = number;
        original[row][col] = true;
        filledCells--;
      }
    }
  }

  // حفظ النقاط
  void saveScore() {
    final scoreController = Get.find<ScoreController>();
    int stars = calculateScore(remainingTime.value); // حساب النجوم بناءً على الوقت المتبقي

    scoreController.addScore(stars, totalTime - remainingTime.value); // حفظ النجوم والوقت المستغرق
  }

// حساب النقاط بناءً على الوقت المتبقي
  int calculateScore(int remainingTime) {
    if (remainingTime > 50) {
      return 3; // 3 نجوم إذا تم الانتهاء في أقل من أو يساوي 10 ثانية
    } else if (remainingTime > 30) {
      return 2; // 2 نجوم إذا تم الانتهاء في أكثر من 10 ثانية ولكن أقل من أو يساوي 30 ثانية
    } else {
      return 1; // نجمة واحدة إذا تم الانتهاء في أكثر من 30 ثانية ولكن أقل من أو يساوي 60 ثانية
    }
  }
}




/*


import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sudoku_game_competition/controllers/score_controller.dart';

import '../constant/constants.dart';
import '../utils/utils.dart';

class GameController extends GetxController {
  late Timer gameTimer;
  int? selectedNumber;
  int currentRow = 99;
  int currentCol = 99;
  RxInt remainingTime = 60.obs;
  int totalTime = 60;
  late List<List<int?>> board;
  late List<List<bool>> original;
  RxInt hintsUsed = 0.obs;
  RxList moveStack = [].obs;
  @override
  void onInit() {
    generateBoard();
    startTimer();
    super.onInit();
  }

  int? getHint(int row, int col) {
    print("$row $col");
    for (int i = 1; i <= 9; i++) { // Sudoku numbers are from 1 to 9
      if (SudokuUtils.isValidInput(row, col, i, board)) {
        return i;
      }else if(Constants.numberscolor[row][col]==Colors.red){
        print(i);
      }
    }
    return null;
  }

  void useHint() {
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        print(col);
        if (board[row][col] == null||Constants.numberscolor[row][col] == Colors.red) {
          if (hintsUsed < 1) {
            if (getHint(row, col) != null) {
              board[row][col] = getHint(row, col);
              Constants.numberscolor[row][col] = Colors.green;
              moveStack.add({'row': row, 'col': col});
              hintsUsed++;
              if (SudokuUtils.isBoardCompleteAndValid(board, Constants.numberscolor)) {
                gameTimer.cancel();
                showWinDialog();
              }
              update();
              return;
            } else {
              Get.snackbar(
                  "No Hint Available",
                  "No valid hint available for this cell.",
                  duration: Duration(seconds: 8)
              );
              return;
            }
          } else {
            Get.snackbar(
                "Hint Used",
                "You've already used your hint for this level. Good luck!",
                duration: Duration(seconds: 8)
            );
            return;
          }
        }
      }
    }
    Get.snackbar(
        "Board Complete",
        "There are no empty cells to fill with a hint.",
        duration: Duration(seconds: 8)
    );
  }

  void undo() {
    if (moveStack.isNotEmpty) {
      final lastMove = moveStack.removeLast();
      int row = lastMove['row'];
      int col = lastMove['col'];
      board[row][col] = null;
      //moveStack.clear();
      update();
      Get.snackbar(
          "Undo",
          "The last move has been undone.",


      );
    } else {
      Get.snackbar(
          "Undo",
          "No moves to undo.",
          duration: Duration(seconds: 8)
      );
    }
  }

  void startTimer() {
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime--;
      } else {
        timer.cancel();
        showTimeOutDialog();
      }
    });
  }

  void pauseTimer() {
    gameTimer.cancel();
  }

  void resumeTimer() {
    startTimer();
  }

  void resetTimer() {
    remainingTime.value = totalTime;
  }

  void showWinDialog() {
    int stars = calculateScore(remainingTime.value);
    Get.defaultDialog(
      title: 'Congratulations!',
      content: Column(
        children: [
          Text('You completed the Sudoku puzzle!'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: index < stars ? Colors.amber : Colors.grey,
                size: 30,
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            generateBoard();
            remainingTime.value = 60;
            hintsUsed.value=0;
            moveStack.clear();
            Constants.resetColors();
            startTimer();
            update();
          },
          child: Text('Play Again'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            SystemNavigator.pop();
          },
          child: Text('Exit'),
        ),
      ],
    );
  }



  void onNumberTap(int number) {
    selectedNumber = number;

    if (currentRow != 99) {
      if (SudokuUtils.isValidInput(currentRow, currentCol, number, board)) {
        board[currentRow][currentCol] = number;
        Constants.numberscolor[currentRow][currentCol] = Colors.black;
      } else {
        board[currentRow][currentCol] = number;
        Constants.numberscolor[currentRow][currentCol] = Colors.red;
      }
      // Store the current state in the moveStack
      moveStack.add({
        'row': currentRow,
        'col': currentCol,
      });

      if (SudokuUtils.isBoardCompleteAndValid(board, Constants.numberscolor)) {
        gameTimer.cancel();
        saveScore();
        showWinDialog();
      }
    }
    update();
  }

  void showTimeOutDialog() {
    Get.defaultDialog(
      title: 'Time Out!',
      content: Text('You ran out of time!'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
            generateBoard();
            remainingTime.value = 60;
            hintsUsed.value=0;
            moveStack.clear();
            Constants.resetColors();
            startTimer();
            update();
          },
          child: Text('Try Again'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            SystemNavigator.pop();
          },
          child: Text('Exit'),
        ),
      ],
    );
  }

  void generateBoard() {
    board = List.generate(3, (_) => List.generate(3, (_) => null));
    original = List.generate(3, (_) => List.generate(3, (_) => false));

    Random rand = Random();
    int filledCells = 4; // Number of cells to pre-fill

    while (filledCells > 0) {
      int row = rand.nextInt(3);
      int col = rand.nextInt(3);
      if (board[row][col] == null) {
        int number;
        do {
          number = rand.nextInt(9) + 1;
        } while (!SudokuUtils.isValidInput(row, col, number, board));
        board[row][col] = number;
        original[row][col] = true;
        filledCells--;
      }
    }
  }

  void saveScore() {
    final scoreController = Get.find<ScoreController>();
    int stars = calculateScore(remainingTime.value); // Calculate stars based on remaining time

    scoreController.addScore(stars, totalTime - remainingTime.value); // Save stars and time taken
  }


  int calculateScore(int remainingTime) {
    if (remainingTime > 40) {
      return 3; // 3 stars if completed in less than or equal to 20 seconds
    } else if (remainingTime > 20) {
      return 2; // 2 stars if completed in more than 20 seconds but less than or equal to 40 seconds
    } else {
      return 1; // 1 star if completed in more than 40 seconds but less than or equal to 60 seconds
    }
  }


}
*/
