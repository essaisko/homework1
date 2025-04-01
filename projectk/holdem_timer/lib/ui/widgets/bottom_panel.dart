import 'package:flutter/material.dart';

class BottomPanel extends StatelessWidget {
  final int smallBlind;
  final int bigBlind;
  final int ante;
  final int nextSmallBlind;
  final int nextBigBlind;
  final int nextAnte;
  final int entrants;
  final int entrantsRemaining;
  final int chipsInPlay;
  final Color textColor;
  final Duration nextDuration;

  const BottomPanel({
    super.key,
    required this.smallBlind,
    required this.bigBlind,
    required this.ante,
    required this.nextSmallBlind,
    required this.nextBigBlind,
    required this.nextAnte,
    required this.entrants,
    required this.entrantsRemaining,
    required this.chipsInPlay,
    required this.textColor,
    required this.nextDuration,
  });

  @override
  Widget build(BuildContext context) {
    final averageStack =
        entrantsRemaining == 0 ? 0 : (chipsInPlay / entrantsRemaining).floor();
    final bool nextIsBreak =
        nextSmallBlind == 0 && nextBigBlind == 0 && nextAnte == 0;

    int durationToMinutes(Duration duration) => duration.inMinutes;

    return Container(
      width: double.infinity, // ✅ 웹에서 가로로 꽉 차게
      padding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 16), // ✅ 높이 여유 있게
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Next Round',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nextIsBreak
                ? 'Break - ${durationToMinutes(nextDuration)} min'
                : '$nextSmallBlind / $nextBigBlind',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          if (!nextIsBreak)
            Text(
              'Ante: $nextAnte',
              style: TextStyle(
                fontSize: 18,
                color: textColor.withOpacity(0.7),
              ),
            ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Wrap(
            spacing: 32,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _InfoItem(
                  label: 'Entrants', value: entrants, textColor: textColor),
              _InfoItem(
                  label: 'Remaining',
                  value: entrantsRemaining,
                  textColor: textColor),
              _InfoItem(
                  label: 'Chips', value: chipsInPlay, textColor: textColor),
              _InfoItem(
                  label: 'Avg Stack',
                  value: averageStack,
                  textColor: textColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final int value;
  final Color textColor;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: textColor.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
