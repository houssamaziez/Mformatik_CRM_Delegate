import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../Controller/home/task_controller.dart';
import '../../../../../Model/task.dart';

//  if 1 to
class ShowExcel extends StatefulWidget {
  const ShowExcel({
    super.key,
    required this.listitem,
    required this.taskId,
    required this.taskItemId,
    required this.name,
  });
  final List name;
  final List listitem;
  final String taskId, taskItemId;

  @override
  State<ShowExcel> createState() => _ShowExcelState();
}

class _ShowExcelState extends State<ShowExcel> {
  final TextEditingController _controller = TextEditingController();
  File? _image;
  File? _file;
  int _selectedIndex = 0;

  // Pick an image using the image_picker package
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Pick a file using the file_picker package
  Future<void> _pickFile() async {
    // Add logic to pick a file (e.g., using a file_picker package)
    // Example: final result = await FilePicker.platform.pickFiles();
  }

  // Send message, image, or file
  void _sendMessage() {
    if (_controller.text.isNotEmpty || _image != null || _file != null) {
      // Logic for sending message, image, or file
      print("Message Sent: ${_controller.text}");
      if (_image != null) {
        print("Image Sent: ${_image!.path}");
      }
      if (_file != null) {
        print("File Sent: ${_file!.path}");
      }

      // Clear the text field and reset the image/file
      setState(() {
        _controller.clear();
        _image = null;
        _file = null;
      });
    }
  }

  // Handle bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _openExcelInDevice(Uint8List excelBytes, String name) async {
    try {
      // Get the directory for temporary files
      final directory = await getTemporaryDirectory();

      // Create a file path for the Excel file
      final filePath = '${directory.path}/$name.xlsx';

      // Write the Excel bytes to the file
      final file = File(filePath);
      await file.writeAsBytes(excelBytes);

      // Open the file with the default application
      final result = await OpenFile.open(filePath);

      // Handle result (Optional)
      if (result.type != ResultType.done) {
        debugPrint('Failed to open the file: ${result.message}');
      }
    } catch (e) {
      debugPrint('Error opening Excel file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskController = Get.put(TaskController());

      taskController.cleanListExcel();
      for (var action in widget.listitem) {
        taskController.downloadfile(
          taskId: widget.taskId,
          taskItemId: widget.taskItemId,
          attachmentId: action["id"].toString(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Files'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<TaskController>(
            init: TaskController(),
            builder: (taskController) {
              if (taskController.ListExcel.isEmpty) {
                return const Center(
                  child: spinkit,
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two files per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: widget.name.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _openExcelInDevice(
                        taskController.ListExcel[index],
                        extractFileName(widget.name[index])),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[300],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: taskController.ListPDF.length > index
                          ? Column(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/icons/excel.png"),
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Text(extractFileName(widget.name[index])),
                                )
                              ],
                            )
                          : spinkit,
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

String extractFileName(String filePath) {
  // Extract the file name with extension from the file path
  final fileNameWithExtension = filePath.split('/').last;

  // Remove the file extension ('.xlsx' in this case)
  final fileNameWithoutExtension =
      fileNameWithExtension.replaceAll(RegExp(r'\.xlsx$'), '');

  // Extract the part after the last hyphen
  final nameParts = fileNameWithoutExtension.split('-');
  final lastPart = nameParts.isNotEmpty ? nameParts.last : '';

  return lastPart;
}
