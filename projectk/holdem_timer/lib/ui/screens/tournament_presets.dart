import 'package:holdem_timer/models/blind_preset.dart';
import 'package:holdem_timer/models/blind_level.dart';

final List<BlindPreset> tournamentPresets = [
  ...standardPresets,
  ...advancedPresets,
];

final List<BlindPreset> standardPresets = [
  BlindPreset(
    name: 'Standard 1',
    description: '10 people / 5,000 chips start (100BB) / 3 hours',
    levels: [
      _L(1, 25, 50, 0, 20),
      _L(2, 50, 100, 0, 20),
      _L(3, 75, 150, 0, 20),
      _L(4, 100, 200, 0, 20),
      _L(5, 200, 400, 0, 20),
      _L(6, 300, 600, 0, 20),
      _L(7, 500, 1000, 0, 20),
      _L(8, 800, 1600, 0, 20),
      _L(9, 1500, 3000, 0, 20),
      _L(10, 2000, 4000, 0, 20),
      _L(11, 3000, 6000, 0, 20),
      _L(12, 5000, 10000, 0, 20),
      _L(13, 10000, 20000, 0, 20),
    ],
  ),
  BlindPreset(
    name: 'Standard 2',
    description: '6 ~ 9 people / 25,000 chips start (125BB) / 5 hours',
    levels: [
      _L(1, 100, 200, 0, 20),
      _L(2, 200, 400, 0, 20),
      _L(3, 300, 600, 0, 20),
      _L(4, 400, 800, 0, 20),
      _L(5, 500, 1000, 0, 20),
      _L(6, 700, 1400, 0, 20),
      _L(7, 800, 1600, 0, 20),
      _k(10),
      _L(9, 1000, 2000, 0, 20),
      _L(10, 1500, 3000, 0, 20),
      _L(11, 2000, 4000, 0, 20),
      _L(12, 3000, 6000, 0, 20),
      _L(13, 4000, 8000, 0, 20),
      _L(14, 5000, 10000, 0, 20),
      _L(15, 7000, 14000, 0, 20),
      _L(16, 8000, 16000, 0, 20),
      _L(17, 10000, 20000, 0, 20),
    ],
  ),
  BlindPreset(
    name: 'Heads-Up Fast',
    description: '2,500 chips start (50BB) / 30 minutes',
    levels: [
      _L(1, 25, 50, 0, 10),
      _L(2, 50, 100, 0, 10),
      _L(3, 100, 200, 0, 10),
      _L(4, 200, 400, 0, 10),
    ],
  ),
  BlindPreset(
    name: 'Heads-Up Medium',
    description: '5,000 chips start (100BB) / 1 hours',
    levels: [
      _L(1, 25, 50, 0, 15),
      _L(2, 50, 100, 0, 15),
      _L(3, 75, 150, 0, 15),
      _L(4, 100, 200, 0, 15),
      _L(5, 150, 300, 0, 15),
    ],
  ),
  BlindPreset(
    name: 'Heads-Up Deep Stack',
    description: '10,000 chips start (200BB) / 2 hours',
    levels: [
      _L(1, 25, 50, 0, 20),
      _L(2, 50, 100, 0, 20),
      _L(3, 75, 150, 0, 20),
      _L(4, 100, 200, 0, 20),
      _L(5, 150, 300, 0, 20),
      _L(6, 200, 400, 0, 20),
    ],
  ),
];

/// 기본 레벨 생성 함수 (표준 프리셋용)
BlindLevel _L(int round, int sb, int bb, int ante, int min) => BlindLevel(
      round: round,
      smallBlind: sb,
      bigBlind: bb,
      ante: ante,
      duration: Duration(minutes: min),
      isBreak: false,
    );

final List<BlindPreset> advancedPresets = [
  BlindPreset(
    name: 'Pro Tournament (20 min)',
    description: '30 rounds, real-world structure with breaks.',
    levels: _buildWsopStylePreset(),
  ),
  BlindPreset(
    name: 'WSOP Main Event (120 min)',
    description: 'Real WSOP-style slow structure with 2-hour levels.',
    levels: _buildMainEventPreset(),
  ),
];

/// WSOP 스타일 프리셋 생성 (고급 프리셋용)
List<BlindLevel> _buildWsopStylePreset() {
  final levels = [
    _t(25, 50, 0, 20),
    _t(50, 100, 0, 20),
    _t(75, 150, 0, 20),
    _t(100, 200, 25, 20),
    _t(150, 300, 25, 20),
    _t(200, 400, 50, 20),
    _t(250, 500, 50, 20),
    _t(300, 600, 75, 20),
    _t(400, 800, 100, 20),
    _t(500, 1000, 100, 20),
    _k(15),
    _t(600, 1200, 200, 20),
    _t(800, 1600, 200, 20),
    _t(1000, 2000, 300, 20),
    _t(1200, 2400, 400, 20),
    _t(1500, 3000, 500, 20),
    _t(2000, 4000, 500, 20),
    _t(2500, 5000, 500, 20),
    _t(3000, 6000, 1000, 20),
    _t(4000, 8000, 1000, 20),
    _k(15),
    _t(5000, 10000, 1500, 20),
    _t(6000, 12000, 2000, 20),
    _t(8000, 16000, 2000, 20),
    _t(10000, 20000, 3000, 20),
    _t(12000, 24000, 4000, 20),
    _t(15000, 30000, 5000, 20),
    _t(20000, 40000, 5000, 20),
    _t(25000, 50000, 5000, 20),
    _t(30000, 60000, 10000, 20),
  ];
  return _buildStructureWithRounds(levels);
}

/// WSOP Main Event 스타일 프리셋 생성 (고급 프리셋용)
List<BlindLevel> _buildMainEventPreset() {
  final levels = [
    _t(100, 200, 0, 120),
    _t(200, 400, 0, 120),
    _t(300, 600, 0, 120),
    _t(400, 800, 100, 120),
    _t(500, 1000, 100, 120),
    _t(600, 1200, 200, 120),
    _k(20),
    _t(800, 1600, 200, 120),
    _t(1000, 2000, 300, 120),
    _t(1200, 2400, 400, 120),
    _t(1500, 3000, 500, 120),
    _t(2000, 4000, 500, 120),
    _k(20),
    _t(2500, 5000, 500, 120),
    _t(3000, 6000, 1000, 120),
    _t(4000, 8000, 1000, 120),
    _t(5000, 10000, 1500, 120),
    _t(6000, 12000, 2000, 120),
    _t(8000, 16000, 2000, 120),
    _k(20),
    _t(10000, 20000, 3000, 120),
    _t(12000, 24000, 4000, 120),
    _t(15000, 30000, 5000, 120),
  ];
  return _buildStructureWithRounds(levels);
}

/// 주어진 템플릿 리스트에 순차적인 라운드 번호를 할당하는 헬퍼
List<BlindLevel> _buildStructureWithRounds(List<BlindLevel> templates) =>
    templates
        .asMap()
        .entries
        .map((entry) => entry.value.copyWith(round: entry.key + 1))
        .toList();

/// 고급 프리셋용 일반 레벨 템플릿 생성
BlindLevel _t(int sb, int bb, int ante, int min) => BlindLevel(
      round: 0, // 나중에 _buildStructureWithRounds에서 번호 할당
      smallBlind: sb,
      bigBlind: bb,
      ante: ante,
      duration: Duration(minutes: min),
      isBreak: false,
    );

/// 고급 프리셋용 브레이크 레벨 템플릿 생성
BlindLevel _k(int min) => BlindLevel(
      round: 0,
      smallBlind: 0,
      bigBlind: 0,
      ante: 0,
      duration: Duration(minutes: min),
      isBreak: true,
    );
