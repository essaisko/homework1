import 'package:flutter/material.dart';
import 'package:holdem_timer/models/prize.dart';

class PrizeList extends StatelessWidget {
  final List<PlayerPrize> players;
  final int totalPrize;
  final Color textColor;

  const PrizeList({
    super.key,
    required this.players,
    required this.totalPrize,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 이 줄을 추가합니다
      children: [
        Text(
          'Total Prize: \$${totalPrize.toString()}'.replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        // Flexible 대신 SizedBox나 Container를 사용합니다
        SizedBox(
          height: 300, // 적절한 높이를 지정하세요
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(player.avatarUrl),
                  radius: 25,
                  child: Image.network(
                    player.avatarUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // 이미지를 정상적으로 로드하면 child 반환
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ); // 에러가 발생하면 error icon 표시
                    },
                  ),
                ),
                title: Text(
                  '${player.rank}. ${player.name}',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  '\$${player.prizeMoney.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (m) => '${m[1]},',
                      )} ',
                  style: TextStyle(color: textColor.withOpacity(0.7)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
