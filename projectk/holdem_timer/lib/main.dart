import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ⬅️ rootBundle 사용
import 'package:provider/provider.dart';
import 'services/theme_service.dart';
import 'services/timer_service.dart';
import 'ui/screens/tournament_screen.dart';
import 'models/blind_level.dart';

final List<BlindLevel> blindLevels = List.generate(12, (index) {
  return BlindLevel(
    round: index + 1,
    smallBlind: 100 + (index * 50),
    bigBlind: 250 + (index * 50),
    ante: (index < 5) ? 0 : 100 + index * 50,
    duration: const Duration(minutes: 10),
    isBreak: false,
  );
});

// ✅ 사운드 파일을 Flutter에 “정말 필요하다”고 알려주기 위한 강제 로딩
Future<void> forceLoadAsset() async {
  try {
    await rootBundle.load('sounds/blind_change.mp3');
    debugPrint('✅ 강제 로딩 성공!');
  } catch (e) {
    debugPrint('❌ 강제 로딩 실패: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await forceLoadAsset(); // 👈 얘가 핵심

  // ✅ preload 호출 (AudioPlayer 관점에서도 재생 준비)
  final dummyService = TimerService(blindLevels: blindLevels);
  await dummyService.preloadBlindChangeSound();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(
          create: (_) => TimerService(
            blindLevels: blindLevels,
            entrants: 1000,
            chipsInPlay: 200000,
          ),
        ),
      ],
      child: const PokerTimerApp(),
    ),
  );
}

class PokerTimerApp extends StatelessWidget {
  const PokerTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poker Timer',
      themeMode: themeService.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const TournamentScreen(),
    );
  }
}
