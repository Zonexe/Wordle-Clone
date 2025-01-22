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
        child: FutureBuilder(
          future: FirebaseDatabase.instance
              .ref()
              .child('leaderboard')
              .orderByValue()
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка загрузки данных'));
            } else if (!snapshot.hasData || snapshot.data!.value == null) {
              return Center(child: Text('Нет данных'));
            } else {
              final leaderboardData =
              Map<String, dynamic>.from(snapshot.data!.value as Map);
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
}