import 'package:flutter/material.dart';
import '../widgets/letter_box.dart';
import '../widgets/keyboard.dart';
import '../models/game_model.dart';
import 'home_menu_screen.dart'; // Импортируем экран меню для перехода назад

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GameModel _gameModel = GameModel();

  // Цвета
  final Color backgroundColor = Color(0xFF9381FF); // Задний фон
  final Color buttonColor = Color(0xFFB8B8FF); // Цвет кнопок
  final Color textColor = Color(0xFFFFFFFF); // Белый цвет текста

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wordle Clone', style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeMenuScreen()),
            );
          },
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 5 колонок
                  mainAxisSpacing: 4.0, // Уменьшенный отступ между строками
                  crossAxisSpacing: 4.0, // Уменьшенный отступ между колонками
                ),
                itemCount: 30, // 5x6 grid (5 колонок, 6 строк)
                itemBuilder: (context, index) {
                  return LetterBox(
                    letter: _gameModel.getLetter(index),
                    isCorrect: _gameModel.isLetterCorrect(index),
                    isInWord: _gameModel.isLetterInWord(index),
                  );
                },
              ),
            ),
            Keyboard(
              onKeyPressed: (String letter) {
                setState(() {
                  if (!_gameModel.isCurrentWordComplete()) {
                    _gameModel.handleKeyPress(letter);
                  }
                });
              },
              onOkPressed: () {
                setState(() {
                  if (_gameModel.isCurrentWordComplete()) {
                    _gameModel.checkCurrentRow();

                    if (_gameModel.isWordGuessed()) {
                      _showDialog('Поздравляем!', 'Вы угадали слово!');
                    } else if (_gameModel.currentRow >= 5) {
                      _showDialog('Игра окончена', 'Вы не угадали слово.');
                    } else {
                      _showDialog('Попробуйте ещё раз', 'Слово неверное.');
                    }
                  } else {
                    _showDialog('Ошибка', 'Введите 5 букв.');
                  }
                });
              },
              onBackspacePressed: () {
                setState(() {
                  _gameModel.handleBackspace();
                });
              },
              backgroundColor: backgroundColor,
              buttonColor: buttonColor,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }

  // Показать диалоговое окно с результатом
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            title,
            style: TextStyle(color: textColor),
          ),
          content: Text(
            message,
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        );
      },
    );
  }
}