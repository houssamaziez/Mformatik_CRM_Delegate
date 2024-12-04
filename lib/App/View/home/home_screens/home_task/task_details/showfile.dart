import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/task_controller.dart';

import '../../../../widgets/flutter_spinkit.dart';

class ShowImages extends StatefulWidget {
  const ShowImages(
      {super.key,
      required this.listitem,
      required this.taskId,
      required this.taskItemId});
  final List listitem;
  final String taskId, taskItemId;

  @override
  State<ShowImages> createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskController = Get.put(TaskController());
      taskController.cleanListImage();
      for (var action in widget.listitem) {
        taskController.downloadfile(
          taskId: widget.taskId,
          taskItemId: widget.taskItemId,
          attachmentId: action["id"].toString(),
        );
      }
    });
  }

  void _showImageFullScreen(Uint8List imageBytes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageBytes: imageBytes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
        centerTitle: true,
      ),
      body: GetBuilder<TaskController>(
        init: TaskController(),
        builder: (taskController) {
          if (taskController.ListImage.isEmpty) {
            return const Center(
              child: spinkit,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two images per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: taskController.ListImage.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      _showImageFullScreen(taskController.ListImage[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        taskController.ListImage[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final Uint8List imageBytes;

  const FullScreenImage({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Image.memory(
          imageBytes,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
