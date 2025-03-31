import 'package:flutter/material.dart';
import '../models/player.dart';
import 'card_widget.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  final bool isCurrentPlayer;
  final Function(int)? onCardTap;

  const PlayerWidget({
    Key? key,
    required this.player,
    this.isCurrentPlayer = false,
    this.onCardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentPlayer ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        border: Border.all(
          color: isCurrentPlayer ? Colors.blue : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: player.isInfected ? Colors.red : Colors.black,
            ),
          ),
          if (player.isBot) ...[
            const SizedBox(height: 4),
            const Text(
              'Бот',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: player.hand.length,
              itemBuilder: (context, index) {
                final card = player.hand[index];
                return CardWidget(
                  card: card,
                  onTap: isCurrentPlayer && onCardTap != null
                      ? () => onCardTap!(index)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 