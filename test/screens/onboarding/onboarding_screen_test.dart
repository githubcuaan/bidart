import 'package:bidart/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    bool replay = false,
    Future<void> Function(OnboardingExit exit)? onFinish,
    bool reduceMotion = true,
    bool settle = true,
    Size size = const Size(430, 900),
    double textScale = 1,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            disableAnimations: reduceMotion,
            textScaler: TextScaler.linear(textScale),
          ),
          child: OnboardingScreen(replay: replay, onFinish: onFinish),
        ),
      ),
    );
    await tester.pump();
    if (settle && reduceMotion) {
      await tester.pumpAndSettle();
    }
  }

  Future<void> tapNext(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('onboarding-primary-cta')));
    await tester.pumpAndSettle();
  }

  Future<void> goToLastPage(WidgetTester tester) async {
    for (var i = 0; i < 4; i++) {
      await tapNext(tester);
    }
  }

  testWidgets('starts on the welcome page', (tester) async {
    await pumpScreen(tester);

    expect(find.byKey(const ValueKey('onboarding-screen')), findsOneWidget);
    expect(find.text('Ghi điểm chuẩn.\nChơi hết mình.'), findsOneWidget);
    expect(find.text('Bắt đầu'), findsOneWidget);
    expect(find.byKey(const ValueKey('onboarding-skip')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('primary CTA advances to the next page', (tester) async {
    await pumpScreen(tester);

    await tapNext(tester);

    expect(find.textContaining('Không còn cãi nhau'), findsOneWidget);
    expect(find.text('Tiếp tục'), findsOneWidget);
  });

  testWidgets('swiping moves forward and back', (tester) async {
    await pumpScreen(tester);

    await tester.drag(
      find.byKey(const ValueKey('onboarding-page-view')),
      const Offset(-420, 0),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Không còn cãi nhau'), findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey('onboarding-page-view')),
      const Offset(420, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ghi điểm chuẩn.\nChơi hết mình.'), findsOneWidget);
  });

  testWidgets('tapping a dot jumps to that page', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byKey(const ValueKey('onboarding-dot-2')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Chọn người. Chọn bi.'), findsOneWidget);
  });

  testWidgets('last page shows the completion actions', (tester) async {
    await pumpScreen(tester);
    await goToLastPage(tester);

    expect(find.text('Vào bàn thôi.'), findsOneWidget);
    expect(find.text('Tạo phòng đầu tiên'), findsOneWidget);
    expect(find.text('Khám phá ứng dụng'), findsOneWidget);
    expect(find.byKey(const ValueKey('onboarding-skip')), findsNothing);
  });

  testWidgets('create-room action is reported once', (tester) async {
    final exits = <OnboardingExit>[];
    await pumpScreen(tester, onFinish: (exit) async => exits.add(exit));
    await goToLastPage(tester);

    await tester.tap(find.byKey(const ValueKey('onboarding-primary-cta')));
    await tester.pumpAndSettle();

    expect(exits, [OnboardingExit.createRoom]);
  });

  testWidgets('secondary action explores the app', (tester) async {
    final exits = <OnboardingExit>[];
    await pumpScreen(tester, onFinish: (exit) async => exits.add(exit));
    await goToLastPage(tester);

    await tester.tap(find.byKey(const ValueKey('onboarding-secondary-cta')));
    await tester.pumpAndSettle();

    expect(exits, [OnboardingExit.explore]);
  });

  testWidgets('skip closes the introduction as explore', (tester) async {
    final exits = <OnboardingExit>[];
    await pumpScreen(tester, onFinish: (exit) async => exits.add(exit));
    await tester.tap(find.byKey(const ValueKey('onboarding-dot-2')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('onboarding-skip')));
    await tester.pumpAndSettle();

    expect(exits, [OnboardingExit.explore]);
  });

  testWidgets('system back goes to the previous page', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.byKey(const ValueKey('onboarding-dot-2')));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.textContaining('Không còn cãi nhau'), findsOneWidget);
  });

  testWidgets('replay mode closes without skipping the flag', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        builder: (context, child) => MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: child!,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              key: const ValueKey('open-replay'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const OnboardingScreen(replay: true),
                ),
              ),
              child: const Text('Mở giới thiệu'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-replay')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('onboarding-close')), findsOneWidget);
    expect(find.byKey(const ValueKey('onboarding-skip')), findsNothing);

    for (var i = 0; i < 4; i++) {
      await tapNext(tester);
    }
    expect(find.text('Đã hiểu'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('onboarding-primary-cta')));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.text('Mở giới thiệu'), findsOneWidget);
  });

  testWidgets('small screen and large text do not overflow', (tester) async {
    await pumpScreen(tester, size: const Size(320, 568), textScale: 2);

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const ValueKey('onboarding-primary-cta')),
      findsOneWidget,
    );

    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -260),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('motion can be disabled without leaving tickers running', (
    tester,
  ) async {
    await pumpScreen(tester, reduceMotion: true);
    await tester.pump(const Duration(seconds: 3));

    expect(tester.takeException(), isNull);
  });

  testWidgets('exposes labels for assistive technologies', (tester) async {
    final handle = tester.ensureSemantics();

    await pumpScreen(tester);

    expect(find.bySemanticsLabel('Trang 1 trên 5'), findsOneWidget);
    expect(find.bySemanticsLabel('Bỏ qua'), findsOneWidget);
    expect(find.bySemanticsLabel('Bắt đầu'), findsOneWidget);
    expect(find.bySemanticsLabel('Trang 1'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('double tapping the CTA finishes only once', (tester) async {
    var calls = 0;
    await pumpScreen(
      tester,
      onFinish: (exit) async {
        calls++;
      },
    );
    await goToLastPage(tester);

    await tester.tap(find.byKey(const ValueKey('onboarding-primary-cta')));
    await tester.tap(find.byKey(const ValueKey('onboarding-primary-cta')));
    await tester.pumpAndSettle();

    expect(calls, 1);
  });
}
