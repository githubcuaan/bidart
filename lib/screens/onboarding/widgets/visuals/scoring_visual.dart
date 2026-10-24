import 'package:bidart/core/theme/app_colors.dart';
import 'package:bidart/widgets/room/ball_rules_editor/pool_ball_icon.dart';
import 'package:flutter/material.dart';

/// Scoreboard demo for the automatic-scoring page. Values are illustrative and
/// intentionally independent from the scoring engine.
class ScoringVisual extends StatefulWidget {
  const ScoringVisual({
    super.key,
    required this.isActive,
    required this.enableMotion,
  });

  final bool isActive;
  final bool enableMotion;

  @override
  State<ScoringVisual> createState() => _ScoringVisualState();
}

class _ScoringVisualState extends State<ScoringVisual>
    with SingleTickerProviderStateMixin {
  static const _rows = <_ScoreRow>[
    _ScoreRow(name: 'Tuấn Anh', delta: 30, isWinner: true),
    _ScoreRow(name: 'Huy Bida', delta: -10, isPayer: true),
    _ScoreRow(name: 'Minh Rasson', delta: -10),
    _ScoreRow(name: 'Hoàng Long', delta: -10),
  ];

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _sync();
  }

  @override
  void didUpdateWidget(covariant ScoringVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive ||
        oldWidget.enableMotion != widget.enableMotion) {
      _sync();
    }
  }

  void _sync() {
    if (!widget.enableMotion) {
      _controller
        ..stop()
        ..value = 1;
      return;
    }
    if (widget.isActive) {
      _controller.forward(from: 0);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _rowProgress(double t, int index) {
    final value = ((t - index * 0.12) / 0.52).clamp(0.0, 1.0).toDouble();
    return Curves.easeOutCubic.transform(value);
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 320,
        height: 320,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            final pop = Curves.easeOutBack.transform(
              ((t - 0.72) / 0.28).clamp(0.0, 1.0).toDouble(),
            );

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 10,
                  top: 44,
                  child: Transform.rotate(angle: -0.03, child: _scoreCard(t)),
                ),
                Positioned(
                  right: 4,
                  top: 14,
                  child: Transform.scale(
                    scale: 0.8 + pop * 0.2,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary.withValues(alpha: 0.16),
                          ),
                          child: const PoolBallIcon(ball: 9, size: 38),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.secondary.withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Text(
                            '+50đ',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _scoreCard(double t) {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceContainer.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.darkOnSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'VÒNG 4 • 9 BI',
                style: TextStyle(
                  color: AppColors.darkOnSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _rows.length; i++) _row(_rows[i], i, t),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.balance_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Tổng bàn: 0',
                  style: TextStyle(
                    color: AppColors.darkOnSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Huy Bida chịu đền',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.darkError.withValues(alpha: 0.9),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(_ScoreRow row, int index, double t) {
    final progress = _rowProgress(t, index);
    final value = (row.delta * progress).round();
    final score = value == 0
        ? '0'
        : value > 0
        ? '+$value'
        : '$value';
    final color = row.isWinner
        ? AppColors.primary
        : row.isPayer
        ? AppColors.darkError
        : AppColors.darkOnSurfaceVariant;

    return Opacity(
      opacity: (progress * 2).clamp(0.0, 1.0).toDouble(),
      child: Transform.translate(
        offset: Offset(0, (1 - progress) * 8),
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: row.isWinner
                ? AppColors.primary.withValues(alpha: 0.08)
                : row.isPayer
                ? AppColors.darkError.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: row.isPayer
                  ? AppColors.darkError.withValues(alpha: progress * 0.5)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.darkSurfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Text(
                  row.name.substring(0, 1),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.name,
                      style: const TextStyle(
                        color: AppColors.darkOnSurface,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (row.isPayer)
                      const Text(
                        'Người chịu đền',
                        style: TextStyle(
                          color: AppColors.darkError,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                score,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreRow {
  const _ScoreRow({
    required this.name,
    required this.delta,
    this.isWinner = false,
    this.isPayer = false,
  });

  final String name;
  final int delta;
  final bool isWinner;
  final bool isPayer;
}
