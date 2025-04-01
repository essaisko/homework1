import 'package:holdem_timer/models/blind_level.dart';

class BlindPreset {
  final String name;
  final String description;
  final List<BlindLevel> levels;

  BlindPreset({
    required this.name,
    required this.description,
    required this.levels,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'levels': levels.map((e) => e.toJson()).toList(),
    };
  }

  factory BlindPreset.fromJson(Map<String, dynamic> json) {
    return BlindPreset(
      name: json['name'],
      description: json['description'] ?? '', // ← 기존 데이터 호환성 위해 기본값 제공
      levels: (json['levels'] as List<dynamic>)
          .map((e) => BlindLevel.fromJson(e))
          .toList(),
    );
  }
}
