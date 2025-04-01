// TournamentScreen with responsive layout for all devices
import 'package:flutter/material.dart';
import 'package:holdem_timer/models/prize.dart';
import 'package:holdem_timer/services/timer_service.dart';
import 'package:holdem_timer/ui/screens/tournament_settings_screen.dart';
import 'package:holdem_timer/ui/widgets/blind_structure_table.dart';
import 'package:holdem_timer/ui/widgets/bottom_panel.dart';
import 'package:holdem_timer/ui/widgets/timer_adjustment_dialog.dart';
import 'package:holdem_timer/ui/widgets/timer_display.dart';
import 'package:holdem_timer/ui/widgets/prize_list.dart' as prize_widget;
import 'package:provider/provider.dart';

final List<PlayerPrize> playerPrizes = [
  PlayerPrize(
      rank: 1,
      name: '고영재',
      prizeMoney: 1000000,
      avatarUrl: 'https://i.pravatar.cc/150?img=1'),
  PlayerPrize(
      rank: 2,
      name: '홍진호',
      prizeMoney: 600000,
      avatarUrl: 'https://i.pravatar.cc/150?img=2'),
  PlayerPrize(
      rank: 3,
      name: '필아이비',
      prizeMoney: 400000,
      avatarUrl: 'https://i.pravatar.cc/150?img=3'),
  PlayerPrize(
      rank: 4,
      name: '탐드완',
      prizeMoney: 100000,
      avatarUrl: 'https://i.pravatar.cc/150?img=4'),
];

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 900;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: isWide ? _buildWideLayout(context) : _buildNarrowLayout(context),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    final timerService = context.watch<TimerService>();
    final currentRound =
        timerService.currentRound.clamp(1, timerService.blindLevels.length);
    final current = timerService.blindLevels[
        (currentRound - 1).clamp(0, timerService.blindLevels.length - 1)];
    final next = timerService.blindLevels[
        currentRound.clamp(0, timerService.blindLevels.length - 1)];

    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: BlindStructureTable(
              levels: timerService.blindLevels,
              currentRound: currentRound,
              textColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: TimerDisplay(
                  timeRemaining: timerService.remaining,
                  currentRound: currentRound,
                  progress: timerService.progress,
                  isRunning: timerService.isRunning,
                  isBreak: timerService.isCurrentRoundBreak,
                  onSeekTimer: (newDuration) {
                    timerService.setCustomTimer(
                        newDuration, timerService.currentRound);
                  },
                  onPause: () => timerService.isRunning
                      ? timerService.pauseTimer()
                      : timerService.startTimer(),
                  onSettings: () async {
                    final result = await Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TournamentSettingsScreen(
                          initialLevels: timerService.blindLevels,
                          initialEntrants: timerService.entrants,
                          initialChipsInPlay: timerService.chipsInPlay,
                          initialEntrantsRemaining:
                              timerService.entrantsRemaining,
                        ),
                      ),
                    );
                    if (result != null) {
                      timerService.updateFromSettings(
                        result['levels'],
                        result['entrants'],
                        result['chipsInPlay'],
                        result['entrantsRemaining'],
                      );
                    }
                  },
                  onEditTimer: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (_) => TimerAdjustmentDialog(
                        currentRound: currentRound,
                        currentDuration: timerService.remaining,
                      ),
                    );
                    if (result != null) {
                      timerService.setManualTimer(
                        round: result['round'],
                        duration: result['duration'],
                      );
                    }
                  },
                  onSkipRound: timerService.nextRound,
                  onPreviousRound: timerService.previousRound,
                  smallBlind: current.smallBlind,
                  bigBlind: current.bigBlind,
                  ante: current.ante,
                ),
              ),
              Expanded(
                flex: 2,
                child: BottomPanel(
                  smallBlind: current.smallBlind,
                  bigBlind: current.bigBlind,
                  ante: current.ante,
                  nextSmallBlind: next.smallBlind,
                  nextBigBlind: next.bigBlind,
                  nextAnte: next.ante,
                  entrants: timerService.entrants,
                  entrantsRemaining: timerService.entrantsRemaining,
                  chipsInPlay: timerService.chipsInPlay,
                  nextDuration: next.duration,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: prize_widget.PrizeList(
            players: playerPrizes,
            totalPrize: 3000000,
            textColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    final timerService = context.watch<TimerService>();
    final currentRound =
        timerService.currentRound.clamp(1, timerService.blindLevels.length);
    final current = timerService.blindLevels[
        (currentRound - 1).clamp(0, timerService.blindLevels.length - 1)];
    final next = timerService.blindLevels[
        currentRound.clamp(0, timerService.blindLevels.length - 1)];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TimerDisplay(
            timeRemaining: timerService.remaining,
            currentRound: currentRound,
            progress: timerService.progress,
            isRunning: timerService.isRunning,
            isBreak: timerService.isCurrentRoundBreak,
            onPause: () => timerService.isRunning
                ? timerService.pauseTimer()
                : timerService.startTimer(),
            onSettings: () async {
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => TournamentSettingsScreen(
                    initialLevels: timerService.blindLevels,
                    initialEntrants: timerService.entrants,
                    initialChipsInPlay: timerService.chipsInPlay,
                    initialEntrantsRemaining: timerService.entrantsRemaining,
                  ),
                ),
              );
              if (result != null) {
                timerService.updateFromSettings(
                  result['levels'],
                  result['entrants'],
                  result['chipsInPlay'],
                  result['entrantsRemaining'],
                );
              }
            },
            onEditTimer: () async {
              final result = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (_) => TimerAdjustmentDialog(
                  currentRound: currentRound,
                  currentDuration: timerService.remaining,
                ),
              );
              if (result != null) {
                timerService.setManualTimer(
                  round: result['round'],
                  duration: result['duration'],
                );
              }
            },
            onSkipRound: timerService.nextRound,
            onPreviousRound: timerService.previousRound,
            smallBlind: current.smallBlind,
            bigBlind: current.bigBlind,
            ante: current.ante,
            onSeekTimer: (newDuration) {
              timerService.setCustomTimer(
                  newDuration, timerService.currentRound);
            },
          ),
          const SizedBox(height: 16),
          BottomPanel(
            smallBlind: current.smallBlind,
            bigBlind: current.bigBlind,
            ante: current.ante,
            nextSmallBlind: next.smallBlind,
            nextBigBlind: next.bigBlind,
            nextAnte: next.ante,
            entrants: timerService.entrants,
            entrantsRemaining: timerService.entrantsRemaining,
            chipsInPlay: timerService.chipsInPlay,
            nextDuration: next.duration,
            textColor: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          BlindStructureTable(
            levels: timerService.blindLevels,
            currentRound: currentRound,
            textColor: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          prize_widget.PrizeList(
            players: playerPrizes,
            totalPrize: 3000000,
            textColor: Theme.of(context).colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}
