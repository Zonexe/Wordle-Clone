import 'package:flutter/material.dart';
import '../utils/user_storage.dart';
import 'register_screen.dart';
import 'home_menu_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Цвета
  final Color backgroundColor = Color(0xFF9381FF); // Задний фон
  final Color buttonColor = Color(0xFFB8B8FF); // Цвет кнопок
  final Color textColor = Color(0xFFFFFFFF); // Белый цвет текста

  // Регулярное выражение для проверки email
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Ключ для формы
  final _formKey = GlobalKey<FormState>();

  // Метод для отображения информации о приложении
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            'О приложении',
            style: TextStyle(color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Автор: Сенько Егор',
                style: TextStyle(color: textColor),
              ),
              SizedBox(height: 8),
              Text(
                'Версия: 1.0.0',
                style: TextStyle(color: textColor),
              ),
              SizedBox(height: 8),
              Text(
                'Описание: Wordle Clone — это увлекательная игра, в которой вам нужно угадывать слова. Каждая попытка приближает вас к разгадке!',
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Закрыть',
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor, // Цвет AppBar
        elevation: 0, // Убираем тень под AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: textColor),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: Container(
        color: backgroundColor, // Задний фон
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Заголовок "Вход" в центре экрана
            Text(
              'Вход',
              style: TextStyle(
                color: textColor,
                fontSize: 32, // Увеличиваем размер шрифта
                fontWeight: FontWeight.bold, // Жирный шрифт
              ),
            ),
            SizedBox(height: 20),
            // Иконка входа
            Icon(
              Icons.login, // Иконка входа
              size: 100, // Увеличенный размер
              color: textColor,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: 'Никнейм или Email',
                labelStyle: TextStyle(color: textColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                filled: true,
                fillColor: buttonColor.withOpacity(0.5),
              ),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пароль',
                labelStyle: TextStyle(color: textColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                filled: true,
                fillColor: buttonColor.withOpacity(0.5),
              ),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                final login = _loginController.text.trim();
                final password = _passwordController.text.trim();

                if (await UserStorage.checkUser(login, password)) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeMenuScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Неверный логин или пароль')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor, // Белый цвет текста кнопки
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(
                  fontSize: 18, // Увеличиваем размер шрифта
                  fontWeight: FontWeight.bold, // Жирный шрифт
                ),
              ),
              child: Text('Войти'),
            ),
            SizedBox(height: 12.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                'Нет аккаунта? Зарегистрируйтесь',
                style: TextStyle(
                  color: textColor, // Белый цвет текста
                  fontSize: 16, // Увеличиваем размер шрифта
                  fontWeight: FontWeight.bold, // Жирный шрифт
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}