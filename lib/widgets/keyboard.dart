import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onOkPressed;
  final VoidCallback onBackspacePressed;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;

  Keyboard({
    required this.onKeyPressed,
    required this.onOkPressed,
    required this.onBackspacePressed,
    required this.backgroundColor,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Высота кнопок
    final double buttonHeight = 50.0; // Фиксированная высота кнопок

    return Container(
      width: screenWidth, // Ширина клавиатуры равна ширине экрана
      padding: EdgeInsets.symmetric(horizontal: 8.0), // Отступы по бокам
      color: backgroundColor, // Цвет фона клавиатуры
      child: Column(
        children: [
          // Первая строка: Q W E R T Y U I O P
          Row(
            children: buildRow(
              ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
              buttonHeight,
            ),
          ),
          SizedBox(height: 6.0), // Увеличенный отступ между строками
          // Вторая строка: A S D F G H J K L
          Row(
            children: buildRow(
              ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
              buttonHeight,
            ),
          ),
          SizedBox(height: 6.0), // Увеличенный отступ между строками
          // Третья строка: Z X C V B N M + кнопка удаления
          Row(
            children: [
              ...buildRow(
                ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
                buttonHeight,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.0), // Увеличенный отступ для кнопки удаления
                  child: ElevatedButton(
                    onPressed: onBackspacePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: textColor,
                      padding: EdgeInsets.zero,
                      minimumSize: Size(double.infinity, buttonHeight), // Растягиваем на всю ширину
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Закруглённые углы
                      ),
                    ),
                    child: Icon(Icons.backspace, size: 20), // Иконка удаления
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0), // Увеличенный отступ перед кнопкой OK
          // Кнопка OK
          Center(
            child: SizedBox(
              width: screenWidth * 0.5, // Ширина кнопки "ОК" — 50% от ширины экрана
              child: ElevatedButton(
                onPressed: onOkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: textColor,
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  minimumSize: Size(double.infinity, buttonHeight), // Растягиваем на всю ширину
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Овальная форма
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Метод для создания строки с буквами
  List<Widget> buildRow(List<String> letters, double buttonHeight) {
    return letters.map((letter) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(4.0), // Увеличенный отступ между кнопками
          child: ElevatedButton(
            onPressed: () => onKeyPressed(letter),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: textColor,
              padding: EdgeInsets.zero, // Убираем внутренние отступы
              minimumSize: Size(double.infinity, buttonHeight), // Растягиваем на всю ширину
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Закруглённые углы
              ),
            ),
            child: Text(
              letter,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }).toList();
  }
}