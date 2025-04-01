import 'package:flutter/material.dart';
import 'package:holdem_timer/models/blind_level.dart';
import 'package:holdem_timer/models/blind_preset.dart';
import 'package:holdem_timer/services/user_preset_service.dart';
import 'package:holdem_timer/ui/widgets/preset_tab.dart';

class TournamentSettingsScreen extends StatefulWidget {
  final List<BlindLevel> initialLevels;
  final int initialEntrants;
  final int initialChipsInPlay;
  final int initialEntrantsRemaining;

  const TournamentSettingsScreen({
    super.key,
    required this.initialLevels,
    required this.initialEntrants,
    required this.initialChipsInPlay,
    required this.initialEntrantsRemaining,
  });

  @override
  _TournamentSettingsScreenState createState() =>
      _TournamentSettingsScreenState();
}

class _TournamentSettingsScreenState extends State<TournamentSettingsScreen>
    with SingleTickerProviderStateMixin {
  late List<BlindLevel> levels;
  late int entrants;
  late int chipsInPlay;
  late int entrantsRemaining;

  late TabController _tabController;
  final TextEditingController _presetNameController = TextEditingController();
  final TextEditingController _presetDescriptionController =
      TextEditingController();
  final GlobalKey<PresetTabState> _presetTabKey = GlobalKey<PresetTabState>();

  @override
  void initState() {
    super.initState();
    levels = List<BlindLevel>.from(widget.initialLevels);
    entrants = widget.initialEntrants;
    chipsInPlay = widget.initialChipsInPlay;
    entrantsRemaining = widget.initialEntrantsRemaining;
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _savePreset() async {
    final name = _presetNameController.text.trim();
    final description = _presetDescriptionController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a preset name.')),
      );
      return;
    }

    final service = UserPresetService();
    await service.savePreset(
      BlindPreset(
        name: name,
        description: description,
        levels: List<BlindLevel>.from(levels),
      ),
    );
    _presetTabKey.currentState?.loadPresets();

    _presetNameController.clear();
    _presetDescriptionController.clear();

    // 즉시 업데이트
    _presetTabKey.currentState?.loadPresets();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preset saved!')),
    );
  }

  void _addRound() {
    setState(() {
      levels.add(
        BlindLevel(
          round: levels.length + 1,
          duration: const Duration(minutes: 10),
          smallBlind: 100,
          bigBlind: 200,
          ante: 25,
          isBreak: false,
        ),
      );
    });
  }

  void _addBreak() {
    setState(() {
      levels.add(
        BlindLevel(
          round: levels.length + 1,
          duration: const Duration(minutes: 5),
          smallBlind: 0,
          bigBlind: 0,
          ante: 0,
          isBreak: true,
        ),
      );
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = levels.removeAt(oldIndex);
      levels.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
      for (int i = 0; i < levels.length; i++) {
        levels[i] = levels[i].copyWith(round: i + 1);
      }
    });
  }

  Widget _buildNumberField(dynamic value, Function(String) onChanged,
      {String? label}) {
    return SizedBox(
      width: 48,
      child: Column(
        children: [
          if (label != null)
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          TextFormField(
            key: ValueKey(value), // 값이 바뀔 때마다 재생성을 위해 키 지정
            initialValue: value.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(isDense: true),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow(int index) {
    final level = levels[index];

    return Container(
      color: level.isBreak ? const Color(0xFF37474F) : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 24, child: Text('${index + 1}')),
          const SizedBox(width: 4),
          if (!level.isBreak) ...[
            _buildNumberField(level.smallBlind, (val) {
              final parsed = int.tryParse(val) ?? 0;
              setState(() {
                levels[index] =
                    level.copyWith(smallBlind: parsed < 1 ? 1 : parsed);
              });
            }, label: 'SB'),
            const SizedBox(width: 4),
            _buildNumberField(level.bigBlind, (val) {
              final parsed = int.tryParse(val) ?? 0;
              setState(() {
                levels[index] =
                    level.copyWith(bigBlind: parsed < 1 ? 1 : parsed);
              });
            }, label: 'BB'),
            const SizedBox(width: 4),
            _buildNumberField(level.ante, (val) {
              final parsed = int.tryParse(val) ?? 0;
              setState(() {
                levels[index] = level.copyWith(ante: parsed < 0 ? 0 : parsed);
              });
            }, label: 'Ante'),
          ] else ...[
            const Text("Break",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(width: 12),
          ],
          const SizedBox(width: 4),
          _buildNumberField(
            ((level.duration.inSeconds) / 60).toStringAsFixed(1),
            (val) {
              final parsed = double.tryParse(val);
              if (parsed != null && parsed > 0) {
                final minutes = parsed.floor();
                final seconds = ((parsed - minutes) * 60).round();
                setState(() {
                  levels[index] = level.copyWith(
                    duration: Duration(minutes: minutes, seconds: seconds),
                  );
                });
              }
            },
            label: 'Min',
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () {
              setState(() {
                levels.removeAt(index);
                for (int j = 0; j < levels.length; j++) {
                  levels[j] = levels[j].copyWith(round: j + 1);
                }
              });
            },
          ),
          const Icon(Icons.drag_handle, size: 20),
        ],
      ),
    );
  }

  Widget _buildSavePresetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Save Current Structure as Preset',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _presetNameController,
          decoration: const InputDecoration(
            labelText: 'Preset Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _presetDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _savePreset,
          icon: const Icon(Icons.save),
          label: const Text('Save Preset'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.of(context).pop({
                'levels': levels,
                'entrants': entrants,
                'chipsInPlay': chipsInPlay,
                'entrantsRemaining': entrantsRemaining,
              });
            },
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Custom'),
            Tab(text: 'Presets'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Custom 구조 탭
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildSavePresetSection(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addRound,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Round"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _addBreak,
                      icon: const Icon(Icons.timer),
                      label: const Text("Add Break"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(width: 24, child: Text('#')),
                      SizedBox(width: 48, child: Text('SB')),
                      SizedBox(width: 48, child: Text('BB')),
                      SizedBox(width: 48, child: Text('Ante')),
                      SizedBox(width: 48, child: Text('Min')),
                      Spacer(),
                      Text('Actions'),
                    ],
                  ),
                ),
                const Divider(),
                // ReorderableListView의 높이를 고정하지 않고 Expanded로 감싸서
                // 남은 공간에 맞게 조정합니다.
                Expanded(
                  child: ReorderableListView(
                    onReorder: _onReorder,
                    buildDefaultDragHandles: false,
                    children: List.generate(levels.length, (index) {
                      return ReorderableDragStartListener(
                        key: ValueKey('level_$index'),
                        index: index,
                        child: _buildEditableRow(index),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          // Presets 탭 (바텀 오버플로우 해결)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // PresetTab 위젯이 남은 공간 전체를 채우도록 Expanded로 감쌉니다.
                Expanded(
                  child: PresetTab(
                    key: _presetTabKey,
                    currentLevels: levels,
                    onPresetSelected: (presetLevels) {
                      setState(() {
                        levels = List<BlindLevel>.from(presetLevels);
                        for (int i = 0; i < levels.length; i++) {
                          levels[i] = levels[i].copyWith(round: i + 1);
                        }
                        _tabController.index = 0;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
