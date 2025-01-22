import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String _userKey = 'users';
  static const String _nicknameKey = 'nickname'; // Ключ для никнейма
  static const String _emailKey = 'email'; // Ключ для email

  // Сохраняем данные пользователя (ник, email, пароль)
  static Future<void> saveUser(
      String nickname, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_userKey) ?? [];
    users.add('$nickname:$email:$password');
    await prefs.setStringList(_userKey, users);

    // Сохраняем никнейм и email отдельно для быстрого доступа
    await prefs.setString(_nicknameKey, nickname);
    await prefs.setString(_emailKey, email);
  }

  // Проверяем, существует ли пользователь по нику или email
  static Future<bool> checkUser(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_userKey) ?? [];
    return users.any((user) {
      final parts = user.split(':');
      final nickname = parts[0];
      final email = parts[1];
      final userPassword = parts[2];
      return (login == nickname || login == email) && password == userPassword;
    });
  }

  // Проверяем, зарегистрирован ли ник или email
  static Future<bool> isNicknameOrEmailRegistered(
      String nickname, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_userKey) ?? [];
    return users.any((user) {
      final parts = user.split(':');
      final existingNickname = parts[0];
      final existingEmail = parts[1];
      return existingNickname == nickname || existingEmail == email;
    });
  }

  // Обновляем данные пользователя (ник, email, пароль)
  static Future<void> updateUser(
      String oldNickname,
      String oldEmail,
      String newNickname,
      String newEmail,
      String newPassword,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_userKey) ?? [];

    // Находим пользователя и обновляем его данные
    final updatedUsers = users.map((user) {
      final parts = user.split(':');
      final nickname = parts[0];
      final email = parts[1];
      final password = parts[2];

      if (nickname == oldNickname && email == oldEmail) {
        return '$newNickname:$newEmail:$newPassword';
      }
      return user;
    }).toList();

    await prefs.setStringList(_userKey, updatedUsers);

    // Обновляем отдельно сохранённые никнейм и email
    await prefs.setString(_nicknameKey, newNickname);
    await prefs.setString(_emailKey, newEmail);
  }

  // Обновляем отдельные поля пользователя (ник, email, пароль)
  static Future<void> updateUserField(
      String oldNickname,
      String oldEmail,
      String newNickname,
      String newEmail,
      String newPassword,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_userKey) ?? [];

    // Находим пользователя и обновляем его данные
    final updatedUsers = users.map((user) {
      final parts = user.split(':');
      final nickname = parts[0];
      final email = parts[1];
      final password = parts[2];

      if (nickname == oldNickname && email == oldEmail) {
        // Обновляем только те поля, которые были изменены
        final updatedNickname = newNickname.isNotEmpty ? newNickname : nickname;
        final updatedEmail = newEmail.isNotEmpty ? newEmail : email;
        final updatedPassword = newPassword.isNotEmpty ? newPassword : password;
        return '$updatedNickname:$updatedEmail:$updatedPassword';
      }
      return user;
    }).toList();

    await prefs.setStringList(_userKey, updatedUsers);

    // Обновляем отдельно сохранённые никнейм и email
    if (newNickname.isNotEmpty) {
      await prefs.setString(_nicknameKey, newNickname);
    }
    if (newEmail.isNotEmpty) {
      await prefs.setString(_emailKey, newEmail);
    }
  }

  // Получаем текущий никнейм
  static Future<String> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nicknameKey) ?? 'Не указан';
  }

  // Получаем текущий email
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? 'Не указан';
  }

  // Очищаем данные пользователя при выходе из аккаунта
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nicknameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_userKey);
  }
}