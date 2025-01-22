import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Импортируем пакет для управления ориентацией
import 'package:firebase_core/firebase_core.dart'; // Импортируем Firebase Core
import 'screens/login_screen.dart'; // Импортируем экран входа

void main() async {
  // Инициализация Flutter и Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Блокируем ориентацию экрана
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Только портретная ориентация
    DeviceOrientation
        .portraitDown, // Опционально: можно добавить перевёрнутую портретную ориентацию
  ]);

  // Инициализация Firebase
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // Начинаем с экрана входа
    );
  }
}