import 'package:flutter/material.dart';

extension ListViewWithPagination on ListView {
  Widget withPagination({
    required ScrollController controller,
    required bool isLoadingMore,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    required VoidCallback onEndReached,
    double threshold =
        200, // المسافة قبل الوصول للنهاية التي تُعتبر إشارة للتحميل
  }) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels >=
            scrollNotification.metrics.maxScrollExtent - threshold) {
          if (!isLoadingMore) {
            onEndReached(); // استدعاء عند الوصول إلى نهاية القائمة
          }
        }
        return false;
      },
      child: ListView.builder(
        controller: controller,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
