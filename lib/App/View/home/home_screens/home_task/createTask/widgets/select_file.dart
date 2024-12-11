import 'package:flutter/material.dart';

Column SelectFile(_selectImagesFromGallery, _takePhoto, _pickFile) {
  return Column(
    children: [
      InkWell(
        onTap: _selectImagesFromGallery,
        child: const Row(
          children: [
            Icon(
              Icons.image_outlined,
              color: Colors.green,
            ),
            SizedBox(width: 10),
            Text("Photos")
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      InkWell(
        onTap: _takePhoto,
        child: const Row(
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.blue,
            ),
            SizedBox(width: 10),
            Text("Camera")
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      InkWell(
        onTap: _pickFile,
        child: const Row(
          children: [
            Icon(
              Icons.file_present_outlined,
              color: Colors.grey,
            ),
            SizedBox(width: 10),
            Text("Files")
          ],
        ),
      ),
    ],
  );
}
