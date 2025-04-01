// 파일: ui/widgets/timer_adjustment_dialog.dart

import 'package:flutter/material.dart';

class TimerAdjustmentDialog extends StatefulWidget {
  final int currentRound;
  final Duration currentDuration;

  const TimerAdjustmentDialog({
    super.key,
    required this.currentRound,
    required this.currentDuration,
  });

  @override
  State<TimerAdjustmentDialog> createState() => _TimerAdjustmentDialogState();
}

class _TimerAdjustmentDialogState extends State<TimerAdjustmentDialog> {
  late int round;
  late int minutes;
  late int seconds;

  @override
  void initState() {
    super.initState();
    round = widget.currentRound;
    minutes = widget.currentDuration.inMinutes;
    seconds = widget.currentDuration.inSeconds % 60;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('타이머 수동 설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: round.toString(),
            decoration: const InputDecoration(labelText: '현재 라운드'),
            keyboardType: TextInputType.number,
            onChanged: (v) => round = int.tryParse(v) ?? round,
          ),
          TextFormField(
            initialValue: minutes.toString(),
            decoration: const InputDecoration(labelText: '분'),
            keyboardType: TextInputType.number,
            onChanged: (v) => minutes = int.tryParse(v) ?? minutes,
          ),
          TextFormField(
            initialValue: seconds.toString(),
            decoration: const InputDecoration(labelText: '초'),
            keyboardType: TextInputType.number,
            onChanged: (v) => seconds = int.tryParse(v) ?? seconds,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'round': round,
              'duration': Duration(minutes: minutes, seconds: seconds),
            });
          },
          child: const Text('적용'),
        ),
      ],
    );
  }
}
