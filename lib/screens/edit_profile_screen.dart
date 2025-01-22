import 'package:flutter/material.dart';
import '../utils/user_storage.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentNickname;
  final String currentEmail;

  EditProfileScreen({
    required this.currentNickname,
    required this.currentEmail,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();

  // Цвета
  final Color backgroundColor = Color(0xFF9381FF); // Задний фон
  final Color buttonColor = Color(0xFFB8B8FF); // Цвет кнопок
  final Color textColor = Color(0xFFFFFFFF); // Белый цвет текста

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.currentNickname;
    _emailController.text = widget.currentEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать профиль'),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Поле для изменения никнейма
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
              ),
              SizedBox(height: 16),
              // Поле для изменения email
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
              SizedBox(height: 16),
              // Поле для текущего пароля (подтверждение)
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
              SizedBox(height: 20),
              // Кнопка для сохранения изменений
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Проверяем текущий пароль
                    final isPasswordCorrect = await UserStorage.checkUser(
                      widget.currentNickname,
                      _currentPasswordController.text,
                    );

                    if (!isPasswordCorrect) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Неверный текущий пароль')),
                      );
                      return;
                    }

                    // Обновляем данные пользователя
                    await UserStorage.updateUser(
                      widget.currentNickname,
                      widget.currentEmail,
                      _nicknameController.text,
                      _emailController.text,
                      _newPasswordController.text.isNotEmpty
                          ? _newPasswordController.text
                          : _currentPasswordController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Данные успешно обновлены')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: textColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Сохранить изменения'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}