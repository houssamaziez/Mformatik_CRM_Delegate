
import 'dart:io';

import 'package:flutter/material.dart';

import '../../task_details/profile_task.dart';

Padding showfile(_compressedImages, _deleteImage, _selectedFiles, _deleteFile) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Container(
      color: Colors.white,
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._compressedImages!.asMap().entries.map((entry) {
            int index = entry.key; // Index from asMap()
            File image = entry.value; // File from the list
            return Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Stack(
                    children: [
                      Image.file(
                        image,
                        fit: BoxFit.cover,
                        width: 120,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () => _deleteImage(index),
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          // Display selected files
          ..._selectedFiles.asMap().entries.map((entry) {
            int index = entry.key; // Index from asMap()
            File file = entry.value; // File from the list
            return Card(
              color: Colors.white,
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            returnIconFile(file.path),
                            height: 50,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            file.path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow
                                .ellipsis, // Truncate long file names
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.delete,
                            size: 20, color: Colors.red),
                        onPressed: () =>
                            _deleteFile(index), // Call delete function
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    ),
  );
}
