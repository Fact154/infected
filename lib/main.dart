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
      appBar: AppBar(title: const Text("Нечто")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Нечто",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
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
    );
  }
}

// class GameScreen extends StatefulWidget {
//   final int playerCount;
//   GameScreen({required this.playerCount});

//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   late GameManager game;

//   @override
//   void initState() {
//     super.initState();
//     game = GameManager(widget.playerCount);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Игра")),
//       body: Column(
//         children: [
//           Text("Текущий игрок: ${game.getCurrentPlayer().name}"),
//           Expanded(
//             child: ListView.builder(
//               itemCount: game.players.length,
//               itemBuilder: (context, index) {
//                 var player = game.players[index];
//                 return ListTile(
//                   title: Text(player.name),
//                   subtitle: Text("Карт: ${player.hand.length}, ${player.isAlive ? 'жив' : 'мёртв'}"),
//                 );
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     game.drawAndProcessCard(game.getCurrentPlayer());
//                   });
//                 },
//                 child: Text("Взять карту"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     game.nextTurn();
//                   });
//                 },
//                 child: Text("Следующий ход"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }