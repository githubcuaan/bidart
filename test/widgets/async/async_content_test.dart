import 'package:bidart/widgets/async/async_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpContent<T>(
    WidgetTester tester,
    AsyncValue<T> value, {
    Widget Function(BuildContext, T)? dataBuilder,
    Widget Function(BuildContext, Object, StackTrace)? errorBuilder,
    WidgetBuilder? loadingBuilder,
    bool skipLoadingOnRefresh = true,
    bool skipLoadingOnReload = false,
  }) => tester.pumpWidget(
    MaterialApp(
      home: AsyncContent<T>(
        value: value,
        dataBuilder: dataBuilder ?? (_, data) => Text('Data: $data'),
        errorBuilder: errorBuilder ?? (_, error, _) => Text('Error: $error'),
        loadingBuilder: loadingBuilder,
        skipLoadingOnRefresh: skipLoadingOnRefresh,
        skipLoadingOnReload: skipLoadingOnReload,
      ),
    ),
  );

  testWidgets('Shows default loading indicator', (tester) async {
    await pumpContent<int>(tester, const AsyncLoading());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('Uses custom loading builder', (tester) async {
    await pumpContent<int>(
      tester,
      const AsyncLoading(),
      loadingBuilder: (_) => const Text('Custom loading'),
    );

    expect(find.text('Custom loading'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Passes typed data and context to builder', (tester) async {
    await pumpContent<int>(
      tester,
      const AsyncData(42),
      dataBuilder: (context, data) {
        expect(Theme.of(context), isNotNull);
        expect(data, 42);
        return Text('Result: $data');
      },
    );

    expect(find.text('Result: 42'), findsOneWidget);
  });

  testWidgets('Passes error and stack trace; retry stays caller-owned', (
    tester,
  ) async {
    final error = StateError('Failed');
    final stackTrace = StackTrace.current;
    var retryCount = 0;

    await pumpContent<int>(
      tester,
      AsyncError(error, stackTrace),
      errorBuilder: (context, actualError, actualStackTrace) {
        expect(actualError, same(error));
        expect(actualStackTrace, same(stackTrace));
        return TextButton(
          onPressed: () => retryCount++,
          child: const Text('Retry'),
        );
      },
    );

    await tester.tap(find.text('Retry'));
    expect(retryCount, 1);
  });

  testWidgets('Passes populated and empty lists to data builder', (
    tester,
  ) async {
    for (final items in <List<int>>[
      [1, 2],
      [],
    ]) {
      await pumpContent<List<int>>(
        tester,
        AsyncData(items),
        dataBuilder: (_, data) {
          expect(data, same(items));
          return Text('Count: ${data.length}');
        },
      );

      expect(find.text('Count: ${items.length}'), findsOneWidget);
    }
  });

  testWidgets('Passes null to nullable data builder', (tester) async {
    await pumpContent<String?>(
      tester,
      const AsyncData(null),
      dataBuilder: (_, data) {
        expect(data, isNull);
        return Text(data ?? 'No value');
      },
    );

    expect(find.text('No value'), findsOneWidget);
  });

  for (final isRefresh in [true, false]) {
    for (final skipLoading in [true, false]) {
      testWidgets(
        '${isRefresh ? 'Refresh' : 'Reload'} with skipLoading=$skipLoading',
        (tester) async {
          final dependency = Provider<int>((ref) => 0);
          final provider = FutureProvider<int>((ref) async {
            ref.watch(dependency);
            return 42;
          });
          final container = ProviderContainer(
            overrides: [dependency.overrideWithValue(0)],
          );
          addTearDown(container.dispose);
          final subscription = container.listen(provider, (_, _) {});
          addTearDown(subscription.close);
          await container.read(provider.future);

          if (isRefresh) {
            container.invalidate(provider);
          } else {
            container.updateOverrides([dependency.overrideWithValue(1)]);
          }
          final value = container.read(provider);
          expect(value.isRefreshing, isRefresh);
          expect(value.isReloading, !isRefresh);

          await pumpContent<int>(
            tester,
            value,
            skipLoadingOnRefresh: isRefresh ? skipLoading : true,
            skipLoadingOnReload: isRefresh ? false : skipLoading,
          );

          expect(
            find.text('Data: 42'),
            skipLoading ? findsOneWidget : findsNothing,
          );
          expect(
            find.byType(CircularProgressIndicator),
            skipLoading ? findsNothing : findsOneWidget,
          );
          await tester.pump(const Duration(milliseconds: 1));
        },
      );
    }
  }
}
