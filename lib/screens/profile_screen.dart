import 'package:flutter/material.dart';
import 'edit_nickname_screen.dart';
import 'edit_email_screen.dart';
import 'edit_password_screen.dart';
import '../utils/user_storage.dart'; // Импортируем UserStorage для выхода из аккаунта
import 'login_screen.dart'; // Импортируем экран входа для перехода после выхода

class ProfileScreen extends StatelessWidget {
  final String currentNickname = 'UserNickname'; // Текущий никнейм
  final String currentEmail = 'user@example.com'; // Текущий email

  // Цвета
  final Color backgroundColor = Color(0xFF9381FF); // Задний фон
  final Color buttonColor = Color(0xFFB8B8FF); // Цвет кнопок
  final Color textColor = Color(0xFFFFFFFF); // Белый цвет текста

  // Метод для выхода из аккаунта
  void _logout(BuildContext context) async {
    await UserStorage.clearUserData(); // Очищаем данные пользователя
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Переходим на экран входа
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мой аккаунт'),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Отображение текущего никнейма
            Text(
              'Никнейм: $currentNickname',
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            SizedBox(height: 10),
            // Отображение текущего email
            Text(
              'Email: $currentEmail',
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            SizedBox(height: 20),
            // Кнопка "Изменить никнейм"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditNicknameScreen(currentNickname: currentNickname),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50), // Ширина на весь экран
              ),
              child: Text('Изменить никнейм'),
            ),
            SizedBox(height: 10),
            // Кнопка "Изменить email"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditEmailScreen(currentEmail: currentEmail),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50), // Ширина на весь экран
              ),
              child: Text('Изменить email'),
            ),
            SizedBox(height: 10),
            // Кнопка "Изменить пароль"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPasswordScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50), // Ширина на весь экран
              ),
              child: Text('Изменить пароль'),
            ),
            SizedBox(height: 10),
            // Кнопка "Выйти из аккаунта"
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Красный цвет для кнопки выхода
                foregroundColor: textColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50), // Ширина на весь экран
              ),
              child: Text('Выйти из аккаунта'),
            ),
          ],
        ),
      ),
    );
  }
}