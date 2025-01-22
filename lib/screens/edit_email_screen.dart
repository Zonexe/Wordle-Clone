import 'package:flutter/material.dart';
import '../utils/user_storage.dart';

class EditEmailScreen extends StatefulWidget {
  final String currentEmail;

  EditEmailScreen({required this.currentEmail});

  @override
  _EditEmailScreenState createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Цвета
  final Color backgroundColor = Color(0xFF9381FF); // Задний фон
  final Color buttonColor = Color(0xFFB8B8FF); // Цвет кнопок
  final Color textColor = Color(0xFFFFFFFF); // Белый цвет текста

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Изменить email'),
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Новый email',
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
                    return 'Введите новый email';
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
                      '', // Никнейм не требуется
                      _passwordController.text,
                    );

                    if (!isPasswordCorrect) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Неверный пароль')),
                      );
                      return;
                    }

                    await UserStorage.updateUserField(
                      '', // Старый никнейм (не изменяется)
                      widget.currentEmail,
                      '', // Новый никнейм (не изменяется)
                      _emailController.text,
                      '', // Новый пароль (не изменяется)
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email успешно изменён')),
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