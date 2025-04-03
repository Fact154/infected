import 'package:flutter/material.dart';
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
    // Получаем размеры экрана
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Infected"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.red,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wallpaper_infected.jpg"), // Путь к вашему фоновому изображению
            fit: BoxFit.cover, // Или другой способ масштабирования
          ),
        ),
        child: Padding(
          // Добавляем отступ снизу, равный 30% от высоты экрана
          padding: EdgeInsets.only(bottom: screenHeight * 0.3),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

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
                      MaterialPageRoute(builder: (context) => ManualScreen()), // Переход к ManualScreen
                    );
                  },
                  child: const Text("Открыть инструкцию"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}