import 'dart:math';
import 'package:firebase_database/firebase_database.dart'; // Импортируем Firebase Database
import 'package:firebase_auth/firebase_auth.dart'; // Импортируем Firebase Auth
import '../utils/words_list.dart';

class GameModel {
  List<String> _letters = List.filled(30, ''); // 5x6 grid (5 columns, 6 rows)
  String _targetWord = ''; // Слово, которое нужно угадать
  List<bool> _correctLetters = List.filled(30, false); // Правильные буквы
  List<bool> _lettersInWord =
  List.filled(30, false); // Буквы в слове, но не на своих местах
  List<bool> _isRowChecked =
  List.filled(6, false); // Проверена ли строка (6 строк)
  int _currentRow = 0; // Текущая строка (0-5)
  int _currentColumn = 0; // Текущая колонка в строке (0-4)
  bool _isRowLocked = false; // Заблокирована ли текущая строка

  // Геттер для текущей строки
  int get currentRow => _currentRow;

  GameModel() {
    _targetWord = _getRandomWord()
        .toUpperCase(); // Убедимся, что слово в верхнем регистре
    print('Загаданное слово: $_targetWord'); // Отладочный вывод
  }

  // Метод для получения случайного слова из списка
  String _getRandomWord() {
    final random = Random();
    return wordsList[
    random.nextInt(wordsList.length)]; // Выбираем случайное слово из списка
  }

  // Получить букву по индексу
  String getLetter(int index) {
    return _letters[index];
  }

  // Обработка нажатия клавиши
  void handleKeyPress(String letter) {
    if (!_isRowLocked && _currentColumn < 5) {
      // Проверяем, не заблокирована ли строка
      int index = _currentRow * 5 + _currentColumn; // Вычисляем индекс ячейки
      _letters[index] = letter.toUpperCase(); // Вводим букву в верхнем регистре
      _currentColumn++; // Переходим к следующей колонке
    }
  }

  // Проверка, заполнено ли текущее слово (5 букв)
  bool isCurrentWordComplete() {
    return _currentColumn == 5; // Текущая строка заполнена, если колонка == 5
  }

  // Проверка, угадано ли слово
  bool isWordGuessed() {
    int startIndex = _currentRow * 5;
    int endIndex = startIndex + 5;
    String guessedWord = _letters.sublist(startIndex, endIndex).join();
    return guessedWord == _targetWord;
  }

  // Проверка, правильно ли угадана буква
  bool isLetterCorrect(int index) {
    int row = index ~/ 5; // Определяем строку по индексу
    if (row < 6 && _isRowChecked[row]) {
      return _letters[index] == _targetWord[index - row * 5];
    }
    return false;
  }

  bool isLetterInWord(int index) {
    int row = index ~/ 5; // Определяем строку по индексу
    if (row < 6 && _isRowChecked[row]) {
      String letter = _letters[index];
      return _targetWord.contains(letter) && !isLetterCorrect(index);
    }
    return false;
  }

  // Проверка строки
  void checkCurrentRow() {
    if (isCurrentWordComplete()) {
      _isRowLocked = true; // Блокируем строку после нажатия "ОК"
      _isRowChecked[_currentRow] = true; // Помечаем строку как проверенную

      // Обновляем подсветку букв
      int startIndex = _currentRow * 5;
      int endIndex = startIndex + 5;
      for (int i = startIndex; i < endIndex; i++) {
        if (_letters[i] == _targetWord[i - startIndex]) {
          _correctLetters[i] = true; // Правильная буква на правильном месте
        } else if (_targetWord.contains(_letters[i])) {
          _lettersInWord[i] = true; // Буква есть в слове, но не на своём месте
        }
      }

      if (isWordGuessed()) {
        print('Поздравляем! Вы угадали слово!');
        _updateUserScore(_currentRow + 1); // Обновляем очки пользователя
      } else if (_currentRow < 5) {
        _currentRow++; // Переходим на следующую строку
        _currentColumn = 0; // Сбрасываем колонку для новой строки
        _isRowLocked = false; // Разблокируем новую строку
      } else {
        print('Игра окончена. Вы не угадали слово.');
        _updateUserScore(7); // 7 означает, что слово не угадано
      }
    }
  }

  void handleBackspace() {
    if (!_isRowLocked && _currentColumn > 0) {
      // Проверяем, не заблокирована ли строка
      int index =
          _currentRow * 5 + _currentColumn - 1; // Индекс последней буквы
      _letters[index] = ''; // Удаляем букву
      _currentColumn--; // Уменьшаем текущую колонку
    }
  }

  // Метод для обновления очков пользователя
  Future<void> _updateUserScore(int attempts) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final dbRef = FirebaseDatabase.instance.ref().child('users').child(userId);
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      int currentScore = snapshot.child('score').value as int? ?? 0;
      int wordsGuessed = snapshot.child('wordsGuessed').value as int? ?? 0;

      int points = 0;
      if (attempts <= 6) {
        points = 7 - attempts; // 6, 5, 4, 3, 2, 1
      } else {
        points = -2; // Не угадал слово
      }

      currentScore += points;
      wordsGuessed += 1;

      await dbRef.update({
        'score': currentScore,
        'wordsGuessed': wordsGuessed,
        'attempts/${_targetWord.toLowerCase()}': attempts,
      });

      // Обновляем топ игроков
      final leaderboardRef = FirebaseDatabase.instance.ref().child('leaderboard');
      await leaderboardRef.child(userId).set(currentScore);
    }
  }
}