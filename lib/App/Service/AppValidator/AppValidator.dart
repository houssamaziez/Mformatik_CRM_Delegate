import 'package:get/get.dart';

class AppValidator {
  // Validates required text fields
  static String? validateRequired(String? value,
      {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName'.tr + ' ' + 'is required.'.tr;
    }
    return null;
  }

  // Validates length of a text field
  static String? validateLength(String? value,
      {int? minLength, int? maxLength, String fieldName = 'This field'}) {
    if (minLength != null && (value == null || value.length < minLength)) {
      return '$fieldName'.tr +
          ' ' +
          'must be at least'.tr +
          ' $minLength ' +
          'characters.'.tr;
    }
    if (maxLength != null && (value != null && value.length > maxLength)) {
      return '$fieldName'.tr +
          ' ' +
          'must be no more than'.tr +
          ' $maxLength ' +
          'characters.'.tr;
    }
    return null;
  }

  // Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.'.tr;
    }
    // Basic email pattern
    final emailPattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Please enter a valid email address.'.tr;
    }
    return null;
  }

  // Validates password with minimum length
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.length < minLength) {
      return 'Password must be at least $minLength characters.'.tr;
    }
    return null;
  }

  // Validates phone number format
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.'.tr;
    }
    // Basic phone number pattern (customize for your region)
    final phonePattern = r'^[0-9]{10}$';
    if (!RegExp(phonePattern).hasMatch(value)) {
      return 'Please enter a valid phone number.'.tr;
    }
    return null;
  }

  // Combines multiple validators
  static String? validate(
      String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}
