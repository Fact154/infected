import 'package:flutter/material.dart';
// import 'game_logic/game_manager.dart';
import 'ui/screens/manual_screen.dart';
import 'ui/screens/setting_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Нечто"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.red, ),
      body: Container(  // Заменяем Center на Container
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Путь к вашему фоновому изображению
            fit: BoxFit.cover, // Или другой способ масштабирования
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Нечто",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red), // Изменил цвет текста
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Фон кнопки в черный
                  foregroundColor: Colors.red, // Текст кнопки в красный
                  textStyle: TextStyle(fontSize: 18), // Optional: Customize button text style
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Optional: Customize button padding
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                child: const Text("Начать игру"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Фон кнопки в черный
                  foregroundColor: Colors.red, // Текст кнопки в красный
                  textStyle: TextStyle(fontSize: 18), // Optional: Customize button text style
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Optional: Customize button padding
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManualScreen()), //  Переход к ManualScreen
                  );
                },
                child: const Text("Открыть инструкцию"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}