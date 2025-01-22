import 'package:flutter/material.dart';
import '../utils/user_storage.dart';
import 'login_screen.dart'; // Импортируем экран входа

class RegisterScreen extends StatelessWidget {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor, // Цвет AppBar
        elevation: 0, // Убираем тень под AppBar
      ),
      body: Container(
        color: backgroundColor, // Задний фон
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Ключ для формы
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Заголовок "Регистрация" в центре экрана
              Text(
                'Регистрация',
                style: TextStyle(
                  color: textColor,
                  fontSize: 32, // Увеличиваем размер шрифта
                  fontWeight: FontWeight.bold, // Жирный шрифт
                ),
              ),
              SizedBox(height: 20),
              // Иконка регистрации
              Icon(
                Icons.person_add_alt_1, // Иконка регистрации
                size: 100, // Увеличенный размер
                color: textColor,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Никнейм',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите никнейм';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите email';
                  }
                  if (!emailRegex.hasMatch(value)) {
                    return 'Введите корректный email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите пароль';
                  }
                  if (value.length < 6) {
                    return 'Пароль должен быть не менее 6 символов';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Подтвердите пароль',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, подтвердите пароль';
                  }
                  if (value != _passwordController.text) {
                    return 'Пароли не совпадают';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  // Проверка валидации формы
                  if (_formKey.currentState!.validate()) {
                    final nickname = _nicknameController.text.trim();
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if (await UserStorage.isNicknameOrEmailRegistered(
                        nickname, email)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                            Text('Никнейм или email уже зарегистрирован')),
                      );
                      return;
                    }

                    await UserStorage.saveUser(nickname, email, password);
                    // Переход на экран входа после успешной регистрации
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
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
                child: Text('Зарегистрироваться'),
              ),
              SizedBox(height: 12.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  'Уже есть аккаунт? Войдите',
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
      ),
    );
  }
}