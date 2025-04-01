import 'package:flutter/material.dart';
import '../../models/prize.dart';

class PrizeList extends StatelessWidget {
  final List<PlayerPrize> players;
  final int totalPrize;

  const PrizeList({
    super.key,
    required this.players,
    required this.totalPrize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 총 상금
        Text(
          'TOTAL PRIZE MONEY \$${_formatNumber(totalPrize)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // 플레이어 리스트
        Expanded(
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Text(
                      '${player.rank}${_ordinal(player.rank)}',
                      style: const TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundImage: NetworkImage(player.avatarUrl),
                      radius: 16,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        player.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      '\$${_formatNumber(player.prizeMoney)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatNumber(int num) {
    return num.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  String _ordinal(int number) {
    if (number == 1) return 'st';
    if (number == 2) return 'nd';
    if (number == 3) return 'rd';
    return 'th';
  }
}
