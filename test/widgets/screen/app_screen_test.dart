import 'package:bidart/widgets/screen/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renders body without adding layout wrappers', (tester) async {
    const body = SizedBox(key: ValueKey('body'));

    await tester.pumpWidget(const MaterialApp(home: AppScreen(body: body)));

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(find.byType(Scaffold), findsOneWidget);
    expect(scaffold.body, same(body));
    expect(scaffold.appBar, isNull);
    expect(scaffold.floatingActionButton, isNull);
    expect(scaffold.bottomNavigationBar, isNull);
    expect(scaffold.resizeToAvoidBottomInset, isNull);
  });

  testWidgets('Renders custom app bar, FAB and bottom bar', (tester) async {
    var actionCount = 0;
    var fabCount = 0;
    var submitCount = 0;
    final appBar = AppBar(
      title: const Text('Page title'),
      actions: [
        IconButton(
          tooltip: 'Page action',
          onPressed: () => actionCount++,
          icon: const Icon(Icons.settings),
        ),
      ],
    );
    final fab = FloatingActionButton(
      onPressed: () => fabCount++,
      child: const Icon(Icons.add),
    );
    final bottomBar = SafeArea(
      child: FilledButton(
        onPressed: () => submitCount++,
        child: const Text('Submit'),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: AppScreen(
          appBar: appBar,
          body: const Text('Page body'),
          floatingActionButton: fab,
          bottomNavigationBar: bottomBar,
        ),
      ),
    );

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.appBar, same(appBar));
    expect(scaffold.floatingActionButton, same(fab));
    expect(scaffold.bottomNavigationBar, same(bottomBar));
    expect(find.text('Page title'), findsOneWidget);
    expect(find.text('Page body'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);

    await tester.tap(find.byTooltip('Page action'));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.tap(find.text('Submit'));

    expect(actionCount, 1);
    expect(fabCount, 1);
    expect(submitCount, 1);
  });

  for (final resize in [true, false]) {
    testWidgets('Forwards resizeToAvoidBottomInset: $resize', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppScreen(
            body: const SizedBox(),
            resizeToAvoidBottomInset: resize,
          ),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.resizeToAvoidBottomInset, resize);
    });
  }
}
