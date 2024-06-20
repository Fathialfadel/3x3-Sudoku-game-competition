import 'package:flutter/material.dart';

class SudokuUtils {
  static bool isValidInput(int row, int col, int number, List<List<int?>> board) {
    for (int i = 0; i < 3; i++) {
      if (board[row][i] == number) return false;
    }

    for (int i = 0; i < 3; i++) {
      if (board[i][col] == number) return false;
    }

    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int i = startRow; i < startRow + 3; i++) {
      for (int j = startCol; j < startCol + 3; j++) {
        if (board[i][j] == number) return false;
      }
    }

    return true;
  }

  static bool isBoardCompleteAndValid(List<List<int?>> board, List<List<Color?>> numberscolor) {
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (board[row][col] == null || numberscolor[row][col] == Colors.red) {
          return false;
        }
      }
    }
    return true;
  }
}
