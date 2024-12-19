import 'package:get/get.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');
String formatDate(String dateString) {
  //TODO:study extension methods in dart
  try {
    // Parse the date string
    final DateTime dateTime = DateTime.parse(dateString);

    // Define the desired format

    // Format the date
    return formatter.format(dateTime.toLocal());
  } catch (e) {
    print('Error parsing date: $e');
    return '';
  }
}

String timeDifference(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 365) {
    return '${(difference.inDays ~/ 365)} ' +
        'year'.tr +
        (difference.inDays ~/ 365 > 1 ? '' : '');
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ' +
        'day'.tr +
        (difference.inDays > 1 ? '' : '');
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ' +
        'hour'.tr +
        (difference.inHours > 1 ? '' : '');
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ' +
        'minute'.tr +
        (difference.inMinutes > 1 ? '' : '');
  } else {
    return '${difference.inSeconds} ' +
        'second'.tr +
        (difference.inSeconds > 1 ? '' : '');
  }
}

String timeUntilDeadline(DateTime deadline) {
  final now = DateTime.now();
  final difference = deadline.difference(now);

  if (difference.isNegative) {
    return 'Expired'.tr;
  }

  if (difference.inDays > 365) {
    return 'Remaining:'.tr +
        " ${(difference.inDays ~/ 365)} " +
        'year'.tr +
        (difference.inDays ~/ 365 > 1 ? '' : '');
  } else if (difference.inDays > 0) {
    return 'Remaining:'.tr +
        " ${difference.inDays} " +
        'day'.tr +
        (difference.inDays > 1 ? '' : '');
  } else if (difference.inHours > 0) {
    return 'Remaining:'.tr +
        " ${difference.inHours} " +
        'hour'.tr +
        (difference.inHours > 1 ? '' : '');
  } else if (difference.inMinutes > 0) {
    return 'Remaining:'.tr +
        " ${difference.inMinutes} " +
        'minute'.tr +
        (difference.inMinutes > 1 ? '' : '');
  } else {
    return 'Remaining:'.tr +
        " ${difference.inSeconds} " +
        'second'.tr +
        (difference.inSeconds > 1 ? '' : '');
  }
}
