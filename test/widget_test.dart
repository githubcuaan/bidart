import 'package:bidart/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts with an empty scaffold', (tester) async {
    await tester.pumpWidget(const BidartApp());

    expect(find.byType(Scaffold), findsOneWidget);
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).title, 'Bidart');
    expect(tester.takeException(), isNull);
  });
}
