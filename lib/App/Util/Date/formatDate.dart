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
    return '${(difference.inDays ~/ 365)} year${(difference.inDays ~/ 365) > 1 ? 's' : ''}';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
  } else {
    return '${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''}';
  }
}

String timeUntilDeadline(DateTime deadline) {
  final now = DateTime.now();
  final difference = deadline.difference(now);

  if (difference.isNegative) {
    return 'Expired';
  }

  if (difference.inDays > 365) {
    return 'Remaining: ${(difference.inDays ~/ 365)} year${(difference.inDays ~/ 365) > 1 ? "s" : ""}';
  } else if (difference.inDays > 0) {
    return 'Remaining: ${difference.inDays} day${difference.inDays > 1 ? "s" : ""}';
  } else if (difference.inHours > 0) {
    return 'Remaining: ${difference.inHours} hour${difference.inHours > 1 ? "s" : ""}';
  } else if (difference.inMinutes > 0) {
    return 'Remaining: ${difference.inMinutes} minute${difference.inMinutes > 1 ? "s" : ""}';
  } else {
    return 'Remaining: ${difference.inSeconds} second${difference.inSeconds > 1 ? "s" : ""}';
  }
}
