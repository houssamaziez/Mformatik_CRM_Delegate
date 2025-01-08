import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mformatic_crm_delegate/App/Util/convert/convert_bytes.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../../Controller/home/Task/task_controller.dart';
import '../../../../../../Service/save_file.dart';

class ShowPDFs extends StatefulWidget {
  const ShowPDFs({
    super.key,
    required this.listitem,
    required this.taskId,
    required this.taskItemId,
    required this.name,
    required this.extention,
  });

  final String extention;
  final List<FileModel> name;
  final List<FileModel>  listitem ;
  final String taskId, taskItemId;

  @override
  State<ShowPDFs> createState() => _ShowPDFsState();
}

class _ShowPDFsState extends State<ShowPDFs> {
  bool islaoding = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskController = Get.put(TaskController());
      taskController.cleanListPDF();
      taskController.cleanListExcel();
      setState(() {
        islaoding = true;
      });

      setState(() {
        islaoding = false;
      });
    });
  }

dispose() {
  super.dispose();
   
}
  returnimagefile() {
    switch (widget.extention) {
      case "pdf":
        return Image.asset(
          "assets/icons/pdf.png",
          height: 30,
        );
      case "doc":
        return Image.asset(
          "assets/icons/doc.png",
          height: 30,
        );
      case "docx":
        return Image.asset(
          "assets/icons/doc.png",
          height: 30,
        );
      case "xlsx":
        return Image.asset(
          "assets/icons/excel.png",
          height: 30,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All files'.tr),
        centerTitle: true,
      ),
      body: GetBuilder<TaskController>(
        init: TaskController(),
        builder: (taskController) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: widget.name.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
Logger(). i(widget.name[index].name);

                      // return ;
                      widget.name[index] =
                          widget.name[index].copyWith(isdownload: true);
                      final Uint8List ff =
                          await taskController.downloadFileStream(
                              isShow: true,
                              taskId: widget.taskId,
                              taskItemId: widget.taskItemId,
                              attachmentId: widget.name[index].id,
                              index: index,
                              name: extractFileName(
                                widget.name[index].name,
                              ));
                      widget.name[index] =
                          widget.name[index].copyWith(isdownload: false);
                      widget.name[index] =
                          widget.name[index].copyWith(baytes: ff);
                      openExcelInDevice(
                          widget.name[index].baytes!,
                          extractFileName(
                            widget.name[index].name,
                          ),
                          widget.extention);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(8.0)),
                      height: 60,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                returnimagefile(),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    extractFileName(
                                      widget.name[index].name,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (taskController.totalBytes != 0 &&
                              index == taskController.downloadselect)
                            Text(
                              convertBytes(taskController.totalBytes),
                            ),
                          Spacer(),
                          if (widget.name[index].baytes != null &&
                                  widget.name[index].baytes!.isNotEmpty ||
                              fileCache.containsKey(
                                  '${widget.taskId}-${widget.taskItemId}-${widget.name[index].id}'))
                            IconButton(
                                onPressed: () async {
                                  await saveFile(
                                      widget.name[index].baytes!,
                                      extractFileName(
                                        widget.name[index].name,
                                      ),
                                      widget.extention);
                                },
                                icon: const Icon(Icons.download))
                        ],
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

class FileModel {
  final String name;
  final String id;
  final bool isdownload;
  final Uint8List? baytes;

  FileModel({
    this.baytes,
    required this.name,
    required this.id,
    this.isdownload = false,
  });

  FileModel copyWith({
    Uint8List? baytes,
    bool? isdownload,
  }) {
    return FileModel(
      name: name ?? this.name,
      baytes: baytes ?? this.baytes,
      id: id ?? this.id,
      isdownload: isdownload ?? this.isdownload,
    );
  }
}

Future<void> openExcelInDevice(
    Uint8List excelBytes, String name, String extenstion) async {
  try {
    // Get the directory for temporary files
    final directory = await getTemporaryDirectory();

    // Create a file path for the Excel file
    final filePath = '${directory.path}/$name.$extenstion';

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
