import 'package:bidart/widgets/card/section_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Optional time/score limits.
///
/// [duration] still stores the raw number of seconds so the draft and
/// validation logic stay unchanged; the chips only edit that value.
class EndConditionsFields extends StatelessWidget {
  const EndConditionsFields({
    super.key,
    required this.duration,
    required this.threshold,
    required this.enabled,
    required this.durationError,
    required this.thresholdError,
    required this.onChanged,
  });

  final TextEditingController duration;
  final TextEditingController threshold;
  final bool enabled;
  final String? durationError;
  final String? thresholdError;
  final VoidCallback onChanged;

  static const _presets = <int>[3600, 5400, 7200, 10800];

  int? get _durationSeconds {
    final seconds = int.tryParse(duration.text.trim());
    return seconds != null && seconds > 0 ? seconds : null;
  }

  void _setDuration(int? seconds) {
    duration.text = seconds?.toString() ?? '';
    onChanged();
  }

  Future<void> _pickCustomDuration(BuildContext context) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _DurationPickerSheet(
        initialDurationSeconds: _durationSeconds ?? 3600,
      ),
    );
    if (picked != null) _setDuration(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final seconds = _durationSeconds;
    final isCustom = seconds != null && !_presets.contains(seconds);

    return SectionCard(
      icon: Icons.flag_outlined,
      title: 'Điều kiện kết thúc',
      description:
          'Chọn “Không giới hạn” hoặc để trống ngưỡng điểm nếu không muốn '
          'giới hạn.',
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thời lượng',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _DurationChip(
                  key: const ValueKey('duration-unlimited'),
                  label: 'Không giới hạn',
                  selected: seconds == null,
                  enabled: enabled,
                  onSelected: () => _setDuration(null),
                ),
                for (final preset in _presets)
                  _DurationChip(
                    key: ValueKey('duration-$preset'),
                    label: _presetLabel(preset),
                    selected: seconds == preset,
                    enabled: enabled,
                    onSelected: () => _setDuration(preset),
                  ),
                _DurationChip(
                  key: const ValueKey('duration-custom'),
                  label: isCustom ? _formatDuration(seconds) : 'Tùy chỉnh',
                  icon: isCustom ? null : Icons.edit_outlined,
                  selected: isCustom,
                  enabled: enabled,
                  onSelected: () => _pickCustomDuration(context),
                ),
              ],
            ),
            if (durationError case final error?) ...[
              const SizedBox(height: 8),
              Text(
                error,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              key: const ValueKey('score-threshold'),
              controller: threshold,
              enabled: enabled,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.emoji_events_outlined),
                labelText: 'Ngưỡng điểm (tùy chọn)',
                errorText: thresholdError,
              ),
              onChanged: (_) => onChanged(),
            ),
          ],
        ),
      ),
    );
  }

  static String _presetLabel(int seconds) => switch (seconds) {
    3600 => '1 tiếng',
    5400 => '1 tiếng 30 phút',
    7200 => '2 tiếng',
    10800 => '3 tiếng',
    _ => _formatDuration(seconds),
  };

  static String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    final parts = [
      if (hours > 0) '$hours giờ',
      if (minutes > 0) '$minutes phút',
      if (remainingSeconds > 0) '$remainingSeconds giây',
    ];
    return parts.isEmpty ? '0 giây' : parts.join(' ');
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    super.key,
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: true,
      checkmarkColor: scheme.primary,
      selectedColor: scheme.primaryContainer,
      backgroundColor: Colors.transparent,
      side: BorderSide(
        color: selected ? Colors.transparent : scheme.outlineVariant,
      ),
      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
      ),
      avatar: icon == null ? null : Icon(icon, size: 18),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onSelected: enabled ? (_) => onSelected() : null,
    );
  }
}

/// Two iOS-style wheels for hours and minutes, opened by the "Tùy chỉnh" chip.
class _DurationPickerSheet extends StatefulWidget {
  const _DurationPickerSheet({required this.initialDurationSeconds});

  final int initialDurationSeconds;

  @override
  State<_DurationPickerSheet> createState() => _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<_DurationPickerSheet> {
  static const _maxHours = 23;
  static const _minuteStep = 5;
  static const _itemExtent = 40.0;

  late final FixedExtentScrollController _hoursController;
  late final FixedExtentScrollController _minutesController;
  late int _hours;
  late int _minutes;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDurationSeconds;
    _hours = (initial ~/ 3600).clamp(0, _maxHours);
    _minutes = (((initial % 3600) ~/ 60) / _minuteStep).round() * _minuteStep;
    if (_minutes >= 60) _minutes = 55;
    _hoursController = FixedExtentScrollController(initialItem: _hours);
    _minutesController = FixedExtentScrollController(
      initialItem: _minutes ~/ _minuteStep,
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  int get _totalSeconds => _hours * 3600 + _minutes * 60;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Chọn thời lượng chơi',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: _itemExtent * 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                IgnorePointer(
                  child: Container(
                    height: _itemExtent,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        key: const ValueKey('duration-hours-picker'),
                        scrollController: _hoursController,
                        itemExtent: _itemExtent,
                        selectionOverlay: const SizedBox.shrink(),
                        onSelectedItemChanged: (index) =>
                            setState(() => _hours = index),
                        children: [
                          for (var hour = 0; hour <= _maxHours; hour++)
                            Text(
                              '$hour giờ',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        key: const ValueKey('duration-minutes-picker'),
                        scrollController: _minutesController,
                        itemExtent: _itemExtent,
                        selectionOverlay: const SizedBox.shrink(),
                        onSelectedItemChanged: (index) =>
                            setState(() => _minutes = index * _minuteStep),
                        children: [
                          for (
                            var minute = 0;
                            minute < 60;
                            minute += _minuteStep
                          )
                            Text(
                              '${minute.toString().padLeft(2, '0')} phút',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const ValueKey('confirm-duration'),
              onPressed: _totalSeconds == 0
                  ? null
                  : () => Navigator.of(context).pop(_totalSeconds),
              child: const Text('Xác nhận'),
            ),
          ),
        ],
      ),
    );
  }
}
