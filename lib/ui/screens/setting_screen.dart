import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // Инициализация по умолчанию
  int _Seak_cards = 4;        // Инициализация по умолчанию

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
      appBar: AppBar(title: const Text("Настройка лобби")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            CheckboxListTile(
              title: const Text("Включить Нечто"),
              value: _notificationsEnabled,
              onChanged: (bool? value) {
                setState(() {
                  _notificationsEnabled = value ?? false;
                  _saveSettings();
                });
              },
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                const Text("Количество карт заражения:"),
                Expanded(
                  child: Slider(
                    value: _Seak_cards.toDouble(),
                    min: 4,
                    max: 11,
                    divisions: 7,
                    label: _Seak_cards.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _Seak_cards = value.round();
                      });
                    },
                    onChangeEnd: (double value) {
                      _saveSettings(); // Save when sliding is done
                    },
                  ),
                ),
                Text(_Seak_cards.round().toString()),
              ],
            ),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context) => GameScreen(playerCount: _Seak_cards, alien: _notificationsEnabled))
          );
        },
        child: const Text("Начать игру"),)
          ],
        ),
      ),
    );
  }
}