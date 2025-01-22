import 'package:flutter/material.dart';
import '../utils/user_storage.dart';

class EditPasswordScreen extends StatefulWidget {
  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Цвета
  final Color backgroundColor = Color(0xFF9381FF); // Задний фон
  final Color buttonColor = Color(0xFFB8B8FF); // Цвет кнопок
  final Color textColor = Color(0xFFFFFFFF); // Белый цвет текста

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Изменить пароль'),
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
              // Поле для текущего пароля
              TextFormField(
                controller: _currentPasswordController,
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
              SizedBox(height: 16),
              // Поле для нового пароля
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Новый пароль',
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
                    return 'Введите новый пароль';
                  }
                  if (value.length < 6) {
                    return 'Пароль должен быть не менее 6 символов';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Поле для подтверждения нового пароля
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Подтвердите новый пароль',
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
                  if (value != _newPasswordController.text) {
                    return 'Пароли не совпадают';
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
                      _currentPasswordController.text,
                    );

                    if (!isPasswordCorrect) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Неверный текущий пароль')),
                      );
                      return;
                    }

                    await UserStorage.updateUserField(
                      '', // Старый никнейм (не изменяется)
                      '', // Старый email (не изменяется)
                      '', // Новый никнейм (не изменяется)
                      '', // Новый email (не изменяется)
                      _newPasswordController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Пароль успешно изменён')),
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