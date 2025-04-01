import 'package:flutter/material.dart';
import 'package:holdem_timer/models/blind_level.dart';
import 'package:holdem_timer/models/blind_preset.dart';
import 'package:holdem_timer/services/user_preset_service.dart';
import 'package:holdem_timer/ui/screens/tournament_presets.dart';

class PresetTab extends StatefulWidget {
  final void Function(List<BlindLevel>) onPresetSelected;
  final List<BlindLevel> currentLevels;

  const PresetTab({
    super.key,
    required this.onPresetSelected,
    required this.currentLevels,
  });

  @override
  State<PresetTab> createState() => PresetTabState();
}

class PresetTabState extends State<PresetTab> {
  final _userService = UserPresetService();
  List<BlindPreset> _userPresets = [];
  // 0: Default Presets, 1: My Presets
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadPresets();
  }

  Future<void> loadPresets() async {
    final loaded = await _userService.loadPresets();
    setState(() {
      _userPresets = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    // tournamentPresets는 기본 프리셋 리스트입니다.
    final defaultPresets = tournamentPresets;
    final List<BlindPreset> currentPresets =
        _selectedIndex == 0 ? defaultPresets : _userPresets;

    return Column(
      children: [
        // 토글 버튼 영역
        ToggleButtons(
          isSelected: [
            _selectedIndex == 0,
            _selectedIndex == 1,
          ],
          onPressed: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(8),
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          selectedColor: Theme.of(context).colorScheme.primary,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Default Presets'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('My Presets'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 프리셋 리스트 영역
        Expanded(
          child: _buildPresetList(currentPresets, isUser: _selectedIndex == 1),
        ),
      ],
    );
  }

  Widget _buildPresetList(List<BlindPreset> presets, {required bool isUser}) {
    if (presets.isEmpty) {
      return const Center(child: Text('No presets found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: presets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) =>
          _buildPresetCard(presets[index], isUser: isUser),
    );
  }

  Widget _buildPresetCard(BlindPreset preset, {bool isUser = false}) {
    final firstPlayable = preset.levels.firstWhere(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              preset.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (preset.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                preset.description,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 8),
            Text('Rounds: ${preset.levels.length}'),
            Text(
                'Starting Blinds: ${firstPlayable.smallBlind} / ${firstPlayable.bigBlind}'),
            Text('Duration: ${firstPlayable.duration.inMinutes} min'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => widget.onPresetSelected(preset.levels),
                  icon: const Icon(Icons.upload_rounded),
                  label: const Text("Load Preset"),
                ),
                if (isUser)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete preset',
                    onPressed: () async {
                      await _userService.deletePreset(preset.name);
                      await loadPresets();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
