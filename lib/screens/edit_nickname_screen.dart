import 'package:flutter/material.dart';
import '../utils/user_storage.dart';

class EditNicknameScreen extends StatefulWidget {
  final String currentNickname;

  EditNicknameScreen({required this.currentNickname});

  @override
  _EditNicknameScreenState createState() => _EditNicknameScreenState();
}

class _EditNicknameScreenState extends State<EditNicknameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Цвета
  final Color backgroundColor = Color(0xFF9381FF); // Задний фон
  final Color buttonColor = Color(0xFFB8B8FF); // Цвет кнопок
  final Color textColor = Color(0xFFFFFFFF); // Белый цвет текста

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Изменить никнейм'),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Новый никнейм',
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
                    return 'Введите новый никнейм';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Текущий пароль',
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
                    return 'Введите текущий пароль';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final isPasswordCorrect = await UserStorage.checkUser(
                      widget.currentNickname,
                      _passwordController.text,
                    );

                    if (!isPasswordCorrect) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Неверный пароль')),
                      );
                      return;
                    }

                    await UserStorage.updateUserField(
                      widget.currentNickname,
                      '', // Старый email (не изменяется)
                      _nicknameController.text,
                      '', // Новый email (не изменяется)
                      '', // Новый пароль (не изменяется)
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Никнейм успешно изменён')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: textColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Овальная форма
                  ),
                ),
                child: Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}