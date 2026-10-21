import 'dart:async';

import 'package:flutter/material.dart';

/// Live remaining time for a running room.
///
/// Uses hours/minutes while at least an hour is left, then minutes/seconds.
/// Finished rooms show the configured limit instead of a frozen countdown.
/// [compact] renders only a clock value (`1:30:00` / `59:59`) for badges.
class RoomDurationCountdown extends StatefulWidget {
  const RoomDurationCountdown({
    super.key,
    required this.startedAt,
    required this.durationSeconds,
    required this.active,
    required this.now,
    this.compact = false,
  });

  final DateTime startedAt;
  final int durationSeconds;
  final bool active;
  final DateTime Function() now;
  final bool compact;

  @override
  State<RoomDurationCountdown> createState() => _RoomDurationCountdownState();
}

class _RoomDurationCountdownState extends State<RoomDurationCountdown> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _calculateRemaining();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant RoomDurationCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startedAt != widget.startedAt ||
        oldWidget.durationSeconds != widget.durationSeconds ||
        oldWidget.active != widget.active) {
      _remaining = _calculateRemaining();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration _calculateRemaining() {
    final left = widget.startedAt
        .add(Duration(seconds: widget.durationSeconds))
        .difference(widget.now());
    return left.isNegative ? Duration.zero : left;
  }

  void _startTimer() {
    _timer?.cancel();
    if (!widget.active || _remaining == Duration.zero) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final next = _calculateRemaining();
    // Compact badges include seconds even over an hour, so they must rebuild
    // every second. The full label only shows hours/minutes in that case.
    final changed = widget.compact
        ? next.inSeconds != _remaining.inSeconds
        : _format(next) != _format(_remaining);
    if (!changed) return;
    if (next == Duration.zero) _timer?.cancel();
    setState(() => _remaining = next);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final duration = active
        ? _remaining
        : Duration(seconds: widget.durationSeconds);
    if (widget.compact) return Text(_formatCompact(duration));
    return Text(
      '${active ? 'Thời lượng còn lại' : 'Thời lượng'}: '
      '${_format(duration)}',
    );
  }

  static String _formatCompact(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final hours = totalSeconds ~/ Duration.secondsPerHour;
    final minutes =
        (totalSeconds % Duration.secondsPerHour) ~/ Duration.secondsPerMinute;
    final seconds = totalSeconds % Duration.secondsPerMinute;
    final clock =
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
    return hours > 0 ? '$hours:$clock' : clock;
  }

  static String _format(Duration duration) {
    final totalSeconds = duration.inSeconds;
    if (totalSeconds >= Duration.secondsPerHour) {
      final hours = totalSeconds ~/ Duration.secondsPerHour;
      final minutes =
          (totalSeconds % Duration.secondsPerHour) ~/ Duration.secondsPerMinute;
      return '$hours giờ ${minutes.toString().padLeft(2, '0')} phút';
    }
    final minutes = totalSeconds ~/ Duration.secondsPerMinute;
    final seconds = totalSeconds % Duration.secondsPerMinute;
    return '$minutes phút ${seconds.toString().padLeft(2, '0')} giây';
  }
}
