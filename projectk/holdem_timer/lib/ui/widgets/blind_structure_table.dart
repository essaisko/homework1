import 'package:flutter/material.dart';
import '../../models/blind_level.dart';

class BlindStructureTable extends StatelessWidget {
  final List<BlindLevel> levels;
  final int currentRound;
  final Color textColor;

  const BlindStructureTable({
    super.key,
    required this.levels,
    required this.currentRound,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STRUCTURE',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(height: 12),
        Table(
          columnWidths: const {
            0: FixedColumnWidth(50),
            1: FixedColumnWidth(70),
            2: FixedColumnWidth(70),
            3: FixedColumnWidth(50),
            4: FixedColumnWidth(70),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Colors.transparent),
              children: const [
                _HeaderCell('R'),
                _HeaderCell('SB'),
                _HeaderCell('BB'),
                _HeaderCell('A'),
                _HeaderCell('Time'),
              ],
            ),
            for (final level in levels)
              TableRow(
                decoration: BoxDecoration(
                  color: level.round == currentRound
                      ? Colors.red.withOpacity(0.2)
                      : Colors.transparent,
                ),
                children: [
                  _DataCell(
                    level.isBreak ? 'BREAK' : '${level.round}',
                    isBreak: level.isBreak,
                  ),
                  _DataCell(level.isBreak ? '-' : '${level.smallBlind}',
                      isBreak: level.isBreak),
                  _DataCell(level.isBreak ? '-' : '${level.bigBlind}',
                      isBreak: level.isBreak),
                  _DataCell(
                      level.isBreak
                          ? '-'
                          : (level.ante == 0 ? '-' : '${level.ante}'),
                      isBreak: level.isBreak),
                  _DataCell('${level.duration.inMinutes}:00',
                      isBreak: level.isBreak),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String value;
  final bool isBreak;

  const _DataCell(this.value, {this.isBreak = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isBreak ? Colors.grey : Colors.white,
          fontStyle: isBreak ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }
}
