import 'dart:math' as math;

import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_data.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_motion.dart';
import 'package:bidart/screens/rooms/in_room/turn_scores/turn_scores_player_row.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Player rows laid out by their current rotation position.
///
/// Rows keep their player key while their [RenderBox] offset is animated, so a
/// turn hand-off moves whole cards instead of rebuilding them in new slots.
class TurnScoresReorderColumn extends StatefulWidget {
  const TurnScoresReorderColumn({
    super.key,
    required this.entries,
    required this.data,
    this.spacing = 8,
  });

  final List<TurnScoreEntry> entries;
  final TurnScoreboardData data;
  final double spacing;

  @override
  State<TurnScoresReorderColumn> createState() =>
      _TurnScoresReorderColumnState();
}

class _TurnScoresReorderColumnState extends State<TurnScoresReorderColumn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _animation;
  final _snapshot = _TurnScoresLayoutSnapshot();
  late List<String> _order;
  Map<String, double> _oldTops = const {};

  List<String> get _nextOrder => [
    for (final entry in widget.entries) entry.player.id,
  ];

  @override
  void initState() {
    super.initState();
    _order = _nextOrder;
    _controller = AnimationController(
      vsync: this,
      duration: TurnScoresMotion.turn,
      value: 1,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: TurnScoresMotion.curve,
    );
  }

  @override
  void didUpdateWidget(covariant TurnScoresReorderColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextOrder = _nextOrder;
    if (!listEquals(_order, nextOrder)) {
      _order = nextOrder;
      _oldTops = Map.of(_snapshot.visualTops);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (context, child) => _TurnScoresAnimatedLayout(
      order: _order,
      oldTops: _oldTops,
      progress: _animation.value,
      spacing: widget.spacing,
      snapshot: _snapshot,
      children: [
        for (final entry in widget.entries)
          TurnScoresPlayerRow(
            key: ValueKey('turn-score-row-${entry.player.id}'),
            entry: entry,
            data: widget.data,
          ),
      ],
    ),
  );
}

/// Snapshot written during layout so the next turn change can start from the
/// cards' actual on-screen positions, including mid-animation restarts.
class _TurnScoresLayoutSnapshot {
  Map<String, double> visualTops = const {};
}

class _TurnScoresAnimatedLayout extends MultiChildRenderObjectWidget {
  const _TurnScoresAnimatedLayout({
    required this.order,
    required this.oldTops,
    required this.progress,
    required this.spacing,
    required this.snapshot,
    required super.children,
  });

  final List<String> order;
  final Map<String, double> oldTops;
  final double progress;
  final double spacing;
  final _TurnScoresLayoutSnapshot snapshot;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTurnScoresAnimatedLayout(
        order,
        oldTops,
        progress,
        spacing,
        snapshot,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderTurnScoresAnimatedLayout renderObject,
  ) {
    renderObject
      ..order = order
      ..oldTops = oldTops
      ..progress = progress
      ..spacing = spacing
      ..snapshot = snapshot;
  }
}

class _TurnScoresParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderTurnScoresAnimatedLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TurnScoresParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TurnScoresParentData> {
  _RenderTurnScoresAnimatedLayout(
    this._order,
    this._oldTops,
    this._progress,
    this._spacing,
    this._snapshot,
  );

  List<String> _order;
  Map<String, double> _oldTops;
  double _progress;
  double _spacing;
  _TurnScoresLayoutSnapshot _snapshot;

  List<String> get order => _order;
  set order(List<String> value) {
    if (listEquals(_order, value)) return;
    _order = value;
    markNeedsLayout();
  }

  Map<String, double> get oldTops => _oldTops;
  set oldTops(Map<String, double> value) {
    if (identical(_oldTops, value)) return;
    _oldTops = value;
    markNeedsLayout();
  }

  double get progress => _progress;
  set progress(double value) {
    if (_progress == value) return;
    _progress = value;
    markNeedsLayout();
  }

  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  _TurnScoresLayoutSnapshot get snapshot => _snapshot;
  set snapshot(_TurnScoresLayoutSnapshot value) {
    if (identical(_snapshot, value)) return;
    _snapshot = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TurnScoresParentData) {
      child.parentData = _TurnScoresParentData();
    }
  }

  @override
  void performLayout() {
    final boundedWidth = constraints.hasBoundedWidth;
    final width = boundedWidth ? constraints.maxWidth : 0.0;
    final childConstraints = boundedWidth
        ? BoxConstraints.tightFor(width: width)
        : constraints.loosen();

    var cursor = 0.0;
    var maxChildWidth = 0.0;
    var visualBottom = 0.0;
    final visualTops = <String, double>{};
    final progress = _progress.clamp(0.0, 1.0);

    RenderBox? child = firstChild;
    for (var index = 0; index < _order.length && child != null; index++) {
      child.layout(childConstraints, parentUsesSize: true);
      final targetTop = cursor;

      final oldTop = _oldTops[_order[index]];
      final top = oldTop == null
          ? targetTop
          : oldTop + (targetTop - oldTop) * progress;
      (child.parentData! as BoxParentData).offset = Offset(0, top);
      visualTops[_order[index]] = top;

      maxChildWidth = math.max(maxChildWidth, child.size.width);
      visualBottom = math.max(visualBottom, top + child.size.height);
      cursor = targetTop + child.size.height + _spacing;
      child = childAfter(child);
    }

    final targetHeight = _order.isEmpty
        ? 0.0
        : math.max(0.0, cursor - _spacing);
    final widthSize = boundedWidth ? width : maxChildWidth;
    final height = math.max(targetHeight, visualBottom);
    size = constraints.constrain(Size(widthSize, height));

    _snapshot.visualTops = visualTops;
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
