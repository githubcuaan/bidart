import 'package:flutter/material.dart';

/// Rounded, outlined block used to group one section of a form.
///
/// Matches the frame of [BallRulesEditor] so every large block on a page reads
/// as the same kind of card.
class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.description,
    this.header,
    this.trailing,
    this.collapsible = true,
    this.initiallyExpanded = true,
  });

  static const padding = 12.0;

  final IconData? icon;
  final Widget child;
  final String? title;
  final String? description;

  /// Optional widget on the right side of the header row (e.g. a badge or action).
  final Widget? trailing;

  /// Rendered between the top header row and [child] (e.g. a validation error).
  final Widget? header;

  /// Cards with a header can collapse. Defaults to enabled.
  final bool collapsible;

  /// Initial state for collapsible cards. Defaults to open.
  final bool initiallyExpanded;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 220);

  late bool _expanded = widget.initiallyExpanded;
  late final AnimationController _controller;
  late final CurvedAnimation _sizeAnimation;
  late final CurvedAnimation _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
      value: _expanded ? 1 : 0,
    );
    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant SectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _expanded = widget.initiallyExpanded;
      _controller.value = _expanded ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _sizeAnimation.dispose();
    _fadeAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasTopRow =
        widget.icon != null ||
        widget.title != null ||
        widget.description != null ||
        widget.trailing != null;
    final canCollapse = widget.collapsible && hasTopRow;

    return Container(
      padding: const EdgeInsets.all(SectionCard.padding),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTopRow) _header(context, scheme, canCollapse),
          if (canCollapse) _collapsibleBody(hasTopRow) else _body(hasTopRow),
        ],
      ),
    );
  }

  Widget _collapsibleBody(bool hasTopRow) {
    return AnimatedBuilder(
      animation: _controller,
      child: _body(hasTopRow),
      builder: (context, child) {
        // Keep the body in the tree once collapsed so its state survives, but
        // take it out of the widgets tree's semantics and finders.
        final collapsed = _controller.value == 0;
        return SizeTransition(
          sizeFactor: _sizeAnimation,
          alignment: Alignment.topLeft,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Offstage(offstage: collapsed, child: child),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, ColorScheme scheme, bool canCollapse) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: canCollapse ? _toggle : null,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, size: 22, color: scheme.primary),
                  ),
                  if (widget.title != null || widget.description != null) ...[
                    const SizedBox(width: 12),
                  ],
                ],
                if (widget.title != null || widget.description != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null)
                          Text(
                            widget.title!,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        if (widget.title != null &&
                            widget.description != null) ...[
                          const SizedBox(height: 2),
                        ],
                        if (widget.description != null)
                          Text(
                            widget.description!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.trailing != null) ...[
          const SizedBox(width: 8),
          widget.trailing!,
        ],
        if (canCollapse)
          IconButton(
            tooltip: _expanded ? 'Thu gọn' : 'Mở rộng',
            onPressed: _toggle,
            visualDensity: VisualDensity.compact,
            icon: AnimatedRotation(
              turns: _expanded ? 0 : 0.5,
              duration: _animationDuration,
              child: const Icon(Icons.expand_less),
            ),
          ),
      ],
    );
  }

  Widget _body(bool hasTopRow) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (widget.header != null) ...[
        if (hasTopRow) const SizedBox(height: 6),
        widget.header!,
      ],
      if (hasTopRow || widget.header != null) const SizedBox(height: 12),
      widget.child,
    ],
  );
}
