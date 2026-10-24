import 'dart:math' as math;

import 'package:bidart/core/theme/app_colors.dart';
import 'package:bidart/screens/onboarding/onboarding_content.dart';
import 'package:bidart/screens/onboarding/widgets/onboarding_illustration_frame.dart';
import 'package:bidart/screens/onboarding/widgets/visuals/discovery_visual.dart';
import 'package:bidart/screens/onboarding/widgets/visuals/ready_visual.dart';
import 'package:bidart/screens/onboarding/widgets/visuals/recording_visual.dart';
import 'package:bidart/screens/onboarding/widgets/visuals/scoring_visual.dart';
import 'package:bidart/screens/onboarding/widgets/visuals/welcome_visual.dart';
import 'package:flutter/material.dart';

/// One page of the introduction: animated illustration, copy and entrance
/// stagger. Navigation lives in [OnboardingScreen].
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
    required this.content,
    required this.index,
    required this.pageController,
    required this.isActive,
    required this.enableMotion,
  });

  final OnboardingPageContent content;
  final int index;
  final PageController pageController;
  final bool isActive;
  final bool enableMotion;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  static const _entranceDuration = Duration(milliseconds: 560);

  late final AnimationController _entrance;
  late final Animation<double> _visualFade;
  late final Animation<double> _visualScale;
  late final Animation<double> _eyebrowFade;
  late final Animation<double> _titleFade;
  late final Animation<double> _bodyFade;
  late final Animation<Offset> _eyebrowSlide;
  late final Animation<Offset> _titleSlide;
  late final Animation<Offset> _bodySlide;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(vsync: this, duration: _entranceDuration);
    _visualFade = _fade(0, 0.85);
    _visualScale = Tween<double>(begin: 0.94, end: 1).animate(_fade(0, 1));
    _eyebrowFade = _fade(0.08, 0.8);
    _titleFade = _fade(0.16, 0.9);
    _bodyFade = _fade(0.3, 1);
    _eyebrowSlide = _slide(0.08, 0.8, 10);
    _titleSlide = _slide(0.16, 0.9, 18);
    _bodySlide = _slide(0.3, 1, 12);

    if (widget.isActive) {
      _playEntrance();
    } else {
      _entrance.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant OnboardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.enableMotion && widget.enableMotion) {
      if (widget.isActive) _playEntrance();
      return;
    }
    if (oldWidget.enableMotion && !widget.enableMotion) {
      _entrance.value = 1;
      return;
    }
    if (!oldWidget.isActive && widget.isActive) {
      _playEntrance();
    }
  }

  void _playEntrance() {
    if (!widget.enableMotion) {
      _entrance.value = 1;
      return;
    }
    _entrance.forward(from: 0);
  }

  Animation<double> _fade(double begin, double end) => CurvedAnimation(
    parent: _entrance,
    curve: Interval(begin, end, curve: Curves.easeOutCubic),
  );

  Animation<Offset> _slide(double begin, double end, double distance) =>
      Tween<Offset>(
        begin: Offset(0, distance / 100),
        end: Offset.zero,
      ).animate(_fade(begin, end));

  double get _delta {
    if (!widget.pageController.hasClients) return 0;
    final page = widget.pageController.page;
    if (page == null) return 0;
    return page - widget.index;
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: widget.pageController,
      child: _buildContent(context, theme),
      builder: (context, child) {
        final opacity = (1 - _delta.abs() * 0.12).clamp(0.75, 1.0).toDouble();
        return Opacity(opacity: opacity, child: child);
      },
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    final scheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 520;
        final visualHeight = math.min(
          340.0,
          math.max(200.0, constraints.maxHeight * (compact ? 0.34 : 0.4)),
        );
        final titleSize = constraints.maxWidth < 360 ? 27.0 : 30.0;

        final eyebrow = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.content.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                widget.content.eyebrow,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: widget.content.accent,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  fontSize: 11,
                ),
              ),
            ),
            if (widget.content.comingSoon) ...[
              const SizedBox(width: 8),
              const _ComingSoonChip(),
            ],
          ],
        );

        final title = Text(
          widget.content.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: scheme.onSurface,
            fontSize: titleSize,
            height: 1.14,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        );

        final body = Text(
          widget.content.body,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontSize: 15,
            height: 1.5,
          ),
        );

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: math.max(0.0, constraints.maxHeight - 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: visualHeight,
                  width: double.infinity,
                  child: Center(
                    child: _parallax(
                      factor: 0.08,
                      child: FadeTransition(
                        opacity: _visualFade,
                        child: ScaleTransition(
                          scale: _visualScale,
                          child: OnboardingIllustrationFrame(
                            accent: widget.content.accent,
                            child: _visual(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: compact ? 18 : 26),
                _parallax(
                  factor: 0.03,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: _eyebrowFade,
                        child: SlideTransition(
                          position: _eyebrowSlide,
                          child: eyebrow,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: title,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _bodyFade,
                        child: SlideTransition(
                          position: _bodySlide,
                          child: body,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _parallax({required double factor, required Widget child}) {
    return AnimatedBuilder(
      animation: widget.pageController,
      child: child,
      builder: (context, child) {
        final width = MediaQuery.sizeOf(context).width;
        return Transform.translate(
          offset: Offset(-_delta * width * factor, 0),
          child: child,
        );
      },
    );
  }

  Widget _visual() {
    return MediaQuery.withNoTextScaling(
      child: switch (widget.content.visual) {
        OnboardingVisual.welcome => WelcomeVisual(
          isActive: widget.isActive,
          enableMotion: widget.enableMotion,
        ),
        OnboardingVisual.scoring => ScoringVisual(
          isActive: widget.isActive,
          enableMotion: widget.enableMotion,
        ),
        OnboardingVisual.recording => RecordingVisual(
          isActive: widget.isActive,
          enableMotion: widget.enableMotion,
        ),
        OnboardingVisual.discovery => DiscoveryVisual(
          isActive: widget.isActive,
          enableMotion: widget.enableMotion,
        ),
        OnboardingVisual.ready => ReadyVisual(
          isActive: widget.isActive,
          enableMotion: widget.enableMotion,
        ),
      },
    );
  }
}

class _ComingSoonChip extends StatelessWidget {
  const _ComingSoonChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.14),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'SẮP CÓ',
        style: TextStyle(
          color: AppColors.secondary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
