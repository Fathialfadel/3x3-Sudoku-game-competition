import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Score {
  final int score;
  final int time;

  Score(this.score, this.time);

  Map<String, dynamic> toJson() => {
    'score': score,
    'time': time,
  };

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(json['score'], json['time']);
  }
}

class ScoreController extends GetxController {
  var scores = <Score>[].obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadScores();
  }

  List<Score> get topScores {
    var sortedScores = List<Score>.from(scores);
    sortedScores.sort((a, b) => b.score.compareTo(a.score));
    return sortedScores.take(10).toList();
  }

  void addScore(int score, int time) {
    scores.add(Score(score, time));
    saveScores();
  }

  void saveScores() {
    List<Map<String, dynamic>> jsonScores = scores.map((score) => score.toJson()).toList();
    storage.write('scores', jsonScores);
  }

  void loadScores() {
    List<dynamic> jsonScores = storage.read<List<dynamic>>('scores') ?? [];
    scores.value = jsonScores.map((json) => Score.fromJson(json)).toList();
  }
}
