import 'package:bidart/core/theme/app_colors.dart';
import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/screens/onboarding/onboarding_content.dart';
import 'package:bidart/screens/onboarding/widgets/onboarding_backdrop.dart';
import 'package:bidart/screens/onboarding/widgets/onboarding_bottom_bar.dart';
import 'package:bidart/screens/onboarding/widgets/onboarding_page.dart';
import 'package:bidart/screens/onboarding/widgets/onboarding_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

/// What the user chose when leaving the first-run introduction.
enum OnboardingExit { explore, createRoom }

/// First-run introduction with five pages and a replay mode.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.replay = false, this.onFinish});

  /// When true the screen is pushed from Settings: it shows a close action and
  /// pops instead of switching the app's home.
  final bool replay;

  /// Called after the last page is completed. Only used when [replay] is false.
  final Future<void> Function(OnboardingExit exit)? onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  static const _pageDuration = Duration(milliseconds: 380);
  static const _reducedPageDuration = Duration(milliseconds: 200);

  final PageController _pageController = PageController();
  late final AnimationController _exitController;
  int _index = 0;
  bool _finishing = false;

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  Duration get _pageAnimationDuration =>
      _reduceMotion ? _reducedPageDuration : _pageDuration;

  bool get _isLast => _index == onboardingPages.length - 1;

  @override
  void initState() {
    super.initState();
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: 1,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (!mounted) return;
    setState(() => _index = index);
    if (!_reduceMotion) {
      HapticFeedback.selectionClick();
    }
    SemanticsService.sendAnnouncement(
      View.of(context),
      'Trang ${index + 1} trên ${onboardingPages.length}: '
      '${onboardingPages[index].title.replaceAll('\n', ' ')}',
      TextDirection.ltr,
    );
  }

  void _goToPage(int index) {
    if (index == _index || !_pageController.hasClients) return;
    _pageController.animateToPage(
      index,
      duration: _pageAnimationDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  void _next() {
    if (_isLast) {
      _finish(OnboardingExit.createRoom);
      return;
    }
    _pageController.nextPage(
      duration: _pageAnimationDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  void _previous() {
    if (_index == 0) return;
    _goToPage(_index - 1);
  }

  Future<void> _finish(OnboardingExit exit) async {
    if (_finishing) return;
    setState(() => _finishing = true);

    if (!_reduceMotion) {
      HapticFeedback.lightImpact();
      await _exitController.reverse();
    } else {
      _exitController.value = 0;
    }

    if (!mounted) return;

    if (widget.replay) {
      Navigator.of(context).maybePop();
      return;
    }

    await widget.onFinish?.call(exit);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _reduceMotion;

    return PopScope(
      canPop: widget.replay || _index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _previous();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.darkSurface,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Theme(
          data: AppTheme.dark,
          child: Scaffold(
            key: const ValueKey('onboarding-screen'),
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                OnboardingBackdrop(
                  controller: _pageController,
                  pageCount: onboardingPages.length,
                ),
                SafeArea(
                  child: FadeTransition(
                    opacity: _exitController,
                    child: Column(
                      children: [
                        OnboardingTopBar(
                          replay: widget.replay,
                          showSkip: !_isLast,
                          onSkip: () => _finish(OnboardingExit.explore),
                          onClose: () => _finish(OnboardingExit.explore),
                        ),
                        Expanded(
                          child: IgnorePointer(
                            ignoring: _finishing,
                            child: PageView.builder(
                              key: const ValueKey('onboarding-page-view'),
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              itemCount: onboardingPages.length,
                              itemBuilder: (context, index) => Semantics(
                                container: true,
                                label:
                                    'Trang ${index + 1} trên '
                                    '${onboardingPages.length}',
                                child: OnboardingPage(
                                  key: ValueKey('onboarding-page-$index'),
                                  content: onboardingPages[index],
                                  index: index,
                                  pageController: _pageController,
                                  isActive: index == _index,
                                  enableMotion: !reduceMotion,
                                ),
                              ),
                            ),
                          ),
                        ),
                        OnboardingBottomBar(
                          content: onboardingPages[_index],
                          index: _index,
                          count: onboardingPages.length,
                          replay: widget.replay,
                          enabled: !_finishing,
                          onPrimary: _next,
                          onSecondary: () => _finish(OnboardingExit.explore),
                          onDotTap: _goToPage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
