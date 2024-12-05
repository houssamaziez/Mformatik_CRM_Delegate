import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/task_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_task/task_details/widgets/listItems.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../widgets/Dialog/showExitConfirmationDialog.dart';
import 'widgets/buildTaskHeader.dart';
import 'widgets/taskInformation.dart';

class TaskProfileScreen extends StatefulWidget {
  final int taskId;

  TaskProfileScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskProfileScreen> createState() => _TaskProfileScreenState();
}

class _TaskProfileScreenState extends State<TaskProfileScreen> {
  TaskController taskController = Get.put(TaskController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskController.getTaskById(context, widget.taskId);
    });
    super.initState();
  }

  TextEditingController _controller = TextEditingController();
  List<File> _selectedImages = []; // Store selected images
  List<File> _selectedFiles = []; // Store selected files

  Future<void> _pickImage() async {
    // Pick multiple images using image_picker package
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        // Add selected images to the list
        _selectedImages
            .addAll(images.map((image) => File(image.path)).toList());
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _deleteFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _pickFile() async {
    // Open the file picker dialog with allowed extensions and multiple file selection
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      allowMultiple: true, // Allow multiple file selection
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        // Add selected files to the list
        _selectedFiles
            .addAll(result.files.map((file) => File(file.path!)).toList());
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      print("Message sent: ${_controller.text}");
      _controller.clear();
    }

    // Reset image and file selection
    setState(() {
      _selectedImages.clear();
      _selectedFiles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mission Details'.tr),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomSheet: bottomSheet(context),
      body: GetBuilder<TaskController>(
        init: TaskController(),
        builder: (controller) {
          if (controller.isLoadingProfile) {
            return const Center(child: spinkit);
          }
          if (controller.task == null) {
            return Center(child: Text('Mission not found'.tr));
          }
          final task = controller.task!;

          return Scaffold(
            floatingActionButton: Column(
              children: [
                const Spacer(),
                if (task.statusId == 1)
                  FloatingActionButton.extended(
                      heroTag: "IN_PROGRESS", // Unique tag for the first button
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        showExitConfirmationDialog(context,
                            onPressed: () async {
                          Get.back();

                          await controller.changeStatuseMission(
                              2, widget.taskId);
                        },
                            details: 'Are you sure to Start the Mission?'.tr,
                            title: 'Cnfirmation'.tr);
                      },
                      label: Text(
                        "Start Mission".tr,
                        style: const TextStyle(color: Colors.white),
                      )),
                const SizedBox(
                  height: 20,
                ),
                if (task.statusId == 2)
                  FloatingActionButton.extended(
                      heroTag:
                          "addFeedback2", // Unique tag for the first button

                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {},
                      label: Text(
                        "Add Feedback".tr,
                        style: const TextStyle(color: Colors.white),
                      )),
              ],
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTaskHeader(context, task),
                      const SizedBox(height: 16),
                      taskInformation(controller),
                      const SizedBox(height: 16),
                      const Text(
                        "commenter",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                listItems(
                  controller: controller,
                ),
              ],
            ).addRefreshIndicator(
                onRefresh: () =>
                    taskController.getTaskById(context, widget.taskId)),
          );
        },
      ),
    );
  }

  Container bottomSheet(BuildContext context) {
    return Container(
      color: Colors.white,
      height:
          (_selectedImages.isNotEmpty || _selectedFiles.isNotEmpty) ? 200 : 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: Colors.transparent,
                overlayColor: Colors.white,
                overlayOpacity: 0.0,
                spacing: 0,
                elevation: 0,
                spaceBetweenChildren: 8,
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.camera_alt, color: Colors.white),
                    backgroundColor: Colors.grey,
                    label: 'Camera',
                    labelStyle: TextStyle(fontSize: 16.0),
                    onTap: () => print('Camera Selected'),
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.photo, color: Colors.white),
                    backgroundColor: Colors.grey,
                    label: 'Gallery',
                    labelStyle: TextStyle(fontSize: 16.0),
                    onTap: _pickImage,
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.attach_file, color: Colors.white),
                    backgroundColor: Colors.grey,
                    label: 'File',
                    labelStyle: TextStyle(fontSize: 16.0),
                    onTap: _pickFile,
                  ),
                ],
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(30),
                        ),
                  ),
                ),
              ),
              IconButton(
                icon: Image.asset(
                  "assets/icons/send.png",
                  height: 20,
                ),
                onPressed: _sendMessage,
              ),
            ],
          ),
          if (_selectedImages.isNotEmpty || _selectedFiles.isNotEmpty)
            Container(
              color: Colors.white,
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ..._selectedImages.asMap().entries.map((entry) {
                    int index = entry.key; // Index from asMap()
                    File image = entry.value; // File from the list
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Stack(
                          children: [
                            Image.file(
                              image,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                onPressed: () => _deleteImage(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  // Display selected files
                  ..._selectedFiles.asMap().entries.map((entry) {
                    int index = entry.key; // Index from asMap()
                    File file = entry.value; // File from the list
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              child: Column(
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
                              left: 0,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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
        ],
      ),
    );
  }
}

String returnIconFile(String path) {
  if (imgFileTypes.any((type) => path.toString().contains(type))) {
    return "assets/icons/photo.png";
  }
  if (pdfFileTypes.any((type) => path.toString().contains(type))) {
    return "assets/icons/pdf.png";
  }
  if (excelFileTypes.any((type) => path.toString().contains(type))) {
    return "assets/icons/excel.png";
  }

  return "assets/icons/photo.png";
}
