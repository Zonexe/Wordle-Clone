import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Топ игроков'),
        backgroundColor: Color(0xFF9381FF),
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFF9381FF),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getLeaderboardWithNicknames(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка загрузки данных: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Нет данных'));
            } else {
              final leaderboardData = snapshot.data!;
              final sortedLeaderboard = leaderboardData.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              return ListView.builder(
                itemCount: sortedLeaderboard.length,
                itemBuilder: (context, index) {
                  final entry = sortedLeaderboard[index];
                  return ListTile(
                    title: Text(
                      '${index + 1}. ${entry.key}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    subtitle: Text(
                      'Очки: ${entry.value}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Метод для получения топа игроков с никнеймами
  Future<Map<String, dynamic>> _getLeaderboardWithNicknames() async {
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
    final leaderboardWithNicknames = <String, dynamic>{};

    for (final userId in leaderboardData.keys) {
      final userSnapshot = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId)
          .get();

      if (userSnapshot.exists) {
        final nickname = userSnapshot.child('nickname').value as String? ?? 'Аноним';
        leaderboardWithNicknames[nickname] = leaderboardData[userId];
      } else {
        leaderboardWithNicknames['Аноним'] = leaderboardData[userId];
      }
    }

    return leaderboardWithNicknames;
  }
}