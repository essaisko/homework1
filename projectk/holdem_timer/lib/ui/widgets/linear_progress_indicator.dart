import 'package:flutter/material.dart';
import 'dart:math';

class TimerProgressBar extends StatefulWidget {
  final double progress; // 0.0 ~ 1.0
  final Duration totalDuration;
  final bool isBreak;
  final void Function(Duration) onSeek;

  const TimerProgressBar({
    super.key,
    required this.progress,
    required this.totalDuration,
    required this.isBreak,
    required this.onSeek,
  });

  @override
  State<TimerProgressBar> createState() => _TimerProgressBarState();
}

class _TimerProgressBarState extends State<TimerProgressBar> {
  double? _hoverRatio;

  void _seekFromGlobalPosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final localX = box.globalToLocal(globalPosition).dx;
    final width = box.size.width;

    double tappedRatio = (1.0 - (localX / width)).clamp(0.0, 1.0); // ✅ 반전
    final newSeconds = (widget.totalDuration.inSeconds * tappedRatio).round();
    widget.onSeek(Duration(seconds: newSeconds));
  }

  @override
  Widget build(BuildContext context) {
    final isHovering = _hoverRatio != null;
    final previewSeconds = (_hoverRatio != null)
        ? (widget.totalDuration.inSeconds * _hoverRatio!).round()
        : 0;
    final previewDuration = Duration(seconds: previewSeconds);

    final previewText =
        "${previewDuration.inMinutes}:${(previewDuration.inSeconds % 60).toString().padLeft(2, '0')}";

    return GestureDetector(
      onPanUpdate: (details) {
        _seekFromGlobalPosition(details.globalPosition);
      },
      onTapDown: (details) {
        _seekFromGlobalPosition(details.globalPosition);
      },
      child: MouseRegion(
        onHover: (event) {
          final box = context.findRenderObject() as RenderBox;
          final localX = box.globalToLocal(event.position).dx;
          final width = box.size.width;
          final ratio = (1.0 - (localX / width)).clamp(0.0, 1.0); // ✅ 반전
          setState(() {
            _hoverRatio = ratio;
          });
        },
        onExit: (_) {
          setState(() => _hoverRatio = null);
        },
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 16,
                child: LinearProgressIndicator(
                  value: widget.progress,
                  backgroundColor: widget.isBreak
                      ? Colors.lightBlue.shade100
                      : Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.isBreak ? Colors.lightBlueAccent : Colors.redAccent,
                  ),
                ),
              ),
            ),
            if (isHovering)
              Positioned(
                left: max(0, (_hoverRatio! * context.size!.width) - 32),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    previewText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
