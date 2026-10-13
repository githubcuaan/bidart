import 'package:bidart/main.dart';
import 'package:bidart/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App starts with an empty scaffold', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BidartApp()));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).title, 'Bidart');
    expect(tester.takeException(), isNull);
  });

  testWidgets('App entry point installs a provider scope', (tester) async {
    app.main();
    await tester.pump();

    expect(find.byType(ProviderScope), findsOneWidget);
    expect(find.byType(BidartApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
