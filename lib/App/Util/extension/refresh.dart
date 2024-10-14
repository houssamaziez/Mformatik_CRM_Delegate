import 'package:flutter/material.dart';

extension RefreshWidget on Widget {
  /// Wraps the widget with a `RefreshIndicator` for pull-to-refresh functionality
  RefreshIndicator addRefreshIndicator({
    required Future<void> Function() onRefresh,
    Color backgroundColor = Colors.white,
    Color color = Colors.blue,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: backgroundColor,
      color: color,
      child: this,
    );
  }
}
