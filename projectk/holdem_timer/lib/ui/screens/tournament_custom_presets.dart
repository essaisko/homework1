import 'package:flutter/material.dart';
import 'package:holdem_timer/models/blind_level.dart';
import 'package:holdem_timer/models/blind_preset.dart';
import 'package:holdem_timer/services/user_preset_service.dart';

class PresetTab extends StatefulWidget {
  final void Function(List<BlindLevel>) onPresetSelected;

  const PresetTab({
    super.key,
    required this.onPresetSelected,
  });

  @override
  State<PresetTab> createState() => _PresetTabState();
}

class _PresetTabState extends State<PresetTab> {
  final UserPresetService _presetService = UserPresetService();

  final List<BlindPreset> defaultPresets = [
    BlindPreset(
      name: "Standard 20min",
      description: "표준 20분 프리셋",
      levels: List.generate(
        5,
        (i) => BlindLevel(
          round: i + 1,
          smallBlind: 100 * (i + 1),
          bigBlind: 200 * (i + 1),
          ante: 0,
          duration: const Duration(minutes: 20),
          isBreak: false,
        ),
      ),
    ),
    BlindPreset(
      name: "Fast Turbo",
      description: "빠른 터보 프리셋",
      levels: List.generate(
        5,
        (i) => BlindLevel(
          round: i + 1,
          smallBlind: 100 * (i + 1),
          bigBlind: 200 * (i + 1),
          ante: 0,
          duration: const Duration(minutes: 10),
          isBreak: false,
        ),
      ),
    ),
    BlindPreset(
      name: "Deep Stack",
      description: "딥 스택 프리셋",
      levels: List.generate(
        5,
        (i) => BlindLevel(
          round: i + 1,
          smallBlind: 25 * (i + 1),
          bigBlind: 50 * (i + 1),
          ante: 0,
          duration: const Duration(minutes: 30),
          isBreak: false,
        ),
      ),
    ),
  ];

  List<BlindPreset> userPresets = [];

  @override
  void initState() {
    super.initState();
    _loadUserPresets();
  }

  Future<void> _loadUserPresets() async {
    final presets = await _presetService.loadPresets();
    setState(() => userPresets = presets);
  }

  void _loadPreset(BlindPreset preset) {
    widget.onPresetSelected(preset.levels);
  }

  void _deletePreset(String name) async {
    await _presetService.deletePreset(name);
    await _loadUserPresets();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight - 32, // 패딩 고려
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('기본 프리셋',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...defaultPresets.map((preset) => _buildCard(preset)),
              const SizedBox(height: 24),
              if (userPresets.isNotEmpty) ...[
                const Text('내 프리셋',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...userPresets
                    .map((preset) => _buildCard(preset, deletable: true)),
              ],
              // 바닥에 여분의 공간 추가
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCard(BlindPreset preset, {bool deletable = false}) {
    final first = preset.levels.firstWhere(
      (level) => !level.isBreak,
      orElse: () => BlindLevel(
        round: 0,
        smallBlind: 0,
        bigBlind: 0,
        ante: 0,
        duration: Duration.zero,
        isBreak: false,
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(preset.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                if (deletable)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deletePreset(preset.name),
                  ),
              ],
            ),
            if (preset.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(preset.description,
                    style: TextStyle(color: Colors.grey[600])),
              ),
            Text('Rounds: ${preset.levels.length}'),
            Text('Starting Blinds: ${first.smallBlind} / ${first.bigBlind}'),
            Text('Duration: ${first.duration.inMinutes} min'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _loadPreset(preset),
                icon: const Icon(Icons.upload_rounded),
                label: const Text("불러오기"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
