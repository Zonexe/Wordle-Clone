import 'package:flutter/material.dart';

class LetterBox extends StatelessWidget {
  final String letter;
  final bool isCorrect;
  final bool isInWord;

  LetterBox({
    required this.letter,
    this.isCorrect = false,
    this.isInWord = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white; // По умолчанию белый цвет
    if (isCorrect) {
      backgroundColor = Colors.green; // Зелёный, если буква правильная
    } else if (isInWord) {
      backgroundColor = Colors.orange; // Оранжевый, если буква есть в слове, но не на своём месте
    }

    return Container(
      width: 40, // Ширина ячейки
      height: 40, // Высота ячейки
      decoration: BoxDecoration(
        color: backgroundColor, // Цвет фона
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4.0), // Закруглённые углы
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}