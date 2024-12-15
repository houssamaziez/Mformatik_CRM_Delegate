import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveFile(Uint8List fileBytes, String name, String ext) async {
  try {
    // Get the directory where you want to save the file
    final directory =
        await getExternalStorageDirectory(); // Get external storage directory
    if (directory == null) {
      print("Directory not found!");
      return;
    }

    // Define initial directory path (you can set it to any desired folder)
    final dirInstance = Directory(directory.path);
    final fileName =
        "$name-${DateTime.now().millisecondsSinceEpoch}.$ext"; // Modify as needed

    // Show the file picker to save the file
    final result = await FilePicker.platform.saveFile(
      bytes: fileBytes,
      type: FileType.any, // Set the file type
      initialDirectory: dirInstance.path, // Directory to start file picker
      fileName: fileName, // Name of the file
    );

    if (result != null) {
      print("File saved at: $result");
    } else {
      print("No file was saved.");
    }
  } catch (e) {
    print("Error saving file: $e");
  }
}
