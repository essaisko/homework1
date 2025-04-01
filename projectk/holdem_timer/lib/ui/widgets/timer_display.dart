import 'package:flutter/material.dart';
import 'package:holdem_timer/main.dart';
import 'package:holdem_timer/models/blind_level.dart';

class TimerDisplay extends StatefulWidget {
  final Duration timeRemaining;
  final int currentRound;
  final double progress;
  final VoidCallback onPause;
  final VoidCallback onSettings;
  final VoidCallback onEditTimer;
  final VoidCallback onSkipRound;
  final bool isRunning;
  final bool isBreak;
  final VoidCallback onPreviousRound;
  final int smallBlind;
  final int bigBlind;
  final int ante;
  final void Function(Duration newDuration) onSeekTimer;

  const TimerDisplay({
    super.key,
    required this.timeRemaining,
    required this.currentRound,
    required this.progress,
    required this.onPause,
    required this.onSettings,
    required this.isRunning,
    required this.onEditTimer,
    required this.onSkipRound,
    required this.isBreak,
    required this.onPreviousRound,
    required this.smallBlind,
    required this.bigBlind,
    required this.ante,
    required this.onSeekTimer,
  });

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  double? _hoverX;
  Duration? _originalDuration;
  Duration? _pendingDuration;

  @override
  Widget build(BuildContext context) {
    final minutes = widget.timeRemaining.inMinutes.toString();
    final seconds =
        widget.timeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    final isWide = MediaQuery.of(context).size.width > 600;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final blindLevel = blindLevels[widget.currentRound - 1];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.isBreak
                              ? 'BREAK TIME'
                              : 'ROUND ${widget.currentRound}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: widget.isBreak
                                        ? Colors.lightBlueAccent
                                        : Colors.white70,
                                    fontSize: isWide ? 24 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$minutes:$seconds',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontSize: isWide ? 120 : 80,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isBreak
                                      ? Colors.lightBlue
                                      : Colors.white,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!widget.isBreak) ...[
                          Text('Current Blinds',
                              style: TextStyle(
                                  fontSize: isWide ? 22 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70)),
                          Text('${widget.smallBlind} / ${widget.bigBlind}',
                              style: TextStyle(
                                  fontSize: isWide ? 30 : 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text('Ante: ${widget.ante}',
                              style: TextStyle(
                                  fontSize: isWide ? 20 : 16,
                                  color: Colors.white70)),
                        ],
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LayoutBuilder(
                            builder: (context, progressConstraints) {
                              final barWidth = progressConstraints.maxWidth;

                              return SizedBox(
                                width: barWidth,
                                height: 50,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 17,
                                      left: 0,
                                      right: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: LinearProgressIndicator(
                                          value: widget.progress,
                                          minHeight: 16,
                                          backgroundColor: widget.isBreak
                                              ? Colors.lightBlue.shade100
                                              : Colors.grey[800],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            widget.isBreak
                                                ? Colors.lightBlueAccent
                                                : Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_hoverX != null && isWide)
                                      Positioned(
                                        left: (_hoverX! - 40)
                                            .clamp(0.0, barWidth - 80),
                                        top: -5,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: widget.isBreak
                                                  ? Colors.lightBlueAccent
                                                  : Colors.redAccent,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            _getNewTimeAtPosition(
                                                _hoverX!, barWidth, blindLevel),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    Positioned.fill(
                                      child: MouseRegion(
                                        onHover: isWide
                                            ? (e) {
                                                final RenderBox box =
                                                    context.findRenderObject()
                                                        as RenderBox;
                                                final Offset localPosition = box
                                                    .globalToLocal(e.position);
                                                setState(() {
                                                  _hoverX = localPosition.dx
                                                      .clamp(0, barWidth);
                                                });
                                              }
                                            : null,
                                        onExit: (_) =>
                                            setState(() => _hoverX = null),
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onPanStart: (details) {
                                            if (isMobile) {
                                              _originalDuration =
                                                  widget.timeRemaining;
                                            }
                                          },
                                          onPanUpdate: (details) {
                                            final RenderBox box =
                                                context.findRenderObject()
                                                    as RenderBox;
                                            final Offset localPosition =
                                                box.globalToLocal(
                                                    details.globalPosition);
                                            final ratio =
                                                (localPosition.dx / barWidth)
                                                    .clamp(0.0, 1.0);
                                            final totalSeconds =
                                                blindLevel.duration.inSeconds;
                                            final newRemaining =
                                                (totalSeconds * (1 - ratio))
                                                    .round();
                                            final newDuration =
                                                Duration(seconds: newRemaining);

                                            if (isWide) {
                                              widget.onSeekTimer(newDuration);
                                            } else {
                                              _pendingDuration = newDuration;
                                            }
                                          },
                                          onPanEnd: (_) async {
                                            if (!isWide &&
                                                _pendingDuration != null) {
                                              final confirmed =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text('타이머 변경'),
                                                  content: const Text(
                                                      '새 시간으로 변경하시겠습니까?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child: const Text('아니오'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      child: const Text('예'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirmed == true) {
                                                widget.onSeekTimer(
                                                    _pendingDuration!);
                                              } else if (_originalDuration !=
                                                  null) {
                                                widget.onSeekTimer(
                                                    _originalDuration!);
                                              }
                                              _pendingDuration = null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        TextButton.icon(
                          onPressed: widget.onPause,
                          icon: Icon(
                            widget.isRunning ? Icons.pause : Icons.play_arrow,
                            color: widget.isBreak
                                ? Colors.lightBlueAccent
                                : Colors.redAccent,
                          ),
                          label: Text(
                            widget.isRunning ? 'Pause Timer' : 'Resume Timer',
                            style: TextStyle(
                                color: widget.isBreak
                                    ? Colors.lightBlueAccent
                                    : Colors.redAccent),
                          ),
                        ),
                        TextButton(
                          onPressed: widget.onSettings,
                          child: const Text('Settings',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: widget.onEditTimer,
                          child: const Text('Edit Timer',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton.icon(
                          onPressed: widget.onSkipRound,
                          icon:
                              const Icon(Icons.skip_next, color: Colors.white),
                          label: const Text('Skip',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton.icon(
                          onPressed: widget.onPreviousRound,
                          icon: const Icon(Icons.undo, color: Colors.white),
                          label: const Text('Undo',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _getNewTimeAtPosition(
      double x, double barWidth, BlindLevel blindLevel) {
    final ratio = (x / barWidth).clamp(0.0, 1.0);
    final totalDuration = blindLevel.duration.inSeconds;
    final newSecondsRemaining = (totalDuration * (1 - ratio)).round();
    return _formatDuration(Duration(seconds: newSecondsRemaining));
  }
}
