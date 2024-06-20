import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku_game_competition/controllers/theme_controller.dart';
import 'package:sudoku_game_competition/home/top_scores_page.dart';
import 'package:sudoku_game_competition/widgets/numbers_widget.dart';
import 'package:sudoku_game_competition/widgets/sudoku_cell.dart';
import '../constant/constants.dart';
import '../controllers/game_controller.dart';
import '../controllers/score_controller.dart';

class SudokuBoard extends StatelessWidget {
  final GameController gameController = Get.find();
  final scoreController = Get.find<ScoreController>();
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
            return Row(
              children: [
                Icon(Icons.timer,color: gameController.remainingTime<15?Colors.red:null),
                SizedBox(width: 5,),
                Text('${gameController.remainingTime ~/ 60}:${(gameController.remainingTime % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                  color: gameController.remainingTime<15?Colors.red:null),),
              ],
            );
          }
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              themeController.switchTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.leaderboard),
            onPressed: () {
             // Get.to(()=> TopScoresPage());
              gameController.pauseTimer();
              Get.to(() => TopScoresPage())!.then((_) {
                gameController.resumeTimer();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /*Obx(() {
                  return Text(
                    'Time Remaining: ${gameController.remainingTime ~/ 60}:${(gameController.remainingTime % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                }),*/
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GetBuilder<GameController>(
                    builder: (gameController) => GridView.builder(
                      itemCount: 9,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        int row = index ~/ 3;
                        int col = index % 3;
                        return GestureDetector(
                          onTap: () {
                            if (!gameController.original[row][col]) {
                              if (gameController.currentRow != 99) {
                                Constants.boxcolor[gameController.currentRow][gameController.currentCol] = Colors.white;
                              }
                              gameController.currentRow = index ~/ 3;
                              gameController.currentCol = index % 3;
                              if (!gameController.original[row][col]) {
                                Constants.boxcolor[row][col] = Colors.blue;
                              }
                            }
                            gameController.update(); // Update GetX controller
                          },
                          child: SudokuCell(
                            number: gameController.board[row][col],
                            numbersColor: Constants.numberscolor[row][col],
                            boxColor: Constants.boxcolor[row][col],
                            taped: (Constants.boxcolor[row][col] == Colors.blue).obs,
                            isOriginal: gameController.original[row][col],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                NumbersWidget(),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(()  {
                      return ElevatedButton(
                          onPressed: () {
                            gameController.hintsUsed<1? gameController.useHint():
                            Get.snackbar(
                                "Hint Used",
                                "You've already used your hint for this level. Good luck!",
                                duration: Duration(seconds: 2)
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Disabled text color
                            shadowColor: Colors.grey,
                            elevation: gameController.hintsUsed<1 ? 5:0, // Shadow elevation
            
                            side: BorderSide(
                              color:  Colors.grey,
                              width:  gameController.hintsUsed<1? 1:0, // Border width
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
                          ),
                          child:Text(
                            'Hint',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: gameController.hintsUsed<1?   themeController.textcolor : themeController.textcolor2,
                            ),
                          )
                      );
                    }),
                    Obx(()  {
                      return ElevatedButton(
                          onPressed: () {
                            gameController.moveStack.isNotEmpty? gameController.undo():
                            Get.snackbar(
                                "Undo",
                                "No moves to undo.",
                                duration: Duration(seconds: 2)
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Disabled text color
                            shadowColor: Colors.grey,
                            elevation: gameController.moveStack.isNotEmpty ?5:0, // Shadow elevation
            
                            side: BorderSide(
                              color:  Colors.grey,
                              width:  gameController.moveStack.isNotEmpty ?1:0, // Border width
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
                          ),
                          child:Text(
                            'Undo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: gameController.moveStack.isNotEmpty ? themeController.textcolor : themeController.textcolor2,
                            ),
                          )
                      );
                    }),
            
                  ],
                ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
