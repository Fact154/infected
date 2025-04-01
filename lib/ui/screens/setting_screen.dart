import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // Инициализация по умолчанию
  int _Seak_cards = 4; // Инициализация по умолчанию

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _Seak_cards = prefs.getInt('seak_cards') ?? 4;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', _notificationsEnabled);
    prefs.setInt('seak_cards', _Seak_cards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройка лобби"),
        backgroundColor: Colors.black, // Фон AppBar
        foregroundColor: Colors.white, // Цвет текста AppBar
      ),
      body: Container(  // Добавляем Container для фона
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Путь к вашему фону
            fit: BoxFit.cover, // Как картинка должна отображаться
          ),
        ),
        child: Padding( // Оборачиваем содержимое Padding
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                title:
                const Text(
                  "Включить Нечто",
                  style: TextStyle(color: Colors.white), // Красный цвет текста
                ),
                value: _notificationsEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    _notificationsEnabled = value ?? false;
                    _saveSettings();
                  });
                },
                tileColor: Colors.black.withOpacity(0.5),
                // Прозрачный фон для ListTile
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  const Text(
                    "Количество карт заражения:",
                    style: TextStyle(color: Colors.white), // Красный цвет текста
                  ),
                  Expanded(
                    child: Slider(
                      value: _Seak_cards.toDouble(),
                      min: 4,
                      max: 11,
                      divisions: 7, // Исправлено количество divisions
                      label: _Seak_cards.toString(),
                      onChanged: (double value) {
                        setState(() {
                          _Seak_cards = value.round();
                        });
                      },
                      onChangeEnd: (double value) {
                        _saveSettings(); // Save when sliding is done
                      },
                      activeColor: Colors.red, // Цвет активной части слайдера
                      inactiveColor: Colors.grey, // Цвет неактивной части слайдера
                    ),
                  ),
                  Text(
                    _Seak_cards.toString(),
                    style: TextStyle(color: Colors.red), // Красный цвет текста
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Фон кнопки черный
                  foregroundColor: Colors.red, // Текст кнопки красный
                  textStyle: TextStyle(fontSize: 18), // Optional: Customize button text style
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Optional: Customize button padding
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameScreen(
                              playerCount: _Seak_cards,
                              alien: _notificationsEnabled)));
                },
                child: const Text("Начать игру"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}