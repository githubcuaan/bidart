import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders async state without owning providers, retries or empty-state rules.
class AsyncContent<T> extends StatelessWidget {
  const AsyncContent({
    super.key,
    required this.value,
    required this.dataBuilder,
    required this.errorBuilder,
    this.loadingBuilder,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = false,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final Widget Function(
    BuildContext context,
    Object error,
    StackTrace stackTrace,
  )
  errorBuilder;
  final WidgetBuilder? loadingBuilder;
  final bool skipLoadingOnRefresh;
  final bool skipLoadingOnReload;

  @override
  Widget build(BuildContext context) => value.when(
    skipLoadingOnRefresh: skipLoadingOnRefresh,
    skipLoadingOnReload: skipLoadingOnReload,
    loading: () =>
        loadingBuilder?.call(context) ??
        const Center(child: CircularProgressIndicator()),
    error: (error, stackTrace) => errorBuilder(context, error, stackTrace),
    data: (data) => dataBuilder(context, data),
  );
}
