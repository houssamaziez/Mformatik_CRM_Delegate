String convertBytes(int bytes) {
  if (bytes < 1024) {
    return '${bytes} B';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(2)} KB';
  } else if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / 1024 / 1024).toStringAsFixed(2)} MB';
  } else {
    return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
  }
}

void main() {
  int bytes = 18674039;
  String formattedSize = convertBytes(bytes);
  print(formattedSize); // Output: 17.80 MB
}
