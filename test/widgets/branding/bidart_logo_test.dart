import 'package:bidart/core/theme/app_theme.dart';
import 'package:bidart/widgets/branding/bidart_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpWordmark(
    WidgetTester tester, {
    required ThemeData theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(body: BidartWordmark()),
      ),
    );
  }

  testWidgets('wordmark renders BiDART with brand colours', (tester) async {
    await pumpWordmark(tester, theme: AppTheme.dark);

    final text = tester.widget<Text>(find.byType(Text));
    final span = text.textSpan! as TextSpan;
    final parts = span.children!.cast<TextSpan>();
    final scheme = AppTheme.dark.colorScheme;

    expect(span.toPlainText(), 'BiDART');
    expect(parts[0].text, 'Bi');
    expect(parts[0].style!.color, scheme.primary);
    expect(parts[1].text, 'DART');
    expect(parts[1].style!.color, scheme.onSurface);
  });

  testWidgets('lockup shows the mark and the wordmark', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: BidartLogo()))),
    );

    expect(find.byType(BidartLogoMark), findsOneWidget);
    expect(find.byType(BidartWordmark), findsOneWidget);
    expect(find.text('BiDART'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
