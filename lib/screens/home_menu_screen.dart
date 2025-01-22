import 'package:flutter/material.dart';
import 'game_screen.dart'; // Экран игры
import 'leaderboard_screen.dart'; // Экран топа игроков
import 'profile_screen.dart'; // Экран профиля

class HomeMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Меню'),
        backgroundColor: Color(0xFF9381FF), // Цвет AppBar
        elevation: 0, // Убираем тень под AppBar
      ),
      body: Container(
        color: Color(0xFF9381FF), // Задний фон
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Кнопка "Начать игру"
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB8B8FF), // Цвет кнопки
                  foregroundColor: Colors.white, // Цвет текста
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Начать игру'),
              ),
              SizedBox(height: 20), // Отступ между кнопками
              // Кнопка "Топ игроков"
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LeaderboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB8B8FF), // Цвет кнопки
                  foregroundColor: Colors.white, // Цвет текста
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Топ игроков'),
              ),
              SizedBox(height: 20), // Отступ между кнопками
              // Кнопка "Мой аккаунт"
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB8B8FF), // Цвет кнопки
                  foregroundColor: Colors.white, // Цвет текста
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Мой аккаунт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}