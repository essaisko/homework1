import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:holdem_timer/models/blind_preset.dart';

class UserPresetService {
  static const _key = 'user_presets';

  Future<List<BlindPreset>> loadPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_key) ?? [];

    return rawList
        .map((jsonStr) {
          try {
            final map = json.decode(jsonStr);
            return BlindPreset.fromJson(map);
          } catch (_) {
            return null;
          }
        })
        .whereType<BlindPreset>()
        .toList();
  }

  Future<void> savePreset(BlindPreset preset) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    final filtered = existing.where((jsonStr) {
      try {
        final map = json.decode(jsonStr);
        return map['name'] != preset.name;
      } catch (_) {
        return true;
      }
    }).toList();

    filtered.add(json.encode(preset.toJson()));
    await prefs.setStringList(_key, filtered);
    final saved = prefs.getStringList(_key);
    print('✅ 저장된 프리셋 수: ${saved?.length}');
    for (final s in saved ?? []) {
      print('📦 $s');
    }
  }

  Future<void> deletePreset(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    final filtered = existing.where((jsonStr) {
      try {
        final map = json.decode(jsonStr);
        return map['name'] != name;
      } catch (_) {
        return true;
      }
    }).toList();

    await prefs.setStringList(_key, filtered);
  }
}
