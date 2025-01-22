import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardService {
  final DatabaseReference _leaderboardRef =
  FirebaseDatabase.instance.ref().child('leaderboard');

  // Обновление очков пользователя в таблице лидеров
  Future<void> updateUserScore(int score) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _leaderboardRef.child(userId).set(score); // Только очки
    }
  }

  // Получение топа игроков
  Future<Map<String, dynamic>> _getLeaderboard() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Пользователь не аутентифицирован");
    }

    final leaderboardSnapshot = await FirebaseDatabase.instance
        .ref()
        .child('leaderboard')
        .orderByValue()
        .limitToLast(10)
        .get();

    if (!leaderboardSnapshot.exists) {
      return {};
    }

    final leaderboardData = Map<String, dynamic>.from(leaderboardSnapshot.value as Map);
    return leaderboardData;
  }
}