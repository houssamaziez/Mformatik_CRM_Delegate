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

import '../../../../../Util/extention/file.dart';
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

  Future<void> _takePhoto() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImages!.add(File(photo.path));
      });
    }
  }

  _sendMessage() async {
    List<String> listpathipdf = [];
    List<String> listImage = [];
    List<String> listExcel = [];

    // Convert List<File> to List<String> containing file paths
    List<String> imagePaths = _selectedImages.map((file) => file.path).toList();

    if (_selectedFiles != null) {
      _selectedFiles.forEach((action) {
        if (imgFileTypes.any((type) => action.path.contains(type))) {
          listImage.add(action.path.toString());
          print("The file is an image.");
        } else if (voiceFileTypes.any((type) => action.path.contains(type))) {
          print("The file is a voice file.");
        } else if (videoFileTypes.any((type) => action.path.contains(type))) {
          print("The file is a video.");
        } else if (pdfFileTypes.any((type) => action.path.contains(type))) {
          listpathipdf.add(action.path.toString());

          print("The file is a PDF.");
        } else if (excelFileTypes.any((type) => action.path.contains(type))) {
          listExcel.add(action.path.toString());

          print("The file is an Excel document.");
        } else {
          print("Unknown file type.");
        }
      });
    } else {
      print("Content-Type header is missing.");
    }
    // Call the createItems method with the converted imagePaths
    await taskController.createItems(
      desc: _controller.text,
      taskId: widget.taskId.toString(),
      imgPaths: imagePaths,
      excelPaths: listExcel,
      pdfPaths: listpathipdf,
    );

    // Check if the description is not empty
    if (_controller.text.isNotEmpty) {
      print("Message sent: ${_controller.text}");
      _controller.clear(); // Clear the text controller after sending
    }

    // Reset image and file selection
    setState(() {
      _selectedImages.clear(); // Clear the selected images
      _selectedFiles.clear(); // Clear the selected files (if any)
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
                        "Discussion",
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
          (_selectedImages.isNotEmpty || _selectedFiles.isNotEmpty) ? 220 : 80,
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
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                animatedIconTheme:
                    IconThemeData(color: Theme.of(context).primaryColor),
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
                    onTap: _takePhoto,
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
              GetBuilder<TaskController>(
                  init: TaskController(),
                  builder: (teskbuildController) {
                    return teskbuildController.issend
                        ? spinkit
                        : IconButton(
                            icon: Image.asset(
                              "assets/icons/send.png",
                              height: 20,
                            ),
                            onPressed: _sendMessage,
                          );
                  }),
            ],
          ),
          if (_selectedImages.isNotEmpty || _selectedFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                color: Colors.white,
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._selectedImages.asMap().entries.map((entry) {
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
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
                                  onPressed: () => _deleteFile(
                                      index), // Call delete function
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
