import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/score_controller.dart';

class TopScoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScoreController scoreController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Scores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final topScores = scoreController.topScores;
          return topScores.isNotEmpty
              ? ListView.builder(
            shrinkWrap: true,
            itemCount: topScores.length,
            itemBuilder: (context, index) {
              final score = topScores[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Icon(
                          index < score.score ? Icons.star : Icons.star_border,
                          color: index < score.score ? Colors.amber : Colors.grey,
                          size: 30,
                        );
                      }),
                    ),
                  title: Text('Score: ${score.score}'),
                  subtitle: Text('Time: ${score.time} seconds'),
                ),
              );
            },
          )
              : Text('No scores available.');
        }),
      ),
    );
  }
}
