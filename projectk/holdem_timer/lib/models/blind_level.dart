class BlindLevel {
  final int round;
  final int smallBlind;
  final int bigBlind;
  final int ante;
  final Duration duration;
  final bool isBreak;

  BlindLevel({
    required this.round,
    required this.smallBlind,
    required this.bigBlind,
    required this.ante,
    required this.duration,
    required this.isBreak,
  });

  // 🔽 JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'round': round,
      'smallBlind': smallBlind,
      'bigBlind': bigBlind,
      'ante': ante,
      'duration': duration.inSeconds, // Duration은 초 단위로 저장
      'isBreak': isBreak,
    };
  }

  // 🔽 JSON 역직렬화
  factory BlindLevel.fromJson(Map<String, dynamic> json) {
    return BlindLevel(
      round: json['round'],
      smallBlind: json['smallBlind'],
      bigBlind: json['bigBlind'],
      ante: json['ante'],
      duration: Duration(seconds: json['duration']),
      isBreak: json['isBreak'],
    );
  }

  // ✅ 복사본 생성 (round 값 수정 등에 유용)
  BlindLevel copyWith({
    int? round,
    int? smallBlind,
    int? bigBlind,
    int? ante,
    Duration? duration,
    bool? isBreak,
  }) {
    return BlindLevel(
      round: round ?? this.round,
      smallBlind: smallBlind ?? this.smallBlind,
      bigBlind: bigBlind ?? this.bigBlind,
      ante: ante ?? this.ante,
      duration: duration ?? this.duration,
      isBreak: isBreak ?? this.isBreak,
    );
  }
}
