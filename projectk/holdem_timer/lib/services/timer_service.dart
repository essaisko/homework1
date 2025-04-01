import 'dart:async';
import 'package:flutter/material.dart';
import 'package:holdem_timer/models/blind_level.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:holdem_timer/services/audio_path.dart';

extension BlindLevelReindexExtension on List<BlindLevel> {
  List<BlindLevel> withReindexedRounds() {
    return asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      return level.copyWith(round: index + 1);
    }).toList();
  }
}

class TimerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _preloadedFile;

  List<BlindLevel> blindLevels;
  int currentRound = 1;
  Duration remaining;
  bool isRunning = false;
  Timer? _timer;
  bool get isCurrentRoundBreak => blindLevels[currentRound - 1].isBreak;
  bool _audioUnlocked = false;

  int entrants;
  int chipsInPlay;
  int entrantsRemaining;

  TimerService({
    required this.blindLevels,
    this.entrants = 0,
    this.chipsInPlay = 0,
    this.entrantsRemaining = 0,
  }) : remaining = blindLevels.first.duration;

  double get progress {
    final total = blindLevels[currentRound - 1].duration.inSeconds;
    final left = remaining.inSeconds;
    return 1.0 - (left / total);
  }

  Future<void> startTimer() async {
    if (_timer != null) return;

    await _unlockAndPrewarmAudio();

    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.inSeconds > 0) {
        remaining = Duration(seconds: remaining.inSeconds - 1);
      } else {
        nextRound(); // async OK
      }
      notifyListeners();
    });

    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    pauseTimer();
    currentRound = 1;
    remaining = blindLevels.first.duration;
    notifyListeners();
  }

  Future<void> preloadBlindChangeSound() async {
    final fileName = getWebCompatibleAudioPath();
    if (_preloadedFile == fileName) return; // 이미 로딩된 경우 무시

    try {
      await _audioPlayer.setSource(AssetSource(fileName));
      _preloadedFile = fileName;
      debugPrint('✅ 사운드 preload 성공: $fileName');
    } catch (e) {
      debugPrint('❌ preload 실패: $e');
    }
  }

  Future<void> _playBlindChangeFeedback() async {
    try {
      final fileName = getWebCompatibleAudioPath();
      await _audioPlayer.stop(); // 혹시 모를 중복 재생 방지
      await _audioPlayer.play(AssetSource(fileName));
      debugPrint('🔊 사운드 재생 완료');
    } catch (e) {
      debugPrint('❌ 사운드 재생 실패: $e');
    }

    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 500);
    }
  }

  Future<void> nextRound() async {
    if (currentRound < blindLevels.length) {
      currentRound++;
      remaining = blindLevels[currentRound - 1].duration;

      await Future.delayed(const Duration(milliseconds: 100));
      await _playBlindChangeFeedback();

      if (blindLevels[currentRound - 1].isBreak) {
        pauseTimer();
      }
    } else {
      pauseTimer();
    }

    notifyListeners();
  }

  void setManualTimer({required int round, required Duration duration}) {
    pauseTimer();
    currentRound = round;
    remaining = duration;
    notifyListeners();
  }

  void setCustomTimer(Duration duration, int round) {
    pauseTimer();
    currentRound = round;
    remaining = duration;
    notifyListeners();
  }

  void updateFromSettings(
    List<BlindLevel> newLevels,
    int newEntrants,
    int newChipsInPlay,
    int newEntrantsRemaining,
  ) {
    blindLevels = newLevels;
    entrants = newEntrants;
    chipsInPlay = newChipsInPlay;
    entrantsRemaining = newEntrantsRemaining;
    currentRound = 1; // ✅ 프리셋 로딩 시 현재 라운드 초기화
    remaining =
        blindLevels.isNotEmpty ? blindLevels[0].duration : Duration.zero;
    notifyListeners();
  }

  void previousRound() {
    if (currentRound > 1) {
      currentRound--;
      remaining = blindLevels[currentRound - 1].duration;
      notifyListeners();
    }
  }

  void updateLevels(List<BlindLevel> newLevels) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      blindLevels = newLevels.withReindexedRounds();
      notifyListeners();
    });
  }

  Future<void> _unlockAndPrewarmAudio() async {
    if (_audioUnlocked) return;

    try {
      final fileName = getWebCompatibleAudioPath();
      await _audioPlayer.setSource(AssetSource(fileName));
      await _audioPlayer.resume(); // 무음이더라도 resume으로 예열
      await _audioPlayer.stop();
      _preloadedFile = fileName;
      _audioUnlocked = true;
      debugPrint('🔓 오디오 잠금 해제 및 예열 완료');
    } catch (e) {
      debugPrint('❌ 오디오 unlock 실패: $e');
    }
  }

  bool get isBreakRound => blindLevels[currentRound - 1].isBreak;
}
