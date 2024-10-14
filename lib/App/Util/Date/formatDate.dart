import 'package:intl/intl.dart';

String formatDate(String dateString) {
  //TODO:study extension methods in dart
  try {
    // Parse the date string
    final DateTime dateTime = DateTime.parse(dateString);

    // Define the desired format
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    // Format the date
    return formatter.format(dateTime);
  } catch (e) {
    print('Error parsing date: $e');
    return '';
  }
}
